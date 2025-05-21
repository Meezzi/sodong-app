import 'package:sodong_app/features/post_detail/domain/entities/comment_entity.dart';
import 'package:sodong_app/features/post_detail/domain/repositories/comment_repository.dart';

class GetCommentsUseCase {
  GetCommentsUseCase(this.repository);
  final CommentRepository repository;

  /// 댓글을 조회하는 유즈케이스
  Future<List<Comment>> call(String postId) {
    return repository.getComments(postId);
  }
}
