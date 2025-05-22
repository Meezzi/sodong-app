import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory PostDetail.fromJson(Map<String, dynamic> json) {
    DateTime createdDate = DateTime.now();

    try {
      final createdAtValue = json['createdAt'];
      if (createdAtValue is Timestamp) {
        createdDate = createdAtValue.toDate();
      }
    } catch (e) {
      // Timestamp 변환 실패 시 현재 시간 사용
      print('Timestamp 변환 실패: $e');
    }

    return PostDetail(
      postId: json['postId'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      imageUrl: List<String>.from(json['imageUrl'] ?? []),
      location: json['location'] ?? '',
      category: json['category'] ?? '',
      createdAt: createdDate,
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
      'createdAt': Timestamp.fromDate(createdAt),
      'userId': userId,
    };
  }
}
