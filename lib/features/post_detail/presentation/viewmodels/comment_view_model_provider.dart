import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/post_detail/data/providers/comment_provider.dart';
import 'package:sodong_app/features/post_detail/domain/entities/comment_entity.dart';
import 'package:sodong_app/features/post_detail/presentation/viewmodels/comment_view_model.dart';

/// 특정 게시물 ID별 CommentViewModel을 제공하는 StateNotifierProvider
final commentViewModelProvider =
    StateNotifierProvider.family<CommentViewModel, List<Comment>, String>(
  (ref, postId) {
    final getCommentsUseCase = ref.watch(getCommentsUseCaseProvider);
    final addCommentUseCase = ref.watch(addCommentUseCaseProvider);

    return CommentViewModel(
      getCommentsUseCase: getCommentsUseCase,
      addCommentUseCase: addCommentUseCase,
      postId: postId,
    );
  },
);
