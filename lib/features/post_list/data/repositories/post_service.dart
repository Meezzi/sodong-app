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


}
