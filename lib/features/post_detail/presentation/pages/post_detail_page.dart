import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/post_detail/data/providers/chat_detail_providers.dart';
import 'package:sodong_app/features/post_detail/presentation/widgets/detail_comment_input.dart';
import 'package:sodong_app/features/post_detail/presentation/widgets/detail_comment_item.dart';
import 'package:sodong_app/features/post_detail/presentation/widgets/detail_content.dart';
import 'package:sodong_app/features/post_detail/presentation/widgets/detail_header.dart';
import 'package:sodong_app/features/post_detail/presentation/widgets/detail_image_view.dart';
import 'package:sodong_app/features/post_detail/presentation/widgets/detail_loctaion.dart';
import 'package:sodong_app/features/post_detail/presentation/widgets/detail_title.dart';
import 'package:tuple/tuple.dart';

class PostDetailPage extends ConsumerWidget {

  const PostDetailPage({
    Key? key,
    required this.location,
    required this.category,
    required this.postId,
  }) : super(key: key);
  final String location;
  final String category;
  final String postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(postInfoProvider.notifier).state =
        Tuple3(location, category, postId);

    final postAsync = ref.watch(postStreamProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFE4E8),
        elevation: 0,
        centerTitle: true,
        title: const Text('게시글 상세',
            style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: postAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('에러: ${e.toString()}')),
        data: (post) {
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    DetailImageView(imageUrl: post.imageUrl.first),
                    const SizedBox(height: 16),
                    const DetailHeader(),
                    const SizedBox(height: 16),
                    DetailTitle(title: post.title),
                    const SizedBox(height: 16),
                    DetailContent(content: post.content),
                    const SizedBox(height: 16),
                    DetailLocation(location: post.location),
                    const SizedBox(height: 24),
                    const Text('댓글',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    const DetailCommentItem(text: '카페 추천해요!', time: '20분 전'),
                    const DetailCommentItem(text: '진짜 맛있어요~', time: '1시간 전'),
                  ],
                ),
              ),
              DetailCommentInput(postId: postId),
            ],
          );
        },
      ),
    );
  }
}
