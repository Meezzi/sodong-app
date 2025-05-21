import 'package:sodong_app/features/post_detail/domain/repositories/comment_repository.dart';

class AddCommentUseCase {
  AddCommentUseCase(this.repository);
  final CommentRepository repository;

  /// 댓글을 추가하는 유즈케이스
  Future<void> call(String postId, String content) {
    return repository.addComment(postId, content);
  }
}
