import 'package:sodong_app/features/post_detail/domain/repositories/comment_repository.dart';

class AddCommentUseCase {
  final CommentRepository repository;

  AddCommentUseCase(this.repository);

  Future<void> call(String postId, String content) {
    return repository.addComment(postId, content);
  }
}
