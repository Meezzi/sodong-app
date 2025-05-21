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
  final String createdAt;
  final String userId;

  factory PostDetail.fromJson(Map<String, dynamic> json) {
    return PostDetail(
      postId: json['postId'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      imageUrl: List<String>.from(json['imageUrl'] ?? []),
      location: json['location'] ?? '',
      category: json['category'] ?? '',
      createdAt: json['createdAt'] ?? '',
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'location': location,
      'category': category,
      'createdAt': createdAt,
      'userId': userId,
    };
  }
}
