import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/post_detail/data/data_sources/comment_data_source.dart';
import 'package:sodong_app/features/post_detail/data/repository/comment_repository_impl.dart';
import 'package:sodong_app/features/post_detail/domain/entities/comment_entity.dart';
import 'package:sodong_app/features/post_detail/domain/usecases/comment_usecase.dart';
import 'package:sodong_app/features/post_detail/domain/usecases/get_comment_usecase.dart';
import 'package:sodong_app/features/post_detail/presentation/viewmodels/comment_view_model.dart';

final _serviceProvider = Provider((ref) => CommentDataSource());
final _repositoryProvider =
    Provider((ref) => CommentRepositoryImpl(ref.read(_serviceProvider)));

final commentViewModelProvider =
    StateNotifierProvider.family<CommentViewModel, List<Comment>, String>(
        (ref, postId) {
  final repo = ref.read(_repositoryProvider);
  return CommentViewModel(
    getCommentsUseCase: GetCommentsUseCase(repo),
    addCommentUseCase: AddCommentUseCase(repo),
    postId: postId,
  );
});
