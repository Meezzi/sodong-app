import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/core/theme/theme_helper.dart';
import 'package:sodong_app/core/theme/theme_provider.dart';
import 'package:sodong_app/core/theme/theme_widgets.dart';
import 'package:sodong_app/features/post_list/domain/models/category.dart';
import 'package:sodong_app/features/post_list/domain/models/town_life_post.dart';
import 'package:sodong_app/features/post_list/presentation/view_models/region_view_model.dart';
import 'package:sodong_app/features/post_list/presentation/view_models/town_life_view_model.dart';
import 'package:sodong_app/features/post_list/presentation/widgets/category_selector.dart';
import 'package:sodong_app/features/post_list/presentation/widgets/region_selector.dart';
import 'package:sodong_app/features/post_list/presentation/widgets/town_life_post_item.dart';

class PostListPage extends ConsumerStatefulWidget {
  const PostListPage({super.key});

  @override
  ConsumerState<PostListPage> createState() => _TownLifePageState();
}

class _TownLifePageState extends ConsumerState<PostListPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();

    // 초기화 시 작업
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        // 1. 먼저 사용자의 저장된 지역 정보 로드 시도
        await ref.read(loadUserRegionProvider.future).catchError((_) {
          // 에러가 발생해도 계속 진행
          print('사용자 지역 정보 로드 실패, 기본 지역 사용');
        });

        // mounted 상태 확인 - 페이지가 이미 dispose 되었을 수 있음
        if (!mounted) return;

        // 2. 초기 게시물 가져오기
        ref.read(townLifeStateProvider.notifier).fetchInitialPosts();
      },
    );

    // 스크롤 이벤트 감지
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var townLifeState = ref.watch(townLifeStateProvider);
    var filteredPosts = ref.watch(filteredPostsProvider);

    return TownLifeScaffold(
      scrollController: _scrollController,
      onRefresh: () async {
        // 현재 선택된 카테고리
        final selectedCategory = ref.read(selectedCategoryProvider);

        try {
          // 항상 모든 카테고리 데이터를 로드하는 방식으로 변경
          if (selectedCategory == TownLifeCategory.all) {
            // 전체 카테고리인 경우 해당 메서드 호출
            await ref
                .read(townLifeStateProvider.notifier)
                .refreshAllCategoryData();
          } else {
            // 다른 카테고리를 보고 있더라도 전체 데이터 새로고침
            await ref
                .read(townLifeStateProvider.notifier)
                .refreshAllCategoryData();
          }
        } catch (e) {
          print('새로고침 실패: $e');
        }
      },
      appBar: _buildAppBar(),
      regionSelector: _buildRegionSelector(),
      categorySelector: _buildCategorySelector(),
      postListView: _buildPostListView(townLifeState, filteredPosts),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  // 스크롤 이벤트 리스너
  void _scrollListener() {
    if (_isLoadingMore) return;
    if (!mounted) return; // mounted 상태 확인

    var townLifeState = ref.read(townLifeStateProvider);
    // 추가 게시물이 없거나 현재 게시물이 없으면 스크롤 이벤트 무시
    if (!townLifeState.hasMorePosts || townLifeState.posts.isEmpty) {
      // 로딩 상태 명시적으로 초기화 (안전장치)
      if (_isLoadingMore) {
        _isLoadingMore = false;
      }
      return;
    }

    // 게시물이 충분히 있는 경우에만 스크롤 이벤트 처리
    // 현재 스크롤 위치가 하단에 도달했는지 확인
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _isLoadingMore = true;
      ref.read(townLifeStateProvider.notifier).fetchMorePosts().then((_) {
        if (!mounted) return; // mounted 상태 확인
        _isLoadingMore = false;
      }).catchError((error) {
        if (!mounted) return; // mounted 상태 확인
        // 에러 발생 시 로딩 상태 초기화
        _isLoadingMore = false;
      });
    }
  }

  Widget _buildAppBar() {
    return Consumer(builder: (context, ref, child) {
      // 현재 테마 모드 상태 감시
      final currentTheme = ref.watch(themeProvider);

      // 시스템 설정을 따르는 경우 플랫폼 밝기도 감시
      final brightness = ref.watch(brightnessProvider(context));

      // 현재 다크 모드인지 확인
      final isDark = currentTheme == ThemeMode.dark ||
          (currentTheme == ThemeMode.system && brightness == Brightness.dark);

      return SliverAppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 이미지에 조건부 불투명도 적용
            Opacity(
              opacity: isDark ? 0.85 : 1.0,
              child: Image.asset(
                'assets/login.png',
                height: 60,
                width: 60,
              ),
            ),
            Text(
              '소소한동네',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
        floating: true,
        pinned: true,
        centerTitle: true,
        backgroundColor:
            isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFFE4E8),
        actions: [
          const ThemeModeToggle(),
          IconButton(
            onPressed: () {
              //TODO: 마이페이지 이동
            },
            icon: Icon(
              CupertinoIcons.person_crop_circle,
              size: 30,
              // 다크모드에서는 더 부드러운 핑크 색상 사용
              color: isDark ? const Color(0xFFFF9CAA) : const Color(0xFFFF7B8E),
            ),
          )
        ],
      );
    });
  }

  Widget _buildRegionSelector() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverRegionHeaderDelegate(),
    );
  }

  Widget _buildCategorySelector() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverCategoryHeaderDelegate(),
    );
  }

  Widget _buildPostListView(
      TownLifeState townLifeState, List<TownLifePost> filteredPosts) {
    // 로딩 중이고 게시물이 없을 때
    if (townLifeState.isLoading && filteredPosts.isEmpty) {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // 게시물이 없을 때
    if (filteredPosts.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false, // 스크롤을 비활성화
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(bottom: 100), // 하단 패딩 추가하여 더 위로 올림
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.article_outlined, size: 64, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text(
                '게시물이 없습니다',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[400]
                      : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '첫 게시물을 작성해보세요',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[500]
                      : Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 게시물이 있을 때
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          // 마지막 아이템인 경우 로딩 인디케이터 표시 여부 결정
          if (index == filteredPosts.length) {
            // 게시물이 있고 더 불러올 게시물이 있는 경우에만 로딩 인디케이터 표시
            if (townLifeState.hasMorePosts && !townLifeState.isLoading) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            } else {
              return const SizedBox.shrink();
            }
          }

          var post = filteredPosts[index];
          return Column(
            children: [
              TownLifePostItem(
                post: post,
                index: index,
              ),
              if (index < filteredPosts.length - 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    // 다크모드에서는 더 부드러운 구분선 색상 사용
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF505050)
                        : const Color(0xFFFFD5DE),
                  ),
                ),
            ],
          );
        },
        // 추가 게시물이 있고 로딩 중이 아닌 경우에만 +1 (로딩 인디케이터 위치용)
        childCount: filteredPosts.length +
            (townLifeState.hasMorePosts &&
                    !townLifeState.isLoading &&
                    filteredPosts.isNotEmpty
                ? 1
                : 0),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Consumer(builder: (context, ref, child) {
      final isDark = Theme.of(context).brightness == Brightness.dark;

      return FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create_post');
        },
        backgroundColor:
            isDark ? const Color(0xFFE0677A) : const Color(0xFFFF7B8E),
        child: const Icon(Icons.edit, color: Colors.white),
      );
    });
  }
}

class TownLifeScaffold extends ConsumerWidget {
  const TownLifeScaffold({
    super.key,
    required this.scrollController,
    required this.onRefresh,
    required this.appBar,
    required this.regionSelector,
    required this.categorySelector,
    required this.postListView,
    required this.floatingActionButton,
  });

  final ScrollController scrollController;
  final Future<void> Function() onRefresh;
  final Widget appBar;
  final Widget regionSelector;
  final Widget categorySelector;
  final Widget postListView;
  final Widget floatingActionButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 현재 테마 모드 상태 감시
    final currentTheme = ref.watch(themeProvider);

    // 시스템 설정을 따르는 경우 플랫폼 밝기도 감시
    final brightness = ref.watch(brightnessProvider(context));

    // 현재 다크 모드인지 확인
    final isDark = currentTheme == ThemeMode.dark ||
        (currentTheme == ThemeMode.system && brightness == Brightness.dark);

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFFE4E8),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            appBar,
            regionSelector,
            categorySelector,
            SliverToBoxAdapter(
              child: Container(
                height: 12,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isDark
                        ? [const Color(0xFF1E1E1E), const Color(0xFF303030)]
                        : [const Color(0xFFFFE4E8), Colors.grey[100]!],
                  ),
                ),
              ),
            ),
            postListView,
          ],
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}

// 지역 선택기를 위한 SliverPersistentHeader 델리게이트
class _SliverRegionHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // 테마 상태 확인
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFFE4E8),
      child: Column(
        children: [
          const RegionSelector(),
          Divider(
            height: 1,
            color: isDark ? Colors.grey[700] : Color(0xFFFFD5DE),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 49.0;

  @override
  double get minExtent => 49.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

// 카테고리 선택기를 위한 SliverPersistentHeader 델리게이트
class _SliverCategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // 테마 상태 확인
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFFE4E8),
      child: Column(
        children: [
          const CategorySelector(),
          Divider(
            height: 1,
            color: isDark ? Colors.grey[700] : Color(0xFFFFD5DE),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 60.0;

  @override
  double get minExtent => 60.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
