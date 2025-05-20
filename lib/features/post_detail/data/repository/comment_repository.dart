import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sodong_app/features/post_detail/data/dtos/comment_dto.dart';

class CommentRepository {
  final FirebaseFirestore firestore;
  CommentRepository({required this.firestore});

  Future<void> addComment(Comment comment) async {
    final ref = firestore
        .collection('comments')
        .doc(comment.postId)
        .collection('commentList')
        .doc();
    await ref.set(comment.toFirestore());
  }

  Future<List<Comment>> fetchComments(String postId) async {
    final snapshot = await firestore
        .collection('comments')
        .doc(postId)
        .collection('commentList')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => Comment.fromFirestore(doc)).toList();
  }
}
