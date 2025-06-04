import 'package:sodong_app/features/post_detail/domain/repositories/comment_repository.dart';

class AddCommentUseCase {
  AddCommentUseCase(this.repository);
  final CommentRepository repository;

  /// 댓글을 추가하는 유즈케이스 (userId 포함)
  Future<void> call(
    String location,
    String category,
    String postId,
    String content,
    String userId,
  ) {
    return repository.addComment(location, category, postId, content, userId);
  }
}
