import 'package:cloud_firestore/cloud_firestore.dart';

class CommentDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 특정 게시물(postId)의 댓글 서브컬렉션 실시간 스트림
  Stream<List<Map<String, dynamic>>> fetchCommentsStream(String postId) {
    return _firestore
        .collection('posts')
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

  Future<void> postComment(String postId, String content) async {
    await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add({
      'content': content,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
