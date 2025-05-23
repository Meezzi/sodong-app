import 'package:cloud_firestore/cloud_firestore.dart';

class CommentDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 특정 게시물의 댓글 스트림
  Stream<List<Map<String, dynamic>>> fetchCommentsStream({
    required String location,
    required String category,
    required String postId,
  }) {
    return _firestore
        .collection('posts')
        .doc(location.trim())
        .collection(category)
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return {
                'id': doc.id,
                'content': data['content'],
                'createdAt': (data['createdAt'] as Timestamp).toDate(),
              };
            }).toList());
  }

  /// 댓글 추가
  Future<void> postComment({
    required String location,
    required String category,
    required String postId,
    required String content,
  }) async {
    await _firestore
        .collection('posts')
        .doc(location.trim())
        .collection(category)
        .doc(postId)
        .collection('comments')
        .add({
      'content': content,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
