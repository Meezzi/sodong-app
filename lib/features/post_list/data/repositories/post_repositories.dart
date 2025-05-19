import 'package:sodong_app/features/post_list/domain/models/category.dart';
import 'package:sodong_app/features/post_list/domain/models/town_life_post.dart';

class PostRepositories {
  // 싱글톤으로 구성
  static final PostRepositories _instance = PostRepositories._internal();

  // 생성자를 다른 멤버 선언 전에 배치
  factory PostRepositories() => _instance;
  PostRepositories._internal();

  static const int pageSize = 10;
  int _currentPage = 0;
  bool _hasMore = true;
  final List<TownLifePost> _cachedPosts = [];

  // 초기 게시물 가져오기
  Future<List<TownLifePost>> fetchInitialPosts() async {
    // API 요청을 현실적으로 만들기 위해 지연 추가
    await Future.delayed(const Duration(milliseconds: 800));
    _currentPage = 0;
    _hasMore = true;
    _cachedPosts.clear();

    var posts = generateDummyPosts(pageSize, startIndex: 0);
    _cachedPosts.addAll(posts);
    _currentPage++;

    return posts;
  }

  // 추가 게시물 가져오기 (무한 스크롤용)
  Future<List<TownLifePost>> fetchMorePosts() async {
    if (!_hasMore) {
      return [];
    }

    // API 요청을 현실적으로 만들기 위해 지연 추가
    await Future.delayed(const Duration(milliseconds: 800));

    // 이 예제에서는 전체 데이터가 100개로 제한됩니다
    if (_currentPage * pageSize >= 100) {
      _hasMore = false;
      return [];
    }

    var posts =
        generateDummyPosts(pageSize, startIndex: _currentPage * pageSize);
    _cachedPosts.addAll(posts);
    _currentPage++;

    return posts;
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
