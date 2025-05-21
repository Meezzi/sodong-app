import 'package:cloud_firestore/cloud_firestore.dart';

class CommentDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchComments(String postId) async {
    final snapshot = await _firestore
        .collection('comments')
        .doc(postId)
        .collection('commentList')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'content': data['content'],
        'createdAt': (data['createdAt'] as Timestamp).toDate(),
      };
    }).toList();
  }

  Future<void> postComment(String postId, String content) async {
    await _firestore
        .collection('comments')
        .doc(postId)
        .collection('commentList')
        .add({
      'content': content,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
