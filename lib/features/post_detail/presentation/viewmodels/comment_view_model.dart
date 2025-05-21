import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/post_detail/domain/entities/comment_entity.dart';
import 'package:sodong_app/features/post_detail/domain/usecases/add_comment_usecase.dart';
import 'package:sodong_app/features/post_detail/domain/usecases/get_comment_usecase.dart';

class CommentViewModel extends StateNotifier<List<Comment>> {
  final GetCommentsUseCase getCommentsUseCase;
  final AddCommentUseCase addCommentUseCase;
  final String postId;

  CommentViewModel({
    required this.getCommentsUseCase,
    required this.addCommentUseCase,
    required this.postId,
  }) : super([]) {
    loadComments();
  }

  Future<void> loadComments() async {
    final comments = await getCommentsUseCase(postId);
    state = comments;
  }

  Future<void> addComment(String content) async {
    await addCommentUseCase(postId, content);
    await loadComments();
  }
}
