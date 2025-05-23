class PostDetail {
  PostDetail({
    required this.postId,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.location,
    required this.category,
    required this.createdAt,
    required this.userId,
  });
  final String postId;
  final String title;
  final String content;
  final List<String> imageUrl;
  final String location;
  final String category;
  final DateTime createdAt;
  final String userId;
}
