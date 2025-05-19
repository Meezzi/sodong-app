import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sodong_app/features/post_list/domain/models/category.dart';
import 'package:sodong_app/features/post_list/domain/models/town_life_post.dart';
import 'package:sodong_app/features/post_list/domain/models/firestore_post.dart';
import 'package:sodong_app/features/post_list/domain/models/region.dart';

class PostRepository {
  PostRepository._internal();
  // 생성자를 다른 멤버 선언 전에 배치
  factory PostRepository() => _instance;
  // 싱글톤으로 구성
  static final PostRepository _instance = PostRepository._internal();

  // 한글 지역명을 영문으로 변환하는 매핑 테이블
  static const Map<String, String> _koToEnRegionMap = {
    // 서울
    '강남': 'gangnam',
    '강동': 'gangdong',
    '강북': 'gangbuk',
    '강서': 'gangseo',
    '관악': 'gwanak',
    '광진': 'gwangjin',
    '구로': 'guro',
    '금천': 'geumcheon',
    '노원': 'nowon',
    '도봉': 'dobong',
    '동대문': 'dongdaemun',
    '동작': 'dongjak',
    '마포': 'mapo',
    '서대문': 'seodaemun',
    '서초': 'seocho',
    '성동': 'seongdong',
    '성북': 'seongbuk',
    '송파': 'songpa',
    '양천': 'yangcheon',
    '영등포': 'yeongdeungpo',
    '용산': 'yongsan',
    '은평': 'eunpyeong',
    '종로': 'jongno',
    '중구': 'junggu',
    '중랑': 'jungnang',
  };

  // 부산 지역 매핑 테이블 (중복 방지)
  static const Map<String, String> _busanRegionMap = {
    '강서': 'gangseo',
    '금정': 'geumjeong',
    '기장': 'gijang',
    '남구': 'namgu',
    '동구': 'donggu',
    '동래': 'dongnae',
    '부산진': 'busanjin',
    '북구': 'bukgu',
    '사상': 'sasang',
    '사하': 'saha',
    '서구': 'seogu',
    '수영': 'suyeong',
    '연제': 'yeonje',
    '영도': 'yeongdo',
    '중구': 'junggu',
    '해운대': 'haeundae',
  };

  static const int pageSize = 10;
  int _currentPage = 0;
  bool _hasMore = true;
  final List<TownLifePost> _cachedPosts = [];
  DocumentSnapshot? _lastDocument;
  int _totalItemCount = 0; // 전체 문서 수를 저장

  // 현재 선택된 지역과 카테고리
  String _currentRegionId = 'seoul';
  String _currentSubRegion = '';
  String _currentCategory = 'question';

  // Firestore 인스턴스
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 선택된 지역 설정
  void setRegion(Region region) {
    if (_currentRegionId != region.id) {
      _currentRegionId = region.id;
      _currentSubRegion = region.subRegions.first;
      // 지역이 변경되면 캐시를 초기화
      _cachedPosts.clear();
      _lastDocument = null;
      _currentPage = 0;
      _hasMore = true;
      _totalItemCount = 0;
    }
  }

  // 선택된 하위 지역 설정
  void setSubRegion(String subRegion) {
    if (_currentSubRegion != subRegion) {
      _currentSubRegion = subRegion;
      // 하위 지역이 변경되면 캐시를 초기화
      _cachedPosts.clear();
      _lastDocument = null;
      _currentPage = 0;
      _hasMore = true;
      _totalItemCount = 0;
    }
  }

  // 선택된 카테고리 설정
  void setCategory(String category) {
    if (_currentCategory != category) {
      _currentCategory = category;
      // 카테고리가 변경되면 캐시를 초기화
      _cachedPosts.clear();
      _lastDocument = null;
      _currentPage = 0;
      _hasMore = true;
      _totalItemCount = 0;
    }
  }

  // 문서 ID 생성 (지역_하위지역 형식)
  String _getDocumentId() {
    // 하위 지역이 없으면 그냥 지역 ID 반환
    if (_currentSubRegion.isEmpty) {
      return _currentRegionId;
    }

    // 하위 지역에서 '구', '군', '시' 제거
    String koreanName = _currentSubRegion
        .replaceAll('구', '')
        .replaceAll('시', '')
        .replaceAll('군', '');

    // 한글 지역명을 영문으로 변환 (지역에 따라 다른 매핑 테이블 사용)
    String englishName;
    if (_currentRegionId == 'busan') {
      englishName = _busanRegionMap[koreanName] ?? koreanName.toLowerCase();
    } else {
      englishName = _koToEnRegionMap[koreanName] ?? koreanName.toLowerCase();
    }

    print(
        '지역 변환: $_currentRegionId, $koreanName -> ${_currentRegionId}_$englishName');

    // {도시}_{구} 형식으로 반환 (seoul_gangnam, busan_haeundae 등)
    return '${_currentRegionId}_$englishName';
  }

  // 초기 게시물 가져오기
  Future<List<TownLifePost>> fetchInitialPosts() async {
    _currentPage = 0;
    _hasMore = true;
    _cachedPosts.clear();
    _lastDocument = null;
    _totalItemCount = 0;

    try {
      // 문서 ID 생성
      final docId = _getDocumentId();
      print('Fetching initial posts from path: posts/$docId/$_currentCategory');

      // 먼저 컬렉션에 있는 문서 수를 가져옵니다
      final countQuery = await _firestore
          .collection('posts')
          .doc(docId)
          .collection(_currentCategory)
          .count()
          .get();

      _totalItemCount = countQuery.count ?? 0;
      print('Total documents count: $_totalItemCount');

      // 데이터가 없으면 빈 리스트 반환
      if (_totalItemCount == 0) {
        print('No documents found in posts/$docId/$_currentCategory');
        _hasMore = false;
        return [];
      }

      // 선택된 지역의 선택된 카테고리 게시물을 최신순으로 가져오기
      final querySnapshot = await _firestore
          .collection('posts')
          .doc(docId)
          .collection(_currentCategory)
          .orderBy('createdAt', descending: true)
          .limit(pageSize)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('Query returned empty results');
        _hasMore = false;
        return [];
      }

      print('Fetched ${querySnapshot.docs.length} documents');
      _lastDocument = querySnapshot.docs.last;

      final posts = querySnapshot.docs.map((doc) {
        print('Processing document ID: ${doc.id}');
        final firestorePost = FirestorePost.fromFirestore(doc);
        return firestorePost.toTownLifePost();
      }).toList();

      _cachedPosts.addAll(posts);
      _currentPage++;

      // 가져온 문서 수가 전체 문서 수와 같거나 pageSize보다 작으면 더 이상 데이터가 없음
      if (posts.length < pageSize || posts.length >= _totalItemCount) {
        _hasMore = false;
      }

      return posts;
    } catch (e) {
      // 에러 발생 시 더미 데이터 반환 (개발 중에는 유용)
      print('Firestore 데이터 로드 에러: $e');

      // 개발 환경이라면 더미 데이터 반환
      if (true) {
        var posts = generateDummyPosts(pageSize, startIndex: 0);
        _cachedPosts.addAll(posts);
        _currentPage++;
        return posts;
      }

      _hasMore = false;
      return [];
    }
  }

  // 추가 게시물 가져오기 (무한 스크롤용)
  Future<List<TownLifePost>> fetchMorePosts() async {
    if (!_hasMore || _lastDocument == null) {
      return [];
    }

    // 이미 모든 데이터를 가져왔으면 더 이상 불러오지 않음
    if (_cachedPosts.length >= _totalItemCount) {
      _hasMore = false;
      return [];
    }

    try {
      // 문서 ID 생성
      final docId = _getDocumentId();
      print('Fetching more posts from path: posts/$docId/$_currentCategory');

      // 이전에 가져온 마지막 문서 이후부터 가져오기
      final querySnapshot = await _firestore
          .collection('posts')
          .doc(docId)
          .collection(_currentCategory)
          .orderBy('createdAt', descending: true)
          .startAfterDocument(_lastDocument!)
          .limit(pageSize)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('No more documents found');
        _hasMore = false;
        return [];
      }

      print('Fetched ${querySnapshot.docs.length} more documents');
      _lastDocument = querySnapshot.docs.last;

      final posts = querySnapshot.docs.map((doc) {
        print('Processing document ID: ${doc.id}');
        final firestorePost = FirestorePost.fromFirestore(doc);
        return firestorePost.toTownLifePost();
      }).toList();

      _cachedPosts.addAll(posts);
      _currentPage++;

      // 가져온 문서 수가 pageSize보다 작거나, 총 가져온 문서 수가 전체 문서 수와 같으면 더 이상 데이터가 없음
      if (posts.length < pageSize || _cachedPosts.length >= _totalItemCount) {
        _hasMore = false;
      }

      return posts;
    } catch (e) {
      // 에러 발생 시 더 이상 데이터가 없다고 처리
      print('Firestore 추가 데이터 로드 에러: $e');
      _hasMore = false;
      return [];
    }
  }

  // 현재 캐시된 게시물 가져오기
  List<TownLifePost> getCachedPosts() {
    return List.unmodifiable(_cachedPosts);
  }

  // 추가 게시물 존재여부
  bool get hasMorePosts => _hasMore;

  // 특정 지역에 맞게 필터링
  List<TownLifePost> filterByRegion(String regionId, String? subRegion) {
    return _cachedPosts.where((post) {
      if (regionId != post.regionId) {
        return false;
      }
      if (subRegion != null && subRegion != post.subRegion) {
        return false;
      }
      return true;
    }).toList();
  }

  // 특정 카테고리에 맞게 필터링
  List<TownLifePost> filterByCategory(TownLifeCategory category) {
    if (category == TownLifeCategory.all) {
      return _cachedPosts;
    }
    return _cachedPosts.where((post) => post.categoryEnum == category).toList();
  }
}
