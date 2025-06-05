import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sodong_app/features/post/domain/entities/post.dart';

class PostDto {
  PostDto({
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
  final String category;
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

  factory PostDto.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return PostDto(
      postId: snapshot.id,
      category: data['category'] ?? '',
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      region: data['region'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isAnonymous: data['isAnonymous'] ?? false,
      userId: data['userId'] ?? '',
      nickname: data['nickname'] ?? '',
      commentCount: data['commentCount'] ?? 0,
      profileImageUrl: data['profileImageUrl'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'postId': postId,
      'category': category,
      'title': title,
      'content': content,
      'region': region,
      'createdAt': Timestamp.fromDate(createdAt),
      'isAnonymous': isAnonymous,
      'userId': userId,
      'nickname': nickname,
      'commentCount': commentCount,
      'profileImageUrl': profileImageUrl,
      'imageUrls': imageUrls,
    };
  }

  PostDto copyWith({
    String? postId,
    String? category,
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
    return PostDto(
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

  /// Post Entity -> Post Dto 변환
  static PostDto fromEntity(Post post) {
    return PostDto(
      postId: post.postId,
      category: post.category,
      title: post.title,
      content: post.content,
      region: post.region,
      createdAt: post.createdAt,
      isAnonymous: post.isAnonymous,
      userId: post.userId,
      nickname: post.nickname,
      commentCount: post.commentCount,
      profileImageUrl: post.profileImageUrl,
      imageUrls: post.imageUrls,
    );
  }

  /// Post Dto -> Post Entity 변환
  Post toEntity(PostDto dto) {
    return Post(
      postId: dto.postId,
      category: dto.category,
      title: dto.title,
      content: dto.content,
      region: dto.region,
      createdAt: dto.createdAt,
      isAnonymous: dto.isAnonymous,
      userId: dto.userId,
      nickname: dto.nickname,
      commentCount: dto.commentCount,
      profileImageUrl: dto.profileImageUrl,
      imageUrls: dto.imageUrls,
    );
  }
}
