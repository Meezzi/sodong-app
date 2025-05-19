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

  static const int pageSize = 10;
  int _currentPage = 0;
  bool _hasMore = true;
  final List<TownLifePost> _cachedPosts = [];
  DocumentSnapshot? _lastDocument;
  int _totalItemCount = 0; // 전체 문서 수를 저장

  // 현재 선택된 지역과 카테고리
  String _currentRegionId = 'seoul';
  String _currentCategory = 'question';

  // Firestore 인스턴스
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 선택된 지역 설정
  void setRegion(Region region) {
    if (_currentRegionId != region.id) {
      _currentRegionId = region.id;
      // 지역이 변경되면 캐시를 초기화
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

  // 초기 게시물 가져오기
  Future<List<TownLifePost>> fetchInitialPosts() async {
    _currentPage = 0;
    _hasMore = true;
    _cachedPosts.clear();
    _lastDocument = null;
    _totalItemCount = 0;

    try {
      // 먼저 컬렉션에 있는 문서 수를 가져옵니다
      final countQuery = await _firestore
          .collection('posts')
          .doc(_currentRegionId)
          .collection(_currentCategory)
          .count()
          .get();

      _totalItemCount = countQuery.count ?? 0;

      // 데이터가 없으면 빈 리스트 반환
      if (_totalItemCount == 0) {
        _hasMore = false;
        return [];
      }

      // 선택된 지역의 선택된 카테고리 게시물을 최신순으로 가져오기
      final querySnapshot = await _firestore
          .collection('posts')
          .doc(_currentRegionId)
          .collection(_currentCategory)
          .orderBy('createdAt', descending: true)
          .limit(pageSize)
          .get();

      if (querySnapshot.docs.isEmpty) {
        _hasMore = false;
        return [];
      }

      _lastDocument = querySnapshot.docs.last;

      final posts = querySnapshot.docs.map((doc) {
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
      var posts = generateDummyPosts(pageSize, startIndex: 0);
      _cachedPosts.addAll(posts);
      _currentPage++;
      return posts;
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
      // 이전에 가져온 마지막 문서 이후부터 가져오기
      final querySnapshot = await _firestore
          .collection('posts')
          .doc(_currentRegionId)
          .collection(_currentCategory)
          .orderBy('createdAt', descending: true)
          .startAfterDocument(_lastDocument!)
          .limit(pageSize)
          .get();

      if (querySnapshot.docs.isEmpty) {
        _hasMore = false;
        return [];
      }

      _lastDocument = querySnapshot.docs.last;

      final posts = querySnapshot.docs.map((doc) {
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
