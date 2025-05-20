import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sodong_app/features/post/domain/entities/region.dart';
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
    required this.imageUrls,
  });

  final String postId;
  final TownLifeCategory category;
  final String title;
  final String content;
  final Region region;
  final DateTime createdAt;
  final bool isAnonymous;
  final String userId;
  final String nickname;
  final int commentCount;
  final List<String> imageUrls;

  factory Post.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Post(
      postId: snapshot.id,
      category: TownLifeCategory.fromId(data['category'] as String),
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      region: Region.fromFirestore(data['region']),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isAnonymous: data['isAnonymous'] ?? false,
      userId: data['userId'] ?? '',
      nickname: data['nickname'] ?? '',
      commentCount: data['commentCount'] ?? 0,
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'postId': postId,
      'category': category.id,
      'title': title,
      'content': content,
      'region': region.toFirestore(),
      'createdAt': Timestamp.fromDate(createdAt),
      'isAnonymous': isAnonymous,
      'userId': userId,
      'nickname': nickname,
      'commentCount': commentCount,
      'imageUrls': imageUrls,
    };
  }

  Post copyWith({
    String? postId,
    TownLifeCategory? category,
    String? title,
    String? content,
    Region? region,
    DateTime? createdAt,
    bool? isAnonymous,
    String? userId,
    String? nickname,
    int? commentCount,
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
      imageUrls: imageUrl ?? imageUrls,
    );
  }
}
