import 'package:sodong_app/features/post_detail/domain/entities/comment_entity.dart';
import 'package:sodong_app/features/post_detail/domain/repositories/comment_repository.dart';

class GetCommentsUseCase {
  GetCommentsUseCase(this.repository);
  final CommentRepository repository;

  Future<List<Comment>> call(String postId) {
    return repository.getComments(postId);
  }

  Stream<List<Comment>> stream(String postId) {
    return repository.getCommentsStream(postId);
  }
}
