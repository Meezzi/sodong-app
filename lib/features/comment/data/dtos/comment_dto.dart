import 'package:cloud_firestore/cloud_firestore.dart';

class CommentDto {
  CommentDto({
    required this.id,
    required this.postId,
    required this.userId,
    required this.content,
    required this.createdAt,
  });

  final String id;
  final String postId;
  final String userId;
  final String content;
  final DateTime createdAt;

  factory CommentDto.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CommentDto(
      id: doc.id,
      postId: data['postId'],
      userId: data['userId'],
      content: data['content'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'postId': postId,
        'userId': userId,
        'content': content,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
