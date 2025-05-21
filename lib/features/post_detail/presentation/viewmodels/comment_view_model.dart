import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/post_detail/domain/entities/comment_entity.dart';
import 'package:sodong_app/features/post_detail/domain/usecases/add_comment_usecase.dart';
import 'package:sodong_app/features/post_detail/domain/usecases/get_comment_usecase.dart';

class CommentViewModel extends StateNotifier<List<Comment>> {
  CommentViewModel({
    required this.getCommentsUseCase,
    required this.addCommentUseCase,
    required this.postId,
  }) : super([]) {
    loadComments();
  }
  final GetCommentsUseCase getCommentsUseCase;
  final AddCommentUseCase addCommentUseCase;
  final String postId;

  Future<void> loadComments() async {
    final comments = await getCommentsUseCase(postId);
    state = comments;
  }

  /// 뷰모델에서 댓글 추가 유즈케이스 호출하는 메서드
  Future<void> addComment(String content) async {
    await addCommentUseCase(postId, content);
    await loadComments();
  }
}
