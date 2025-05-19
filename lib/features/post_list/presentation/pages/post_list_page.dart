import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/town_life_post.dart';
import '../view_models/town_life_view_model.dart';
import '../view_models/region_view_model.dart';
import '../widgets/category_selector.dart';
import '../widgets/region_selector.dart';
import '../widgets/town_life_post_item.dart';

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
      final initialRegion = ref.read(selectedRegionProvider);
      final postService = ref.read(postServiceProvider);
      postService.setRegion(initialRegion);

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
      onRefresh: () =>
          ref.read(townLifeStateProvider.notifier).fetchInitialPosts(),
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
    if (!townLifeState.hasMorePosts) return;

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
    if (townLifeState.isLoading && filteredPosts.isEmpty) {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (filteredPosts.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.article_outlined, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                '게시물이 없습니다',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == filteredPosts.length) {
            return townLifeState.hasMorePosts
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox.shrink();
          }
          var post = filteredPosts[index];
          return TownLifePostItem(
            post: post,
            index: index,
          );
        },
        childCount: filteredPosts.length + (townLifeState.hasMorePosts ? 1 : 0),
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
  double get maxExtent => 57.0;

  @override
  double get minExtent => 57.0;

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
      child: const CategorySelector(),
    );
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
