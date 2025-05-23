import 'package:sodong_app/features/post_detail/domain/entities/comment_entity.dart';

/// 댓글 관련 기능을 정의한 추상 리포지토리 인터페이스
abstract interface class CommentRepository {
  Future<List<Comment>> getComments(String postId);

  Stream<List<Comment>> getCommentsStream(String postId);

  Future<void> addComment(String postId, String content);
}
