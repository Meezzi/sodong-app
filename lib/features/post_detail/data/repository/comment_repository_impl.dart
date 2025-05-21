import 'package:sodong_app/features/post_detail/data/data_sources/comment_data_source.dart';
import 'package:sodong_app/features/post_detail/domain/entities/comment_entity.dart';
import 'package:sodong_app/features/post_detail/domain/repositories/comment_repository.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentDataSource service;

  CommentRepositoryImpl(this.service);

  @override
  Future<List<Comment>> getComments(String postId) async {
    final result = await service.fetchComments(postId);
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
