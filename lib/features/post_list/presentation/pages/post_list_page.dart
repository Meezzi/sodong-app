import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/post_list/domain/models/category.dart';
import 'package:sodong_app/features/post_list/domain/models/town_life_post.dart';
import 'package:sodong_app/features/post_list/presentation/providers/post_providers.dart';
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

    // 초기화 시 선택된 지역을 설정하고 게시물 가져오기
    Future.microtask(() {
      // 초기 게시물 가져오기
      ref.read(townLifeStateProvider.notifier).fetchInitialPosts();
    });

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
      onRefresh: () {
        // 현재 선택된 카테고리
        final selectedCategory = ref.read(selectedCategoryProvider);

        // 항상 모든 카테고리 데이터를 로드하는 방식으로 변경
        if (selectedCategory == TownLifeCategory.all) {
          // 전체 카테고리인 경우 해당 메서드 호출
          return ref
              .read(townLifeStateProvider.notifier)
              .refreshAllCategoryData();
        } else {
          // 다른 카테고리를 보고 있더라도 전체 데이터 새로고침
          return ref
              .read(townLifeStateProvider.notifier)
              .refreshAllCategoryData();
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

    var townLifeState = ref.read(townLifeStateProvider);
    // 추가 게시물이 없거나 현재 게시물이 없으면 스크롤 이벤트 무시
    if (!townLifeState.hasMorePosts || townLifeState.posts.isEmpty) return;

    // 게시물이 충분히 있는 경우에만 스크롤 이벤트 처리
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _isLoadingMore = true;
      ref.read(townLifeStateProvider.notifier).fetchMorePosts().then((_) {
        _isLoadingMore = false;
      });
    }
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      title: const Text('소소한동네', style: TextStyle(fontWeight: FontWeight.bold)),
      floating: true,
      pinned: true,
      centerTitle: true,
      backgroundColor: const Color(0xFFFFE4E8),
    );
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
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '첫 게시물을 작성해보세요',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
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
            return townLifeState.hasMorePosts
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox.shrink();
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
                    color: Color.fromARGB(255, 229, 160, 197),
                  ),
                ),
            ],
          );
        },
        // 추가 게시물이 있는 경우에만 +1 (로딩 인디케이터 위치용)
        childCount: filteredPosts.length +
            (townLifeState.hasMorePosts && filteredPosts.isNotEmpty ? 1 : 0),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: const Color(0xFFFF7B8E),
      child: const Icon(Icons.edit, color: Colors.white),
    );
  }
}

class TownLifeScaffold extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            appBar,
            regionSelector,
            categorySelector,
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
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const RegionSelector(),
          const Divider(height: 1),
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
    return Container(
      color: Colors.white,
      child: const Column(
        children: [
          CategorySelector(),
          Divider(height: 1),
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
