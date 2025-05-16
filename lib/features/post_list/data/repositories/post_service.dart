import 'package:sodong_app/features/post_list/domain/models/town_life_post.dart';

class PostService {
  // 싱글톤으로 구성
  static final PostService _instance = PostService._internal();
  factory PostService() => _instance;
  PostService._internal();

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

    final posts = generateDummyPosts(pageSize, startIndex: 0);
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

    final posts =
        generateDummyPosts(pageSize, startIndex: _currentPage * pageSize);
    _cachedPosts.addAll(posts);
    _currentPage++;

    return posts;
  }

  // 현재 캐시된 게시물 가져오기
  List<TownLifePost> getCachedPosts() {
    return List.unmodifiable(_cachedPosts);
  }
}
