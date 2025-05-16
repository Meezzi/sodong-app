import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/post_list/presentation/view_models/town_life_view_model.dart';

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
        ),
      ),
    );
  }
}
