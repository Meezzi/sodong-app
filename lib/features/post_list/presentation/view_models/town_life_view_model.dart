// 게시물 상태 관리를 위한 State 클래스
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/post/domain/entities/region.dart';
import 'package:sodong_app/features/post/domain/use_case/post_service.dart';
import 'package:sodong_app/features/post/domain/entities/category.dart';
import 'package:sodong_app/features/post_list/domain/models/town_life_post.dart';
import 'package:sodong_app/features/post_list/presentation/providers/post_providers.dart';
import 'package:sodong_app/features/post_list/presentation/view_models/pagination_manager.dart';
import 'package:sodong_app/features/post_list/presentation/view_models/region_view_model.dart';

/// 동네 생활 게시물 상태 관리 클래스
///
/// [posts]: 현재 로드된 게시물 목록
/// [isLoading]: 데이터 로딩 중 여부
/// [hasMorePosts]: 추가 로드 가능한 게시물 존재 여부
/// [errorMessage]: 오류 발생 시 메시지
class TownLifeState {
  TownLifeState({
    required this.posts,
    required this.isLoading,
    required this.hasMorePosts,
    this.errorMessage,
  });

  final List<TownLifePost> posts;
  final bool isLoading;
  final bool hasMorePosts;
  final String? errorMessage;

  /// 상태 복사 메서드
  ///
  /// [posts]: 새로운 게시물 목록 (선택 사항)
  /// [isLoading]: 로딩 상태 (선택 사항)
  /// [hasMorePosts]: 추가 게시물 존재 여부 (선택 사항)
  /// [errorMessage]: 오류 메시지 (선택 사항)
  ///
  /// Returns: 새로운 TownLifeState 인스턴스
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

  /// 초기 상태 생성 팩토리 메서드
  static TownLifeState initial() {
    return TownLifeState(
      posts: [],
      isLoading: false,
      hasMorePosts: true,
      errorMessage: null,
    );
  }
}

/// 게시물 캐시 관리 클래스
///
/// 카테고리별 게시물 캐싱 및 전체 게시물 캐싱 담당
class PostCacheManager {
  // 각 카테고리별 캐시를 관리하는 맵
  final Map<String, List<TownLifePost>> _categoryPostsCache = {};

  // 마지막으로 로드된 전체 카테고리 게시물 캐시
  List<TownLifePost> _cachedAllCategoryPosts = [];

  /// 카테고리별 캐시된 게시물 조회
  ///
  /// [categoryId]: 조회할 카테고리 ID
  /// Returns: 캐시된 게시물 목록 (없으면 빈 리스트)
  List<TownLifePost> getCategoryPosts(String categoryId) {
    return _categoryPostsCache[categoryId] ?? [];
  }

  /// 전체 카테고리 캐시된 게시물 조회
  ///
  /// Returns: 캐시된 모든 카테고리 게시물 목록
  List<TownLifePost> getAllCategoryPosts() {
    return _cachedAllCategoryPosts;
  }

  /// 카테고리별 게시물 캐시 업데이트
  ///
  /// [categoryId]: 업데이트할 카테고리 ID
  /// [posts]: 새로운 게시물 목록
  void updateCategoryCache(String categoryId, List<TownLifePost> posts) {
    _categoryPostsCache[categoryId] = List.from(posts);
  }

  /// 전체 카테고리 게시물 캐시 업데이트
  ///
  /// [posts]: 새로운 게시물 목록
  void updateAllCategoryCache(List<TownLifePost> posts) {
    _cachedAllCategoryPosts = List.from(posts);
  }

  /// 모든 캐시 초기화
  void clearAllCache() {
    _categoryPostsCache.clear();
    _cachedAllCategoryPosts.clear();
  }

  /// 카테고리별 게시물 정렬 및 병합
  ///
  /// [posts]: 정렬할 게시물 목록
  /// Returns: 카테고리별로 정렬된 게시물 목록
  List<TownLifePost> sortPostsByCategory(List<TownLifePost> posts) {
    if (posts.isEmpty) return [];

    // 카테고리별로 고르게 분포하도록 정렬
    final Map<String, List<TownLifePost>> postsByCategory = {};

    // 카테고리별로 그룹화
    for (var post in posts) {
      if (!postsByCategory.containsKey(post.category)) {
        postsByCategory[post.category] = [];
      }
      postsByCategory[post.category]!.add(post);
    }

    // 각 카테고리 내부에서 정렬
    // 1. 시간 정보를 분석해서 가장 최근 게시물이 먼저 오도록 정렬
    for (var categoryPosts in postsByCategory.values) {
      categoryPosts.sort((a, b) {
        // 시간 정보가 '10분 전', '1시간 전', '1일 전' 등의 형태로 있으므로
        // 여기서는 간단한 규칙으로 정렬: 숫자가 작을수록 최근 게시물

        // 숫자 부분 추출 시도
        final aTimeNumber = _extractTimeNumber(a.timeAgo);
        final bTimeNumber = _extractTimeNumber(b.timeAgo);

        // 시간 단위 비교 (일 > 시간 > 분)
        final aTimeUnit = _getTimeUnitPriority(a.timeAgo);
        final bTimeUnit = _getTimeUnitPriority(b.timeAgo);

        // 단위가 다르면 단위로 비교
        if (aTimeUnit != bTimeUnit) {
          return aTimeUnit.compareTo(bTimeUnit);
        }

        // 단위가 같으면 숫자로 비교
        return aTimeNumber.compareTo(bTimeNumber);
      });
    }

    // 최종 결과 리스트 초기화
    final sortedPosts = <TownLifePost>[];

    // 각 카테고리에서 번갈아가면서 글을 추가
    int maxPosts = postsByCategory.values
        .map((list) => list.length)
        .fold(0, (prev, curr) => prev > curr ? prev : curr);

    for (int i = 0; i < maxPosts; i++) {
      for (var categoryPosts in postsByCategory.values) {
        if (i < categoryPosts.length) {
          sortedPosts.add(categoryPosts[i]);
        }
      }
    }

    return sortedPosts;
  }

  // 시간 문자열에서 숫자 추출
  int _extractTimeNumber(String timeAgo) {
    // 숫자 추출 시도
    final numberRegex = RegExp(r'(\d+)');
    final match = numberRegex.firstMatch(timeAgo);
    if (match != null && match.groupCount > 0) {
      return int.tryParse(match.group(1) ?? '0') ?? 0;
    }
    return 0;
  }

  // 시간 단위의 우선순위 반환 (값이 작을수록 최근)
  int _getTimeUnitPriority(String timeAgo) {
    if (timeAgo.contains('분')) return 0;
    if (timeAgo.contains('시간')) return 1;
    if (timeAgo.contains('일')) return 2;
    if (timeAgo.contains('개월')) return 3;
    if (timeAgo.contains('년')) return 4;
    return 5; // 기타 단위
  }
}

/// 동네 생활 게시물 관리 ViewModel
///
/// 상태 관리 및 각 관리 클래스 조율 담당
class TownLifeViewModel extends StateNotifier<TownLifeState> {
  TownLifeViewModel(PostService postService, this._ref)
      : _cacheManager = PostCacheManager(),
        _paginationManager = PaginationManager(postService),
        super(TownLifeState.initial()) {
    _setupListeners();

    // 초기 데이터 로드
    _loadAllCategoriesData();
  }

  final Ref _ref;
  final PostCacheManager _cacheManager;
  final PaginationManager _paginationManager;

  /// 이벤트 리스너 설정
  void _setupListeners() {
    // 지역 선택이 변경될 때 게시물 다시 불러오기
    _ref.listen(selectedRegionProvider, (previous, next) {
      if (previous != next) {
        _handleRegionChange(next);
      }
    });

    // 하위 지역 선택이 변경될 때 게시물 다시 불러오기
    _ref.listen(selectedSubRegionProvider, (previous, next) {
      if (previous != next) {
        _handleSubRegionChange(next);
      }
    });

    // 카테고리 선택이 변경될 때 처리
    _ref.listen(selectedCategoryProvider, (previous, next) {
      if (previous != next) {
        _handleCategoryChange(next);
      }
    });
  }

  /// 지역 변경 처리 메서드
  ///
  /// [region]: 새로운 지역
  void _handleRegionChange(Region region) {
    _paginationManager.setRegion(region);
    final selectedCategory = _ref.read(selectedCategoryProvider);

    // 지역이 변경되면 캐시 초기화
    _cacheManager.clearAllCache();

    if (selectedCategory == TownLifeCategory.all) {
      _loadAllCategoriesData();
    } else {
      fetchInitialPosts();
    }
  }

  /// 하위 지역 변경 처리 메서드
  ///
  /// [subRegion]: 새로운 하위 지역
  void _handleSubRegionChange(String subRegion) {
    _paginationManager.setSubRegion(subRegion);
    final selectedCategory = _ref.read(selectedCategoryProvider);

    // 하위 지역이 변경되면 캐시 초기화
    _cacheManager.clearAllCache();

    if (selectedCategory == TownLifeCategory.all) {
      _loadAllCategoriesData();
    } else {
      fetchInitialPosts();
    }
  }

  /// 카테고리 변경 처리 메서드
  ///
  /// [category]: 새로운 카테고리
  void _handleCategoryChange(TownLifeCategory category) {
    // 모든 카테고리 선택 시 데이터 로드 방식 변경
    if (category == TownLifeCategory.all) {
      // 여러 카테고리의 데이터를 함께 표시
      _loadAllCategoriesData();
    } else {
      // 선택한 카테고리의 ID를 Firestore 경로로 사용
      _paginationManager.setCategory(category.id);
      fetchInitialPosts();
    }
  }

  /// 여러 카테고리의 데이터를 함께 로드하는 함수 (현재 선택된 지역만)
  ///
  /// 현재 선택된 지역 기준으로 모든 카테고리의 게시물을 병합하여 로드
  ///
  /// Throws: 네트워크 오류 시 예외 발생
  Future<void> _loadAllCategoriesData() async {
    try {
      // 로딩 시작하기 전에 이전 데이터 보존
      try {
        state = state.copyWith(isLoading: true, errorMessage: null);
      } catch (e) {
        // StateNotifier가 이미 disposed된 경우
        print('TownLifeViewModel이 이미 disposed됨 (_loadAllCategoriesData)');
        return;
      }

      // 수집된 모든 게시물을 저장할 리스트
      List<TownLifePost> allPosts = [];

      // 모든 카테고리 데이터 로드 ('all' 카테고리 제외)
      final allCategories = TownLifeCategory.values
          .where((category) => category != TownLifeCategory.all)
          .map((category) => category.id)
          .toList();

      // 각 카테고리별로 현재 선택된 지역의 데이터를 가져옴
      for (var categoryId in allCategories) {
        if (!mounted) return; // 루프 중간에 disposed 여부 확인

        try {
          // 현재 선택된 지역에서 해당 카테고리의 게시물 가져오기
          final posts = await _paginationManager
              .loadCurrentRegionCategoryPosts(categoryId);

          if (posts.isNotEmpty) {
            allPosts.addAll(posts);

            // 해당 카테고리의 캐시 업데이트
            _cacheManager.updateCategoryCache(categoryId, posts);
          } else {
            // 데이터가 없는 경우에도 빈 리스트로 캐시 업데이트
            _cacheManager.updateCategoryCache(categoryId, []);
          }
        } catch (e) {
          // 에러 발생시에도 빈 리스트로 캐시 업데이트
          _cacheManager.updateCategoryCache(categoryId, []);
        }
      }

      if (!mounted) return; // 다시 한 번 상태 확인

      // 데이터가 없는 경우 처리
      if (allPosts.isEmpty) {
        try {
          state = state.copyWith(
            posts: [],
            isLoading: false,
            hasMorePosts: false,
          );
        } catch (stateError) {
          print('상태 업데이트 중 오류: $stateError');
        }
        return;
      } else {
        // 새 데이터가 있으면 캐시 업데이트
        _cacheManager.updateAllCategoryCache(allPosts);
      }

      // 카테고리별로 정렬 후 시간순으로 섞기
      if (allPosts.isNotEmpty) {
        // 게시물 정렬 기능을 캐시 매니저에 위임
        allPosts = _cacheManager.sortPostsByCategory(allPosts);

        // 최종 결과를 전체 카테고리 캐시에도 저장
        _cacheManager.updateAllCategoryCache(allPosts);
      }

      try {
        state = state.copyWith(
          posts: allPosts,
          isLoading: false,
          hasMorePosts: false, // 전체 카테고리는 무한 스크롤 비활성화
        );
      } catch (stateError) {
        print('최종 상태 업데이트 중 오류: $stateError');
      }
    } catch (e) {
      // 에러 발생 시 빈 리스트 반환
      if (!mounted) return;

      try {
        state = state.copyWith(
          posts: [],
          isLoading: false,
          errorMessage: '게시물을 불러오는 중 오류가 발생했습니다.',
        );
      } catch (stateError) {
        print('에러 상태 업데이트 중 오류: $stateError');
      }
    }
  }

  /// 초기 게시물 데이터 로드 메서드
  ///
  /// 현재 선택된 카테고리 기준으로 첫 페이지 게시물 로드
  ///
  /// Throws:
  ///   - 네트워크 연결 오류
  ///   - 데이터 파싱 오류
  Future<void> fetchInitialPosts() async {
    if (state.isLoading) return;

    try {
      // 현재 선택된 카테고리
      final currentCategory = _ref.read(selectedCategoryProvider).id;

      // 로딩 시작하기 전에 이전 데이터 보존
      final previousPosts = state.posts;

      // StateNotifier가 아직 살아있는지 확인 (disposed 된 경우 에러 방지)
      try {
        state = state.copyWith(isLoading: true, errorMessage: null);
      } catch (e) {
        // StateNotifier가 이미 disposed된 경우
        print('TownLifeViewModel이 이미 disposed됨');
        return;
      }

      var posts = await _paginationManager.loadInitialPosts();

      // 다시 StateNotifier 상태 확인
      if (!mounted) return;

      if (posts.isNotEmpty) {
        // 로드 성공 시 해당 카테고리의 캐시 업데이트
        _cacheManager.updateCategoryCache(currentCategory, posts);

        try {
          state = state.copyWith(
            posts: posts,
            isLoading: false,
            hasMorePosts: _paginationManager.hasMorePosts,
          );
        } catch (e) {
          print('상태 업데이트 중 오류: $e');
        }
      } else {
        // 데이터가 없고 캐시가 있으면 캐시 사용
        final cachedPosts = _cacheManager.getCategoryPosts(currentCategory);
        if (cachedPosts.isNotEmpty) {
          posts = cachedPosts;
          try {
            state = state.copyWith(
              posts: posts,
              isLoading: false,
              hasMorePosts: _paginationManager.hasMorePosts,
            );
          } catch (e) {
            print('상태 업데이트 중 오류: $e');
          }
        } else {
          // 데이터가 없고 캐시도 없으면 빈 리스트로 설정하고 hasMorePosts는 false로 설정
          try {
            state = state.copyWith(
              posts: [],
              isLoading: false,
              hasMorePosts: false, // 게시물이 없으면 추가 로드 비활성화
            );
          } catch (e) {
            print('상태 업데이트 중 오류: $e');
          }
        }
      }
    } catch (e) {
      // 에러 시 캐시된 데이터 확인
      if (!mounted) return;

      try {
        final currentCategory = _ref.read(selectedCategoryProvider).id;
        final cachedPosts = _cacheManager.getCategoryPosts(currentCategory);
        final previousPosts = state.posts;

        if (cachedPosts.isNotEmpty) {
          state = state.copyWith(
              posts: cachedPosts,
              isLoading: false,
              hasMorePosts: false, // 에러 발생 시 추가 로드 비활성화
              errorMessage: '데이터 새로고침에 실패했습니다.');
        } else if (previousPosts.isNotEmpty) {
          // 캐시가 없으면 이전 데이터 유지
          state = state.copyWith(
              posts: previousPosts,
              isLoading: false,
              hasMorePosts: false, // 에러 발생 시 추가 로드 비활성화
              errorMessage: '데이터 새로고침에 실패했습니다.');
        } else {
          state = state.copyWith(
            isLoading: false,
            hasMorePosts: false, // 에러 발생 시 추가 로드 비활성화
            errorMessage: '게시물을 불러오는 중 오류가 발생했습니다.',
          );
        }
      } catch (stateError) {
        print('상태 업데이트 중 오류: $stateError');
      }
    }
  }

  /// 추가 게시물 로드 메서드 (무한 스크롤)
  ///
  /// 현재 페이지 이후의 게시물을 추가로 로드
  ///
  /// Requirements:
  ///   - hasMorePosts == true
  ///   - isLoading == false
  Future<void> fetchMorePosts() async {
    if (state.isLoading || !state.hasMorePosts) return;

    // 전체 카테고리를 보고 있을 때는 무한 스크롤 비활성화
    if (_ref.read(selectedCategoryProvider) == TownLifeCategory.all) {
      return;
    }

    try {
      // StateNotifier가 아직 살아있는지 확인
      try {
        state = state.copyWith(isLoading: true, errorMessage: null);
      } catch (e) {
        print('TownLifeViewModel이 이미 disposed됨');
        return;
      }

      var newPosts = await _paginationManager.loadMorePosts();

      // 다시 StateNotifier 상태 확인
      if (!mounted) return;

      // 현재 카테고리 캐시 업데이트
      try {
        final currentCategory = _ref.read(selectedCategoryProvider).id;
        final updatedCachePosts = [
          ..._cacheManager.getCategoryPosts(currentCategory),
          ...newPosts
        ];
        _cacheManager.updateCategoryCache(currentCategory, updatedCachePosts);

        state = state.copyWith(
          posts: [...state.posts, ...newPosts],
          isLoading: false,
          hasMorePosts: _paginationManager.hasMorePosts,
        );
      } catch (e) {
        print('상태 업데이트 중 오류: $e');
      }
    } catch (e) {
      if (!mounted) return;

      try {
        state = state.copyWith(
          isLoading: false,
          errorMessage: '추가 게시물을 불러오는데 실패했습니다.',
        );
      } catch (stateError) {
        print('상태 업데이트 중 오류: $stateError');
      }
    }
  }

  /// 새로고침용 메서드
  ///
  /// 현재 카테고리와 관계없이 모든 카테고리 데이터를 가져와서 캐시합니다.
  Future<void> refreshAllCategoryData() async {
    try {
      // 현재 카테고리와 상태를 기억
      final currentCategory = _ref.read(selectedCategoryProvider);
      final oldState = state;

      // 기존 캐시를 모두 비우고 시작
      _cacheManager.clearAllCache();

      // 모든 카테고리의 데이터를 로드
      await _loadAllCategoriesData();

      // StateNotifier 상태 확인
      if (!mounted) return;

      // 현재 카테고리가 전체 카테고리가 아닌 경우, 해당 카테고리 데이터만 필터링하여 표시
      if (currentCategory != TownLifeCategory.all) {
        try {
          final filteredPosts =
              _cacheManager.getCategoryPosts(currentCategory.id);

          if (filteredPosts.isNotEmpty) {
            // 게시물을 날짜순으로 정렬 (최신순)
            final sortedPosts = _sortPostsByTime(filteredPosts);

            // 해당 카테고리의 최신 데이터가 있으면 표시
            state = state.copyWith(
              posts: sortedPosts,
              isLoading: false,
              hasMorePosts: false,
            );
          } else if (oldState.posts.isNotEmpty) {
            // 없으면 이전 데이터 유지
            state = oldState.copyWith(isLoading: false);
          }
        } catch (stateError) {
          print('상태 업데이트 중 오류: $stateError');
        }
      } else {
        // 전체 카테고리를 보는 경우 모든 게시물을 시간순으로 정렬
        final allPosts = _cacheManager.getAllCategoryPosts();
        if (allPosts.isNotEmpty) {
          final sortedPosts = _sortPostsByTime(allPosts);
          state = state.copyWith(
            posts: sortedPosts,
            isLoading: false,
            hasMorePosts: false,
          );
        }
      }
    } catch (e) {
      print('새로고침 중 오류 발생: $e');
    }
  }

  // 게시물을 최신순으로 정렬하는 헬퍼 메서드
  List<TownLifePost> _sortPostsByTime(List<TownLifePost> posts) {
    final sortedPosts = List<TownLifePost>.from(posts);
    sortedPosts.sort((a, b) {
      // 시간 단위 비교 (일 > 시간 > 분)
      final aTimeUnit = _getTimeUnitPriority(a.timeAgo);
      final bTimeUnit = _getTimeUnitPriority(b.timeAgo);

      // 단위가 다르면 단위로 비교
      if (aTimeUnit != bTimeUnit) {
        return aTimeUnit.compareTo(bTimeUnit);
      }

      // 단위가 같으면 숫자로 비교
      final aTimeNumber = _extractTimeNumber(a.timeAgo);
      final bTimeNumber = _extractTimeNumber(b.timeAgo);
      return aTimeNumber.compareTo(bTimeNumber);
    });
    return sortedPosts;
  }

  // 시간 문자열에서 숫자 추출
  int _extractTimeNumber(String timeAgo) {
    // 숫자 추출 시도
    final numberRegex = RegExp(r'(\d+)');
    final match = numberRegex.firstMatch(timeAgo);
    if (match != null && match.groupCount > 0) {
      return int.tryParse(match.group(1) ?? '0') ?? 0;
    }
    return 0;
  }

  // 시간 단위의 우선순위 반환 (값이 작을수록 최근)
  int _getTimeUnitPriority(String timeAgo) {
    if (timeAgo.contains('분')) return 0;
    if (timeAgo.contains('시간')) return 1;
    if (timeAgo.contains('일')) return 2;
    if (timeAgo.contains('개월')) return 3;
    if (timeAgo.contains('년')) return 4;
    return 5; // 기타 단위
  }
}

/// 현재 선택된 카테고리 관리 프로바이더
///
/// 기본값: TownLifeCategory.all
final selectedCategoryProvider =
    StateProvider<TownLifeCategory>((ref) => TownLifeCategory.all);

/// 사용 가능한 카테고리 목록 제공 프로바이더
///
/// Returns: 모든 TownLifeCategory 값 목록
final categoriesProvider =
    Provider<List<TownLifeCategory>>((ref) => allCategories);

/// 동네 생활 게시물 상태 관리 프로바이더
final townLifeStateProvider =
    StateNotifierProvider<TownLifeViewModel, TownLifeState>((ref) {
  final postService = ref.watch(postServiceProvider);
  return TownLifeViewModel(postService, ref);
});

/// 필터링된 게시물 목록 제공 프로바이더
///
/// [selectedCategoryProvider]와 [townLifeStateProvider]를 조합하여
/// 선택된 카테고리에 해당하는 게시물 필터링
///
/// Returns: 필터링된 게시물 목록
final filteredPostsProvider = Provider<List<TownLifePost>>((ref) {
  final townLifeState = ref.watch(townLifeStateProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);

  if (selectedCategory == TownLifeCategory.all) {
    return townLifeState.posts;
  } else {
    return townLifeState.posts
        .where((post) => post.categoryEnum == selectedCategory)
        .toList();
  }
});
