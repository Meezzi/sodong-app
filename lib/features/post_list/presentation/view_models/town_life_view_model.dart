// 게시물 상태 관리를 위한 State 클래스
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/post_list/domain/models/category.dart';
import 'package:sodong_app/features/post_list/domain/models/town_life_post.dart';

class TownLifeState {
  final List<TownLifePost> posts;
  final bool isLoading;
  final bool hasMorePosts;
  final String? errorMessage;

  TownLifeState({
    required this.posts,
    required this.isLoading,
    required this.hasMorePosts,
    this.errorMessage,
  });

  TownLifeState copyWith({
    List<TownLifePost>? posts,
    bool? isLoading,
    bool? hasMorePosts,
    String? errorMessage,
  }) {
    return TownLifeState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      hasMorePosts: hasMorePosts ?? this.hasMorePosts,
      errorMessage: errorMessage,
    );
  }

  static TownLifeState initial() {
    return TownLifeState(
      posts: [],
      isLoading: false,
      hasMorePosts: true,
      errorMessage: null,
    );
  }
}

// 현재 선택된 카테고리를 관리하는 프로바이더
final selectedCategoryProvider =
    StateProvider<TownLifeCategory>((ref) => TownLifeCategory.all);

// 카테고리 목록 프로바이더
final categoriesProvider =
    Provider<List<TownLifeCategory>>((ref) => allCategories);

// 좋아요 상태를 관리하는 프로바이더
final likedPostsProvider =
    StateNotifierProvider<LikedPostsNotifier, Map<int, bool>>((ref) {
  return LikedPostsNotifier();
});

class LikedPostsNotifier extends StateNotifier<Map<int, bool>> {
  LikedPostsNotifier() : super({});

  void toggleLike(int index) {
    final currentState = Map<int, bool>.from(state);
    currentState[index] = !(currentState[index] ?? false);
    state = currentState;
  }

  bool isLiked(int index) {
    return state[index] ?? false;
  }
}
