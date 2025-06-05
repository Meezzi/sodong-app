class Comment {
  Comment({
    required this.id,
    required this.postId,
    required this.content,
    required this.createdAt,
  });
  final String id;
  final String postId;
  final String content;
  final DateTime createdAt;
}
