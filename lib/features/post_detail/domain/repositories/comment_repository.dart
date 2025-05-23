import 'package:sodong_app/features/post_detail/domain/entities/comment_entity.dart';

abstract interface class CommentRepository {
  Future<List<Comment>> getComments(String postId);

  Stream<List<Comment>> getCommentsStream(String postId);

  Future<void> addComment(String postId, String content);
}
