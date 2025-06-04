import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/post_detail/data/providers/comment_provider.dart';
import 'package:sodong_app/features/post_detail/domain/entities/comment_entity.dart';
import 'package:sodong_app/features/post_detail/presentation/viewmodels/comment_view_model.dart';
import 'package:tuple/tuple.dart';

final commentViewModelProvider = StateNotifierProvider.family<CommentViewModel,
    List<Comment>, Tuple4<String, String, String, String>>(
  (ref, params) {
    final location = params.item1;
    final category = params.item2;
    final postId = params.item3;
    final userId = params.item4;

    final getCommentsUseCase = ref.watch(getCommentsUseCaseProvider);
    final addCommentUseCase = ref.watch(addCommentUseCaseProvider);

    return CommentViewModel(
      getCommentsUseCase: getCommentsUseCase,
      addCommentUseCase: addCommentUseCase,
      location: location,
      category: category,
      postId: postId,
      userId: userId,
    );
  },
);
