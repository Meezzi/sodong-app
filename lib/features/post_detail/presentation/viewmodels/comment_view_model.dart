import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/post_detail/data/dtos/comment_dto.dart';
import 'package:sodong_app/features/post_detail/data/providers/comment_provider.dart';
import 'package:sodong_app/features/post_detail/data/repository/comment_repository.dart';

final commentViewModelProvider =
    StateNotifierProvider.family<CommentViewModel, List<Comment>, String>(
        (ref, postId) {
  final repository = ref.read(commentRepositoryProvider);
  return CommentViewModel(repository, postId);
});

class CommentViewModel extends StateNotifier<List<Comment>> {
  final CommentRepository repository;
  final String postId;

  CommentViewModel(this.repository, this.postId) : super([]) {
    loadComments();
  }

  Future<void> loadComments() async {
    final comments = await repository.fetchComments(postId);
    state = comments;
  }

  Future<void> addComment(Comment comment) async {
    await repository.addComment(comment);
    await loadComments();
  }
}
