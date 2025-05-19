// 게시물 상태 관리를 위한 State 클래스
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/post_list/data/repository/post_repository.dart';
import 'package:sodong_app/features/post_list/domain/models/category.dart';
import 'package:sodong_app/features/post_list/domain/models/region.dart';
import 'package:sodong_app/features/post_list/domain/models/town_life_post.dart';
import 'package:sodong_app/features/post_list/presentation/view_models/region_view_model.dart';

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

// 게시물 서비스 프로바이더
final postServiceProvider = Provider<PostRepository>((ref) => PostRepository());

// 게시물 상태 프로바이더
final townLifeStateProvider =
    StateNotifierProvider<TownLifeStateNotifier, TownLifeState>((ref) {
  var postService = ref.watch(postServiceProvider);
  return TownLifeStateNotifier(postService, ref);
});

class LikedPostsNotifier extends StateNotifier<Map<int, bool>> {
  LikedPostsNotifier() : super({});

  void toggleLike(int index) {
    var currentState = Map<int, bool>.from(state);
    currentState[index] = !(currentState[index] ?? false);
    state = currentState;
  }

  bool isLiked(int index) {
    return state[index] ?? false;
  }
}

// 필터링된 게시물 목록 프로바이더 (수정: 더 이상 사용하지 않음)
// 카테고리 필터링은 이제 Firestore 쿼리에서 직접 처리됨
final filteredPostsProvider = Provider<List<TownLifePost>>((ref) {
  var townLifeState = ref.watch(townLifeStateProvider);
  return townLifeState.posts;
});

// 게시물 상태 관리를 위한 Notifier
class TownLifeStateNotifier extends StateNotifier<TownLifeState> {
  TownLifeStateNotifier(this._postService, this._ref)
      : super(TownLifeState.initial()) {
    // 지역 선택이 변경될 때 게시물 다시 불러오기
    _ref.listen(selectedRegionProvider, (previous, next) {
      if (previous != next) {
        _postService.setRegion(next);
        fetchInitialPosts();
      }
    });

    // 하위 지역 선택이 변경될 때 게시물 다시 불러오기
    _ref.listen(selectedSubRegionProvider, (previous, next) {
      if (previous != next) {
        _postService.setSubRegion(next);
        fetchInitialPosts();
      }
    });

    // 카테고리 선택이 변경될 때 처리
    _ref.listen(selectedCategoryProvider, (previous, next) {
      if (previous != next) {
        // 카테고리가 변경될 때마다 해당 카테고리의 데이터 로드
        if (next == TownLifeCategory.all) {
          // '전체' 카테고리를 선택했을 때도 특정 카테고리로 로드
          _postService.setCategory('question');
        } else {
          // 선택한 카테고리의 ID를 Firestore 경로로 사용
          _postService.setCategory(next.id);
        }

        print('카테고리 변경: ${next.id}, ${next.text}');
        fetchInitialPosts();
      }
    });

    // 초기 데이터 로드
    fetchInitialPosts();
  }

  final PostRepository _postService;
  final Ref _ref;

  // 초기 게시물 불러오기
  Future<void> fetchInitialPosts() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      var posts = await _postService.fetchInitialPosts();
      state = state.copyWith(
        posts: posts,
        isLoading: false,
        hasMorePosts: _postService.hasMorePosts,
      );
    } catch (e) {
      print('초기 게시물 로드 오류: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: '게시물을 불러오는 중 오류가 발생했습니다.',
      );
    }
  }

  // 추가 게시물 불러오기 (무한 스크롤)
  Future<void> fetchMorePosts() async {
    if (state.isLoading || !state.hasMorePosts) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      var newPosts = await _postService.fetchMorePosts();
      state = state.copyWith(
        posts: [...state.posts, ...newPosts],
        isLoading: false,
        hasMorePosts: _postService.hasMorePosts,
      );
    } catch (e) {
      print('추가 게시물 로드 오류: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: '추가 게시물을 불러오는 중 오류가 발생했습니다.',
      );
    }
  }
}
