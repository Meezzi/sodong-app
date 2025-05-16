class PostService {
  // 싱글톤으로 구성
  static final PostService _instance = PostService._internal();
  factory PostService() => _instance;
  PostService._internal();
}
