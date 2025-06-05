import 'package:sodong_app/features/comment/data/data_sources/comment_data_source.dart';
import 'package:sodong_app/features/comment/domain/entities/comment_entity.dart';
import 'package:sodong_app/features/comment/domain/repositories/comment_repository.dart';

class CommentRepositoryImpl implements CommentRepository {
  CommentRepositoryImpl(this.service);
  final CommentDataSource service;

  /// 댓글 스트림을 받아 Comment 객체 리스트로 변환
  @override
  Stream<List<Comment>> getCommentsStream(
      String location, String category, String postId) {
    return service
        .fetchCommentsStream(
          location: location,
          category: category,
          postId: postId,
        )
        .map((list) => list
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
  Future<List<Comment>> getComments(
      String location, String category, String postId) async {
    final result = await service
        .fetchCommentsStream(
          location: location,
          category: category,
          postId: postId,
        )
        .first;

    return result.map((data) {
      return Comment(
        id: data['id'],
        postId: postId,
        content: data['content'],
        createdAt: data['createdAt'],
      );
    }).toList();
  }

  /// 댓글 추가 요청
  @override
  Future<void> addComment(
      String location, String category, String postId, String content) {
    return service.postComment(
      location: location,
      category: category,
      postId: postId,
      content: content,
    );
  }
}
