import '../repositories/comment_repository.dart';

class AddCommentUseCase {
  final CommentRepository repository;

  AddCommentUseCase(this.repository);

  Future<void> call(String postId, String content) {
    return repository.addComment(postId, content);
  }
}
