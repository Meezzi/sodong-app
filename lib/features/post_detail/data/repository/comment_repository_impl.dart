import 'package:sodong_app/features/post_detail/data/data_sources/comment_data_source.dart';
import 'package:sodong_app/features/post_detail/domain/entities/comment_entity.dart';
import 'package:sodong_app/features/post_detail/domain/repositories/comment_repository.dart';

class CommentRepositoryImpl implements CommentRepository {
  CommentRepositoryImpl(this.service);
  final CommentDataSource service;

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
                  postId: data['postId'],
                  userId: data['userId'],
                  content: data['content'],
                  createdAt: data['createdAt'],
                ))
            .toList());
  }

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

    return result
        .map((data) => Comment(
              id: data['id'],
              postId: data['postId'],
              userId: data['userId'],
              content: data['content'],
              createdAt: data['createdAt'],
            ))
        .toList();
  }

  @override
  Future<void> addComment(
    String location,
    String category,
    String postId,
    String content,
    String userId,
  ) {
    return service.postComment(
      location: location,
      category: category,
      postId: postId,
      content: content,
      userId: userId,
    );
  }
}
