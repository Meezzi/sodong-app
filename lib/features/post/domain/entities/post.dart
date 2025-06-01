import 'package:sodong_app/features/post_list/domain/models/category.dart';

class Post {
  Post({
    required this.postId,
    required this.category,
    required this.title,
    required this.content,
    required this.region,
    required this.createdAt,
    required this.isAnonymous,
    required this.userId,
    required this.nickname,
    required this.commentCount,
    required this.profileImageUrl,
    required this.imageUrls,
  });

  final String postId;
  final TownLifeCategory category;
  final String title;
  final String content;
  final String region;
  final DateTime createdAt;
  final bool isAnonymous;
  final String userId;
  final String nickname;
  final int commentCount;
  final String profileImageUrl;
  final List<String> imageUrls;

  Post copyWith({
    String? postId,
    TownLifeCategory? category,
    String? title,
    String? content,
    String? region,
    DateTime? createdAt,
    bool? isAnonymous,
    String? userId,
    String? nickname,
    int? commentCount,
    String? profileImageUrl,
    List<String>? imageUrl,
  }) {
    return Post(
      postId: postId ?? this.postId,
      category: category ?? this.category,
      title: title ?? this.title,
      content: content ?? this.content,
      region: region ?? this.region,
      createdAt: createdAt ?? this.createdAt,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      userId: userId ?? this.userId,
      nickname: nickname ?? this.nickname,
      commentCount: commentCount ?? this.commentCount,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      imageUrls: imageUrl ?? imageUrls,
    );
  }
}
