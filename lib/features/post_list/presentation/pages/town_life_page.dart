import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/post_list/presentation/view_models/town_life_view_model.dart';
import 'package:sodong_app/features/post_list/presentation/widgets/category_selector.dart';
import 'package:sodong_app/features/post_list/presentation/widgets/region_selector.dart';

class TownLifePage extends ConsumerStatefulWidget {
  const TownLifePage({super.key});

  @override
  ConsumerState<TownLifePage> createState() => _TownLifePageState();
}

class _TownLifePageState extends ConsumerState<TownLifePage> {
  final ScrollController _scrollController = ScrollController();

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
            SliverAppBar(
              title: Text(
                '소소한동네',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              floating: true,
              pinned: true,
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.notifications_none),
                ),
              ],
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverRegionHeaderDelegate(),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverCategoryHeaderDelegate(),
            ),

            townLifeState.isLoading && filteredPosts.isEmpty ?
             SliverFillRemaining(child: Center(child: CircularProgressIndicator()),) :
             filteredPosts.isEmpty ? SliverFillRemaining(
              child: Column(
                
              ),
             )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFFFF7B8E),
        child: Icon(Icons.edit, color: Colors.white),
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
          RegionSelector(),
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
