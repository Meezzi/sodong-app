// 게시물 상태 관리를 위한 State 클래스
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/post_list/data/repository/post_repository.dart'
    hide generateDummyPosts;
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

// 필터링된 게시물 목록 프로바이더 (수정: 클라이언트 측 필터링 다시 추가)
final filteredPostsProvider = Provider<List<TownLifePost>>((ref) {
  var selectedCategory = ref.watch(selectedCategoryProvider);
  var townLifeState = ref.watch(townLifeStateProvider);

  // '전체' 카테고리인 경우 모든 게시물 반환
  if (selectedCategory == TownLifeCategory.all) {
    return townLifeState.posts;
  }

  // 특정 카테고리가 선택된 경우 해당 카테고리의 게시물만 필터링
  return townLifeState.posts
      .where((post) => post.categoryEnum == selectedCategory)
      .toList();
});

// 게시물 상태 관리를 위한 Notifier
class TownLifeStateNotifier extends StateNotifier<TownLifeState> {
  TownLifeStateNotifier(this._postService, this._ref)
      : super(TownLifeState.initial()) {
    // 지역 선택이 변경될 때 게시물 다시 불러오기
    _ref.listen(selectedRegionProvider, (previous, next) {
      if (previous != next) {
        _postService.setRegion(next);
        final selectedCategory = _ref.read(selectedCategoryProvider);

        // 지역이 변경되면 카테고리 캐시 초기화
        _categoryPostsCache.clear();
        _cachedAllCategoryPosts.clear();

        if (selectedCategory == TownLifeCategory.all) {
          _loadAllCategoriesData();
        } else {
          fetchInitialPosts();
        }
      }
    });

    // 하위 지역 선택이 변경될 때 게시물 다시 불러오기
    _ref.listen(selectedSubRegionProvider, (previous, next) {
      if (previous != next) {
        _postService.setSubRegion(next);
        final selectedCategory = _ref.read(selectedCategoryProvider);

        // 하위 지역이 변경되면 카테고리 캐시 초기화
        _categoryPostsCache.clear();
        _cachedAllCategoryPosts.clear();

        if (selectedCategory == TownLifeCategory.all) {
          _loadAllCategoriesData();
        } else {
          fetchInitialPosts();
        }
      }
    });

    // 카테고리 선택이 변경될 때 처리
    _ref.listen(selectedCategoryProvider, (previous, next) {
      if (previous != next) {
        // 모든 카테고리 선택 시 데이터 로드 방식 변경
        if (next == TownLifeCategory.all) {
          // 여러 카테고리의 데이터를 함께 표시
          _loadAllCategoriesData();
        } else {
          // 선택한 카테고리의 ID를 Firestore 경로로 사용
          _postService.setCategory(next.id);
          fetchInitialPosts();
        }
      }
    });

    // 초기 데이터 로드
    _loadAllCategoriesData();
  }

  final PostRepository _postService;
  final Ref _ref;

  // 마지막으로 로드된 전체 카테고리 게시물을 캐시
  List<TownLifePost> _cachedAllCategoryPosts = [];

  // 각 카테고리별 캐시를 관리하는 맵 추가
  final Map<String, List<TownLifePost>> _categoryPostsCache = {};

  // 여러 카테고리의 데이터를 함께 로드하는 함수 (현재 선택된 지역만)
  Future<void> _loadAllCategoriesData() async {
    // 로딩 시작하기 전에 이전 데이터 보존
    final previousPosts = state.posts;
    state = state.copyWith(isLoading: true, errorMessage: null);

    // 수집된 모든 게시물을 저장할 리스트
    List<TownLifePost> allPosts = [];

    try {
      // 모든 카테고리 데이터 로드 ('all' 카테고리 제외)
      final allCategories = TownLifeCategory.values
          .where((category) => category != TownLifeCategory.all)
          .map((category) => category.id)
          .toList();

      // 각 카테고리별로 현재 선택된 지역의 데이터를 가져옴
      for (var categoryId in allCategories) {
        try {
          // 현재 선택된 지역에서 해당 카테고리의 게시물 가져오기
          final posts =
              await _postService.fetchCurrentRegionCategoryPosts(categoryId);

          if (posts.isNotEmpty) {
            allPosts.addAll(posts);

            // 해당 카테고리의 캐시 업데이트
            _categoryPostsCache[categoryId] = List.from(posts);
          } else {
            // 데이터가 없는 경우에도 빈 리스트로 캐시 업데이트 (이전 지역 데이터를 사용하지 않도록)
            _categoryPostsCache[categoryId] = [];
          }
        } catch (e) {
          // 에러 발생시에도 빈 리스트로 캐시 업데이트
          _categoryPostsCache[categoryId] = [];
        }
      }

      // 데이터가 없는 경우 처리
      if (allPosts.isEmpty) {
        // 이전 코드에서는 캐시된 데이터를 사용했지만, 지역 변경 시에는 빈 리스트 반환
        state = state.copyWith(
          posts: [],
          isLoading: false,
          hasMorePosts: false,
        );
        return;
      } else {
        // 새 데이터가 있으면 캐시 업데이트
        _cachedAllCategoryPosts = List.from(allPosts);
      }

      // 카테고리별로 정렬 후 시간순으로 섞기
      if (allPosts.isNotEmpty) {
        // 카테고리별로 고르게 분포하도록 정렬
        final Map<String, List<TownLifePost>> postsByCategory = {};

        // 카테고리별로 그룹화
        for (var post in allPosts) {
          if (!postsByCategory.containsKey(post.category)) {
            postsByCategory[post.category] = [];
          }
          postsByCategory[post.category]!.add(post);
        }

        // 각 카테고리 내부에서 정렬
        for (var categoryPosts in postsByCategory.values) {
          categoryPosts
              .sort((a, b) => b.commentCount.compareTo(a.commentCount));
        }

        // 최종 결과 리스트 초기화
        allPosts = [];

        // 각 카테고리에서 번갈아가면서 글을 추가
        int maxPosts = postsByCategory.values
            .map((list) => list.length)
            .fold(0, (prev, curr) => prev > curr ? prev : curr);

        for (int i = 0; i < maxPosts; i++) {
          for (var categoryPosts in postsByCategory.values) {
            if (i < categoryPosts.length) {
              allPosts.add(categoryPosts[i]);
            }
          }
        }

        // 최종 결과를 전체 카테고리 캐시에도 저장
        _cachedAllCategoryPosts = List.from(allPosts);
      }

      state = state.copyWith(
        posts: allPosts,
        isLoading: false,
        hasMorePosts: false, // 전체 카테고리는 무한 스크롤 비활성화
      );
    } catch (e) {
      // 에러 발생 시 빈 리스트 반환
      state = state.copyWith(
        posts: [],
        isLoading: false,
        errorMessage: '게시물을 불러오는 중 오류가 발생했습니다.',
      );
    }
  }

  // 특정 카테고리의 게시물을 로드하는 헬퍼 함수
  Future<List<TownLifePost>> _loadCategoryPosts(String categoryId) async {
    try {
      _postService.setCategory(categoryId);
      final posts = await _postService.fetchInitialPosts();
      if (posts.isNotEmpty) {
        // 해당 카테고리의 캐시 업데이트
        _categoryPostsCache[categoryId] = List.from(posts);
      }
      return posts;
    } catch (e) {
      // 에러 발생 시 해당 카테고리의 캐시된 데이터 반환
      if (_categoryPostsCache.containsKey(categoryId) &&
          _categoryPostsCache[categoryId]!.isNotEmpty) {
        return _categoryPostsCache[categoryId]!;
      }
      return [];
    }
  }

  // 초기 게시물 불러오기
  Future<void> fetchInitialPosts() async {
    if (state.isLoading) return;

    // 현재 선택된 카테고리
    final currentCategory = _ref.read(selectedCategoryProvider).id;

    // 로딩 시작하기 전에 이전 데이터 보존
    final previousPosts = state.posts;
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      var posts = await _postService.fetchInitialPosts();

      if (posts.isNotEmpty) {
        // 로드 성공 시 해당 카테고리의 캐시 업데이트
        _categoryPostsCache[currentCategory] = List.from(posts);
      } else if (_categoryPostsCache.containsKey(currentCategory) &&
          _categoryPostsCache[currentCategory]!.isNotEmpty) {
        // 데이터가 없고 캐시가 있으면 캐시 사용
        posts = _categoryPostsCache[currentCategory]!;
      }

      state = state.copyWith(
        posts: posts,
        isLoading: false,
        hasMorePosts: _postService.hasMorePosts,
      );
    } catch (e) {
      // 에러 시 캐시된 데이터 확인
      if (_categoryPostsCache.containsKey(currentCategory) &&
          _categoryPostsCache[currentCategory]!.isNotEmpty) {
        state = state.copyWith(
            posts: _categoryPostsCache[currentCategory]!,
            isLoading: false,
            errorMessage: '데이터 새로고침에 실패했습니다.');
      } else if (previousPosts.isNotEmpty) {
        // 캐시가 없으면 이전 데이터 유지
        state = state.copyWith(
            posts: previousPosts,
            isLoading: false,
            errorMessage: '데이터 새로고침에 실패했습니다.');
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: '게시물을 불러오는 중 오류가 발생했습니다.',
        );
      }
    }
  }

  // 추가 게시물 불러오기 (무한 스크롤)
  Future<void> fetchMorePosts() async {
    if (state.isLoading || !state.hasMorePosts) return;

    // 전체 카테고리를 보고 있을 때는 무한 스크롤 비활성화
    if (_ref.read(selectedCategoryProvider) == TownLifeCategory.all) {
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      var newPosts = await _postService.fetchMorePosts();
      state = state.copyWith(
        posts: [...state.posts, ...newPosts],
        isLoading: false,
        hasMorePosts: _postService.hasMorePosts,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '추가 게시물을 불러오는데 실패했습니다.',
      );
    }
  }

  // 새로고침용 메서드 - 현재 카테고리와 관계없이 모든 카테고리 데이터를 가져와서 캐시합니다.
  Future<void> refreshAllCategoryData() async {
    // 현재 카테고리와 상태를 기억
    final currentCategory = _ref.read(selectedCategoryProvider);
    final oldState = state;

    // 모든 카테고리의 데이터를 로드
    await _loadAllCategoriesData();

    // 현재 카테고리가 전체 카테고리가 아닌 경우, 해당 카테고리 데이터만 필터링하여 표시
    if (currentCategory != TownLifeCategory.all) {
      final filteredPosts = _categoryPostsCache[currentCategory.id] ?? [];

      if (filteredPosts.isNotEmpty) {
        // 해당 카테고리의 최신 데이터가 있으면 표시
        state = state.copyWith(
          posts: filteredPosts,
          isLoading: false,
          hasMorePosts: false,
        );
      } else if (oldState.posts.isNotEmpty) {
        // 없으면 이전 데이터 유지
        state = oldState.copyWith(isLoading: false);
      }
    }
  }
}
