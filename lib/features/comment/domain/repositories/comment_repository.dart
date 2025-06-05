import 'package:sodong_app/features/comment/domain/entities/comment_entity.dart';

abstract class CommentRepository {
  Stream<List<Comment>> getCommentsStream(
      String location, String category, String postId);
  Future<List<Comment>> getComments(
      String location, String category, String postId);
  Future<void> addComment(
      String location, String category, String postId, String content);
}
