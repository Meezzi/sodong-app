import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/comment/providers/comment_provider.dart';
import 'package:sodong_app/features/post/presentation/pages/post_detail/widgets/detail_actions.dart';
import 'package:sodong_app/features/post/presentation/pages/post_detail/widgets/detail_category.dart';
import 'package:sodong_app/features/post/presentation/pages/post_detail/widgets/detail_comment_input.dart';
import 'package:sodong_app/features/post/presentation/pages/post_detail/widgets/detail_comment_item.dart';
import 'package:sodong_app/features/post/presentation/pages/post_detail/widgets/detail_content.dart';
import 'package:sodong_app/features/post/presentation/pages/post_detail/widgets/detail_header.dart';
import 'package:sodong_app/features/post/presentation/pages/post_detail/widgets/detail_image_view.dart';
import 'package:sodong_app/features/post/presentation/pages/post_detail/widgets/detail_loctaion.dart';
import 'package:sodong_app/features/post/presentation/pages/post_detail/widgets/detail_title.dart';
import 'package:sodong_app/features/post/providers/post_providers.dart';
import 'package:tuple/tuple.dart';

class PostDetailPage extends ConsumerWidget {
  const PostDetailPage({
    super.key,
    required this.location,
    required this.category,
    required this.postId,
  });

  final String location;
  final String category;
  final String postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAsync = ref.watch(
      postDetailStreamProvider(Tuple3(location, category, postId)),
    );

    final comments = ref.watch(
      commentViewModelProvider(Tuple3(location, category, postId)),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFE4E8),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '게시글 상세',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          PostDetailActions(postId: postId),
        ],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: postAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('에러: ${e.toString()}')),
          data: (post) {
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      DetailHeader(
                        isAnonymous: post.isAnonymous,
                        nickname: post.nickname,
                        profileImageUrl: post.profileImageUrl,
                      ),
                      const SizedBox(height: 16),
                      DetailTitle(title: post.title),
                      const SizedBox(height: 16),
                      DetailContent(content: post.content),
                      const SizedBox(height: 16),
                      DetailImageView(imageUrls: post.imageUrls),
                      const SizedBox(height: 16),
                      DetailCategory(category: post.category),
                      const SizedBox(height: 16),
                      DetailLocation(location: post.region),
                      const SizedBox(height: 24),
                      const Text(
                        '댓글',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (comments.isEmpty)
                        const Text('댓글이 없습니다.')
                      else
                        ...comments.map((comment) {
                          final duration =
                              DateTime.now().difference(comment.createdAt);
                          String timeAgo;
                          if (duration.inMinutes < 1) {
                            timeAgo = '방금 전';
                          } else if (duration.inHours < 1) {
                            timeAgo = '${duration.inMinutes}분 전';
                          } else if (duration.inDays < 1) {
                            timeAgo = '${duration.inHours}시간 전';
                          } else {
                            timeAgo = '${duration.inDays}일 전';
                          }

                          return DetailCommentItem(
                            text: comment.content,
                            time: timeAgo,
                          );
                        }).toList(),
                    ],
                  ),
                ),
                DetailCommentInput(
                  location: location,
                  category: category,
                  postId: postId,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
