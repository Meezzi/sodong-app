import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sodong_app/features/post_detail/domain/entities/post_detail_entity.dart';

class PostDetailModel extends PostDetail {
  PostDetailModel({
    required super.postId,
    required super.title,
    required super.content,
    required super.imageUrl,
    required super.location,
    required super.category,
    required super.createdAt,
    required super.userId,
  });

  factory PostDetailModel.fromJson(Map<String, dynamic> json) {
    DateTime createdDate = DateTime.now();
    if (json['createdAt'] is Timestamp) {
      createdDate = (json['createdAt'] as Timestamp).toDate();
    }

    return PostDetailModel(
      postId: json['postId'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      imageUrl: List<String>.from(json['imageUrls'] ?? []),
      location: json['region'] ?? '',
      category: json['category'] ?? '',
      createdAt: createdDate,
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'postId': postId,
        'title': title,
        'content': content,
        'imageUrl': imageUrl,
        'location': location,
        'category': category,
        'createdAt': Timestamp.fromDate(createdAt),
        'userId': userId,
      };
}
