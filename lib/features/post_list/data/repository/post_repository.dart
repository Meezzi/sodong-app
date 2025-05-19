import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sodong_app/features/post_list/domain/models/category.dart';
import 'package:sodong_app/features/post_list/domain/models/town_life_post.dart';
import 'package:sodong_app/features/post_list/domain/models/firestore_post.dart';
import 'package:sodong_app/features/post_list/domain/models/region.dart';

class PostRepository {
  PostRepository._internal() {
    // 초기화 시 기본 선택된 지역에 대한 하위 지역 설정
    if (_currentSubRegion.isEmpty && regionList.isNotEmpty) {
      // regionList에서 현재 선택된 지역 ID에 맞는 지역 찾기
      final region = regionList.firstWhere(
        (r) => r.id == _currentRegionId,
        orElse: () => regionList.first,
      );

      // 해당 지역의 첫 번째 하위 지역 선택
      if (region.subRegions.isNotEmpty) {
        _currentSubRegion = region.subRegions.first;
        print('앱 초기화 - 선택된 지역: ${region.name}, 하위 지역: $_currentSubRegion');
      }
    }
  }

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

  // 경기도 지역 매핑 테이블 추가
  static const Map<String, String> _gyeonggiRegionMap = {
    '고양': 'goyang',
    '과천': 'gwacheon',
    '광명': 'gwangmyeong',
    '광주': 'gwangju',
    '구리': 'guri',
    '군포': 'gunpo',
    '김포': 'gimpo',
    '남양주': 'namyangju',
    '동두천': 'dongducheon',
    '부천': 'bucheon',
    '성남': 'seongnam',
    '수원': 'suwon',
    '시흥': 'siheung',
    '안산': 'ansan',
    '안성': 'anseong',
    '안양': 'anyang',
    '양주': 'yangju',
    '여주': 'yeoju',
    '오산': 'osan',
    '용인': 'yongin',
    '의왕': 'uiwang',
    '의정부': 'uijeongbu',
    '이천': 'icheon',
    '파주': 'paju',
    '평택': 'pyeongtaek',
    '포천': 'pocheon',
    '하남': 'hanam',
    '화성': 'hwaseong',
    '가평': 'gapyeong',
    '양평': 'yangpyeong',
    '연천': 'yeoncheon',
  };

  // 인천 지역 매핑 테이블 추가
  static const Map<String, String> _incheonRegionMap = {
    '계양': 'gyeyang',
    '남동': 'namdong',
    '동구': 'donggu',
    '미추홀': 'michuhol',
    '부평': 'bupyeong',
    '서구': 'seogu',
    '연수': 'yeonsu',
    '중구': 'junggu',
    '강화': 'ganghwa',
    '옹진': 'ongjin',
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
      print('지역 변경: $_currentRegionId, $_currentSubRegion');
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
      print('하위 지역 변경: $_currentSubRegion');
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
      print('카테고리 변경: $_currentCategory');
    }
  }

  // 문서 ID 생성 (지역_하위지역 형식)
  String _getDocumentId() {
    // 하위 지역이 없으면 첫 번째 하위 지역으로 설정
    if (_currentSubRegion.isEmpty) {
      // 현재 지역에 해당하는 Region 객체 찾기
      final region = regionList.firstWhere(
        (r) => r.id == _currentRegionId,
        orElse: () => regionList.first,
      );

      // 해당 지역의 첫 번째 하위 지역 사용
      if (region.subRegions.isNotEmpty) {
        _currentSubRegion = region.subRegions.first;
        print('하위 지역 자동 설정: $_currentSubRegion');
      } else {
        // 하위 지역이 없는 경우 기본값 설정
        return _currentRegionId;
      }
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
    } else if (_currentRegionId == 'gyeonggi') {
      englishName = _gyeonggiRegionMap[koreanName] ?? koreanName.toLowerCase();
    } else if (_currentRegionId == 'incheon') {
      englishName = _incheonRegionMap[koreanName] ?? koreanName.toLowerCase();
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
      print(
          'Total documents count: $_totalItemCount for category: $_currentCategory');

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
        print('Query returned empty results for category: $_currentCategory');
        _hasMore = false;
        return [];
      }

      print(
          'Fetched ${querySnapshot.docs.length} documents for category: $_currentCategory');
      _lastDocument = querySnapshot.docs.last;

      final posts = querySnapshot.docs.map((doc) {
        print(
            'Processing document ID: ${doc.id} from category: $_currentCategory');
        final firestorePost = FirestorePost.fromFirestore(doc);
        return firestorePost.toTownLifePost();
      }).toList();

      _cachedPosts.addAll(posts);
      _currentPage++;

      // 가져온 문서 수가 전체 문서 수와 같거나 pageSize보다 작으면 더 이상 데이터가 없음
      if (posts.length < pageSize || posts.length >= _totalItemCount) {
        _hasMore = false;
        print('No more data available for category: $_currentCategory');
      }

      return posts;
    } catch (e) {
      // 에러 발생 시 로그 출력하고 빈 리스트 반환
      print('Firestore 데이터 로드 에러: $e');
      print(
          '카테고리: $_currentCategory, 지역: $_currentRegionId $_currentSubRegion');

      // 에러 발생 시 더 이상 데이터가 없다고 처리
      _hasMore = false;
      return [];
    }
  }

  // 추가 게시물 가져오기 (무한 스크롤용)
  Future<List<TownLifePost>> fetchMorePosts() async {
    if (!_hasMore || _lastDocument == null) {
      print(
          '더 이상 가져올 데이터가 없습니다. hasMore: $_hasMore, lastDocument: ${_lastDocument != null}');
      return [];
    }

    // 이미 모든 데이터를 가져왔으면 더 이상 불러오지 않음
    if (_cachedPosts.length >= _totalItemCount) {
      _hasMore = false;
      print(
          '이미 모든 데이터를 가져왔습니다. 캐시된 게시물: ${_cachedPosts.length}, 전체 아이템: $_totalItemCount');
      return [];
    }

    try {
      // 문서 ID 생성
      final docId = _getDocumentId();
      print(
          'Fetching more posts from path: posts/$docId/$_currentCategory, page: $_currentPage');

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
        print('No more documents found for category: $_currentCategory');
        _hasMore = false;
        return [];
      }

      print(
          'Fetched ${querySnapshot.docs.length} more documents for category: $_currentCategory');
      _lastDocument = querySnapshot.docs.last;

      final posts = querySnapshot.docs.map((doc) {
        print(
            'Processing document ID: ${doc.id} from category: $_currentCategory');
        final firestorePost = FirestorePost.fromFirestore(doc);
        return firestorePost.toTownLifePost();
      }).toList();

      _cachedPosts.addAll(posts);
      _currentPage++;

      // 가져온 문서 수가 pageSize보다 작거나, 총 가져온 문서 수가 전체 문서 수와 같으면 더 이상 데이터가 없음
      if (posts.length < pageSize || _cachedPosts.length >= _totalItemCount) {
        _hasMore = false;
        print(
            'No more data after fetching more. Total cached: ${_cachedPosts.length}, Total count: $_totalItemCount');
      }

      return posts;
    } catch (e) {
      // 에러 발생 시 더 이상 데이터가 없다고 처리
      print('Firestore 추가 데이터 로드 에러: $e');
      print(
          '카테고리: $_currentCategory, 지역: $_currentRegionId $_currentSubRegion');
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

  // 전체 카테고리 데이터 로드를 위한 메서드 (모든 지역 데이터 포함)
  Future<List<TownLifePost>> fetchAllRegionsCategoryPosts(
      String category) async {
    try {
      print('전체 지역에서 $category 카테고리 데이터 로드 시작');

      // 기본 지역 리스트 (현재는 서울, 부산만 포함하지만 필요에 따라 확장 가능)
      List<String> regions = ['seoul', 'busan'];
      List<TownLifePost> allPosts = [];

      // 각 지역별로 처리
      for (String region in regions) {
        // 원래 지역 정보 저장
        final originalRegion = _currentRegionId;
        final originalSubRegion = _currentSubRegion;

        // 임시로 지역 변경 (원래 선택된 지역은 변경되지 않음)
        _currentRegionId = region;

        // 해당 지역의 메인 지역 가져오기 (첫 번째 하위 지역)
        final regionObj = regionList.firstWhere(
          (r) => r.id == region,
          orElse: () => regionList.first,
        );

        if (regionObj.subRegions.isNotEmpty) {
          _currentSubRegion = regionObj.subRegions.first;

          // 문서 ID 생성
          final docId = _getDocumentId();
          print('전체 카테고리 검색: posts/$docId/$category');

          try {
            // 해당 지역의 카테고리 게시물 가져오기
            final querySnapshot = await _firestore
                .collection('posts')
                .doc(docId)
                .collection(category)
                .orderBy('createdAt', descending: true)
                .limit(5) // 각 지역별로 일부 게시물만 가져옴
                .get();

            if (!querySnapshot.docs.isEmpty) {
              final posts = querySnapshot.docs.map((doc) {
                print('문서 처리: ${doc.id}, 지역: $region, 카테고리: $category');
                final firestorePost = FirestorePost.fromFirestore(doc);
                return firestorePost.toTownLifePost();
              }).toList();

              allPosts.addAll(posts);
              print('$region 지역에서 ${posts.length}개 게시물 로드됨');
            }
          } catch (e) {
            print('$region 지역 $category 카테고리 로드 중 오류: $e');
          }
        }

        // 원래 지역으로 복원
        _currentRegionId = originalRegion;
        _currentSubRegion = originalSubRegion;
      }

      // 최신순 정렬 (timeAgo 기준으로)
      allPosts.sort((a, b) {
        // 문자열 형태의 timeAgo를 비교하기 어려우므로
        // 댓글 수 기준으로 대체 정렬 (임시 방편)
        return b.commentCount.compareTo(a.commentCount);
      });

      print('전체 지역에서 총 ${allPosts.length}개 게시물 로드 완료');
      return allPosts;
    } catch (e) {
      print('전체 지역 데이터 로드 중 오류 발생: $e');
      return [];
    }
  }

  // 전체 카테고리 데이터 로드를 위한 메서드 (현재 선택된 지역의 데이터만 포함)
  Future<List<TownLifePost>> fetchCurrentRegionCategoryPosts(
      String category) async {
    try {
      print('현재 선택된 지역에서 $category 카테고리 데이터 로드 시작');
      List<TownLifePost> allPosts = [];

      // 선택된 지역 정보 사용
      final docId = _getDocumentId();
      print('전체 카테고리 검색 (현재 지역): posts/$docId/$category');

      try {
        // 현재 선택된 지역의 카테고리 게시물 가져오기
        final querySnapshot = await _firestore
            .collection('posts')
            .doc(docId)
            .collection(category)
            .orderBy('createdAt', descending: true)
            .limit(10) // 더 많은 게시물 가져오기
            .get();

        if (!querySnapshot.docs.isEmpty) {
          final posts = querySnapshot.docs.map((doc) {
            print('문서 처리: ${doc.id}, 지역: $_currentRegionId, 카테고리: $category');
            final firestorePost = FirestorePost.fromFirestore(doc);
            return firestorePost.toTownLifePost();
          }).toList();

          allPosts.addAll(posts);
          print('$_currentRegionId 지역에서 ${posts.length}개 게시물 로드됨');
        }
      } catch (e) {
        print('$_currentRegionId 지역 $category 카테고리 로드 중 오류: $e');
      }

      // 정렬 로직 유지
      allPosts.sort((a, b) {
        return b.commentCount.compareTo(a.commentCount);
      });

      print('현재 지역에서 총 ${allPosts.length}개 게시물 로드 완료');
      return allPosts;
    } catch (e) {
      print('지역 데이터 로드 중 오류 발생: $e');
      return [];
    }
  }
}
