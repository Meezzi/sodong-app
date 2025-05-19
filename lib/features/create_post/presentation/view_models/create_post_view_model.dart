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
