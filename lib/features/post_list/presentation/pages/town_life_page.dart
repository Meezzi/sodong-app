import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/town_life_post.dart';
import '../view_models/town_life_view_model.dart';
import '../widgets/category_selector.dart';
import '../widgets/region_selector.dart';
import '../widgets/town_life_post_item.dart';

class TownLifePage extends ConsumerStatefulWidget {
  const TownLifePage({super.key});

  @override
  ConsumerState<TownLifePage> createState() => _TownLifePageState();
}

class _TownLifePageState extends ConsumerState<TownLifePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    // 초기 게시물 가져오기
    Future.microtask(
        () => ref.read(townLifeStateProvider.notifier).fetchInitialPosts());

    // 스크롤 이벤트 감지
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  // 스크롤 이벤트 리스너
  void _scrollListener() {
    if (_isLoadingMore) return;

    final townLifeState = ref.read(townLifeStateProvider);
    if (!townLifeState.hasMorePosts) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _isLoadingMore = true;
      ref.read(townLifeStateProvider.notifier).fetchMorePosts().then((_) {
        _isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final townLifeState = ref.watch(townLifeStateProvider);
    final filteredPosts = ref.watch(filteredPostsProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(townLifeStateProvider.notifier).fetchInitialPosts(),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // 앱바
            SliverAppBar(
              title: const Text('소소한동네',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              floating: true,
              pinned: true,
              backgroundColor: const Color(0xFFFFE4E8),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_none),
                  onPressed: () {},
                ),
              ],
            ),

            // 지역 선택기
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverRegionHeaderDelegate(),
            ),

            // 카테고리 선택기
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverCategoryHeaderDelegate(),
            ),

            // 게시물 리스트
            townLifeState.isLoading && filteredPosts.isEmpty
                ? const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                : filteredPosts.isEmpty
                    ? SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.article_outlined,
                                  size: 48, color: Colors.grey[400]),
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
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index == filteredPosts.length) {
                              return townLifeState.hasMorePosts
                                  ? const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16),
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    )
                                  : const SizedBox.shrink();
                            }
                            final post = filteredPosts[index];
                            return TownLifePostItem(
                              post: post,
                              index: index,
                            );
                          },
                          childCount: filteredPosts.length +
                              (townLifeState.hasMorePosts ? 1 : 0),
                        ),
                      ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFFFF7B8E),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
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
