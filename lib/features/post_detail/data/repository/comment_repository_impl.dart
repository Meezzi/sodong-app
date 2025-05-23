import 'package:sodong_app/features/post_detail/data/data_sources/comment_data_source.dart';
import 'package:sodong_app/features/post_detail/domain/entities/comment_entity.dart';
import 'package:sodong_app/features/post_detail/domain/repositories/comment_repository.dart';

class CommentRepositoryImpl implements CommentRepository {
  CommentRepositoryImpl(this.service);
  final CommentDataSource service;

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

  @override
  Future<void> addComment(String postId, String content) {
    return service.postComment(postId, content);
  }
}
