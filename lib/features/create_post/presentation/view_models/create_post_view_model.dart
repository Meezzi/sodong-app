import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/core/result/result.dart';
import 'package:sodong_app/features/create_post/domain/usecase/create_post_usecase.dart';
import 'package:sodong_app/features/post/domain/entities/post.dart';
import 'package:sodong_app/features/post_list/domain/models/category.dart';

final class CreatePostState {
  const CreatePostState({
    this.title = '',
    this.content = '',
    this.imageUrls = const [],
    this.isAnonymous = true,
    this.isLoading = false,
    this.error,
    this.category = TownLifeCategory.daily,
  });

  final String title;
  final String content;
  final List<String> imageUrls;
  final bool isAnonymous;
  final bool isLoading;
  final String? error;
  final TownLifeCategory category;

  CreatePostState copyWith({
    String? title,
    String? content,
    List<String>? imageUrls,
    bool? isAnonymous,
    bool? isLoading,
    String? error,
    TownLifeCategory? category,
  }) {
    return CreatePostState(
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrls: imageUrls ?? this.imageUrls,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      category: category ?? this.category,
    );
  }
}

class CreatePostViewModel extends StateNotifier<CreatePostState> {
  CreatePostViewModel(this._createPostUsecase) : super(CreatePostState());

  final CreatePostUsecase _createPostUsecase;

  void setTitle(String title) =>
      state = state.copyWith(title: title, error: null);

  void setContent(String content) =>
      state = state.copyWith(content: content, error: null);

  void toggleAnonymous() =>
      state = state.copyWith(isAnonymous: !state.isAnonymous);

  void addImage(String path) =>
      state = state.copyWith(imageUrls: [...state.imageUrls, path]);

  void removeImage(String path) =>
      state = state.copyWith(imageUrls: [...state.imageUrls]..remove(path));

  void setCategory(TownLifeCategory category) {
    state = state.copyWith(category: category);
  }

  Future<void> submit(
    String location,
  ) async {
    state = state.copyWith(isLoading: true, error: null);

    final post = Post(
      postId: '',
      title: state.title,
      content: state.content,
      imageUrls: state.imageUrls,
      createdAt: DateTime.now(),
      isAnonymous: state.isAnonymous,
      category: state.category,
      region: location,
      userId: '',
      nickname: '',
      commentCount: 0,
    );

    final result = await _createPostUsecase.execute(
      location: location,
      category: state.category,
      post: post,
      imageUrls: state.imageUrls,
    );

    if (result is Ok) {
      state = CreatePostState();
    } else if (result is Error) {
      final e = (result as Error).error;
      state = state.copyWith(error: e.toString(), isLoading: false);
      return;
    }
  }
}

final createPostViewModelProvider =
    StateNotifierProvider.autoDispose<CreatePostViewModel, CreatePostState>(
        (ref) {
  final usecase = ref.watch(createPostUsecaseProvider);
  return CreatePostViewModel(usecase);
});
