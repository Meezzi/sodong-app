import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sodong_app/features/post_list/domain/models/category.dart';

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
  final List<String> imageUrls;

  factory PostDto.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return PostDto(
      postId: snapshot.id,
      category: TownLifeCategory.fromId(data['category'] as String),
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      region: data['region'] ?? '',
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
      'region': region,
      'createdAt': Timestamp.fromDate(createdAt),
      'isAnonymous': isAnonymous,
      'userId': userId,
      'nickname': nickname,
      'commentCount': commentCount,
      'imageUrls': imageUrls,
    };
  }
}
