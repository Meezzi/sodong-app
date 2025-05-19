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
        print('카테고리 변경: ${next.id}, ${next.text}');

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

  // 여러 카테고리의 데이터를 함께 로드하는 함수
  Future<void> _loadAllCategoriesData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    // 수집된 모든 게시물을 저장할 리스트
    List<TownLifePost> allPosts = [];

    try {
      // 모든 카테고리 데이터 로드 ('all' 카테고리 제외)
      final categoriesToLoad = TownLifeCategory.values
          .where((category) => category != TownLifeCategory.all)
          .map((category) => category.id)
          .toList();

      print('전체 카테고리 데이터 로드 시작 - 총 ${categoriesToLoad.length}개 카테고리');

      // 동시에 여러 카테고리의 데이터를 로드
      List<Future<List<TownLifePost>>> futures = [];

      for (var categoryId in categoriesToLoad) {
        print('카테고리 로드 요청: $categoryId');
        futures.add(_loadCategoryPosts(categoryId));
      }

      // 모든 로드 작업이 완료될 때까지 대기
      final results = await Future.wait(futures);

      // 결과 합치기
      for (var posts in results) {
        allPosts.addAll(posts);
      }

      // 데이터가 충분하지 않은 경우 (실제 DB 데이터 부족)
      if (allPosts.isEmpty) {
        print('데이터가 없습니다. 기본 카테고리에서 다시 시도합니다.');

        // 기본 카테고리들로 다시 시도
        final basicCategories = [
          TownLifeCategory.question.id,
          TownLifeCategory.news.id,
          TownLifeCategory.help.id
        ];

        for (var categoryId in basicCategories) {
          _postService.setCategory(categoryId);
          final fallbackPosts = await _postService.fetchInitialPosts();
          allPosts.addAll(fallbackPosts);
        }
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
      }

      print('전체 카테고리 데이터 로드 완료: ${allPosts.length}개 게시물');
      print('로드된 카테고리: ${allPosts.map((p) => p.category).toSet().toList()}');

      state = state.copyWith(
        posts: allPosts,
        isLoading: false,
        hasMorePosts: false, // 전체 카테고리는 무한 스크롤 비활성화
      );
    } catch (e) {
      print('전체 카테고리 데이터 로드 오류: $e');

      // 에러 시에도 데이터가 있으면 유지
      if (state.posts.isNotEmpty) {
        state = state.copyWith(
            isLoading: false, errorMessage: '일부 게시물을 불러오는데 실패했습니다.');
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: '게시물을 불러오는 중 오류가 발생했습니다.',
        );
      }
    }
  }

  // 특정 카테고리의 게시물을 로드하는 헬퍼 함수
  Future<List<TownLifePost>> _loadCategoryPosts(String categoryId) async {
    try {
      _postService.setCategory(categoryId);
      final posts = await _postService.fetchInitialPosts();
      if (posts.isNotEmpty) {
        print('카테고리 $categoryId에서 ${posts.length}개 게시물 로드됨');
      }
      return posts;
    } catch (e) {
      print('카테고리 $categoryId 로드 중 오류: $e');
      return [];
    }
  }

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
      print('추가 게시물 로드 오류: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: '추가 게시물을 불러오는 중 오류가 발생했습니다.',
      );
    }
  }
}
