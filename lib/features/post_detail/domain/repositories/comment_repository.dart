import 'package:sodong_app/features/post_detail/domain/entities/comment_entity.dart';

/// 댓글을 추가하는 추상 인터페이스
abstract interface class CommentRepository {
  Future<List<Comment>> getComments(String postId);
  Future<void> addComment(String postId, String content);
}
