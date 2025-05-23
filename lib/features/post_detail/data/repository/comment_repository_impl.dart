import 'package:sodong_app/features/post_detail/data/data_sources/comment_data_source.dart';
import 'package:sodong_app/features/post_detail/domain/entities/comment_entity.dart';
import 'package:sodong_app/features/post_detail/domain/repositories/comment_repository.dart';

class CommentRepositoryImpl implements CommentRepository {
  CommentRepositoryImpl(this.service);
  final CommentDataSource service;

  /// 댓글 스트림을 받아 Comment 객체 리스트로 변환
  @override
  Stream<List<Comment>> getCommentsStream(String postId) {
    return service.fetchCommentsStream(postId).map((list) => list
        .map((data) => Comment(
              id: data['id'],
              postId: postId,
              content: data['content'],
              createdAt: data['createdAt'],
            ))
        .toList());
  }

  /// 한 번만 댓글 리스트를 받아오는 비동기 메서드
  @override
  Future<List<Comment>> getComments(String postId) async {
    final result = await service.fetchCommentsStream(postId).first;
    return result.map((data) {
      return Comment(
        id: data['id'],
        postId: postId,
        content: data['content'],
        createdAt: data['createdAt'],
      );
    }).toList();
  }

  /// 댓글 추가 요청을 데이터소스에 전달
  @override
  Future<void> addComment(String postId, String content) {
    return service.postComment(postId, content);
  }
}
