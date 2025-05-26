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
    required this.nickname,
    required this.profileImageUrl,
    required this.isAnonymous,
  });

  final String postId;
  final String title;
  final String content;
  final List<String> imageUrl;
  final String location;
  final String category;
  final DateTime createdAt;
  final String userId;
  final String nickname;
  final String profileImageUrl;
  final bool isAnonymous;

  PostDetail copyWith({
    String? postId,
    String? title,
    String? content,
    List<String>? imageUrl,
    String? location,
    String? category,
    DateTime? createdAt,
    String? userId,
    String? nickname,
    String? profileImageUrl,
    bool? isAnonymous,
  }) {
    return PostDetail(
      postId: postId ?? this.postId,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      nickname: nickname ?? this.nickname,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isAnonymous: isAnonymous ?? this.isAnonymous,
    );
  }
}
