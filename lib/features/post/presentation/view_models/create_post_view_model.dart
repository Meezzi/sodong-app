import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/core/result/result.dart';
import 'package:sodong_app/features/post/domain/entities/post.dart';
import 'package:sodong_app/features/post/domain/use_case/create_post_use_case.dart';
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
    this.titleError,
    this.contentError,
  });

  final String title;
  final String content;
  final List<String> imageUrls;
  final bool isAnonymous;
  final bool isLoading;
  final String? error;
  final TownLifeCategory category;
  final String? titleError;
  final String? contentError;

  CreatePostState copyWith({
    String? title,
    String? content,
    List<String>? imageUrls,
    bool? isAnonymous,
    bool? isLoading,
    String? error,
    TownLifeCategory? category,
    String? titleError,
    String? contentError,
  }) {
    return CreatePostState(
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrls: imageUrls ?? this.imageUrls,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      category: category ?? this.category,
      titleError: titleError,
      contentError: contentError,
    );
  }
}

class CreatePostViewModel extends StateNotifier<CreatePostState> {
  CreatePostViewModel(this._createPostUsecase) : super(CreatePostState());

  final CreatePostUseCase _createPostUsecase;

  void setTitle(String title) {
    final titleError = title.trim().isEmpty ? '제목을 입력해주세요' : null;
    state = state.copyWith(title: title, error: null, titleError: titleError);
  }

  void setContent(String content) {
    final contentError = content.trim().isEmpty ? '내용을 입력해주세요' : null;
    state = state.copyWith(
        content: content, error: null, contentError: contentError);
  }

  void toggleAnonymous() =>
      state = state.copyWith(isAnonymous: !state.isAnonymous);

  void addImage(String path) =>
      state = state.copyWith(imageUrls: [...state.imageUrls, path]);

  void removeImage(String path) =>
      state = state.copyWith(imageUrls: [...state.imageUrls]..remove(path));

  void setCategory(TownLifeCategory category) {
    state = state.copyWith(category: category);
  }

  bool isFormValid() {
    final titleValid = state.title.trim().isNotEmpty;
    final contentValid = state.content.trim().isNotEmpty;

    state = state.copyWith(
      titleError: titleValid ? null : '제목을 입력해주세요',
      contentError: contentValid ? null : '내용을 입력해주세요',
    );

    return titleValid && contentValid;
  }

  Future<Post> submit(
    String location,
    String uid,
    String nickname,
  ) async {
    // 유효성 검사는 호출자 측에서 이미 처리됨
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
      userId: uid,
      nickname: state.isAnonymous ? '익명' : nickname,
      commentCount: 0,
    );

    final result = await _createPostUsecase.execute(
      location: location,
      category: state.category,
      post: post,
      imagePaths: state.imageUrls,
    );

    if (result is Ok<Post>) {
      state = CreatePostState();
      return result.value;
    } else if (result is Error) {
      final e = (result as Error).error;
      state = state.copyWith(error: e.toString(), isLoading: false);
      throw Exception('게시물 작성 실패: $e');
    }
    throw Exception('알 수 없는 오류 발생');
  }
}
