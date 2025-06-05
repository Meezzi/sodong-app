import 'package:sodong_app/features/comment/domain/entities/comment_entity.dart';
import 'package:sodong_app/features/comment/domain/repositories/comment_repository.dart';

/// 댓글 조회 기능을 수행하는 유스케이스 클래스
class GetCommentsUseCase {
  GetCommentsUseCase(this.repository);
  final CommentRepository repository;

  /// 댓글 리스트를 비동기로 반환
  Future<List<Comment>> call(String location, String category, String postId) {
    return repository.getComments(location, category, postId);
  }

  /// 댓글 실시간 스트림을 반환
  Stream<List<Comment>> stream(
      String location, String category, String postId) {
    return repository.getCommentsStream(location, category, postId);
  }
}
