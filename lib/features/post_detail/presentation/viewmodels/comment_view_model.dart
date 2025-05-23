import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/post_detail/domain/entities/comment_entity.dart';
import 'package:sodong_app/features/post_detail/domain/usecases/add_comment_usecase.dart';
import 'package:sodong_app/features/post_detail/domain/usecases/get_comment_usecase.dart';

class CommentViewModel extends StateNotifier<List<Comment>> {
  CommentViewModel({
    required this.getCommentsUseCase,
    required this.addCommentUseCase,
    required this.location,
    required this.category,
    required this.postId,
  }) : super([]) {
    _subscribeComments();
  }

  final GetCommentsUseCase getCommentsUseCase;
  final AddCommentUseCase addCommentUseCase;
  final String location;
  final String category;
  final String postId;

  late final Stream<List<Comment>> _commentStream;
  late final StreamSubscription<List<Comment>> _commentSubscription;

  void _subscribeComments() {
    _commentStream = getCommentsUseCase.stream(location, category, postId);
    _commentSubscription = _commentStream.listen((comments) {
      state = comments;
    });
  }

  Future<void> addComment(String content) async {
    await addCommentUseCase(location, category, postId, content);
  }

  @override
  void dispose() {
    _commentSubscription.cancel();
    super.dispose();
  }
}
