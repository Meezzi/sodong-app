import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/post_list/domain/models/town_life_post.dart';
import 'package:sodong_app/features/post_list/presentation/view_models/town_life_view_model.dart';

class TownLifePostItem extends ConsumerWidget {
  final TownLifePost post;
  final int index;

  const TownLifePostItem({super.key, required this.post, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLiked = ref.watch(likedPostsProvider)[index] ?? false;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategoryTag(),
            const SizedBox(height: 12),
            _buildTitle(),
            const SizedBox(height: 8),
            _buildContent(),
            const SizedBox(height: 12),
            _buildImage(),
            _buildLocationInfo(),
            const SizedBox(height: 16),
            _buildInteractionBar(ref, isLiked),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        post.category,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      post.title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildContent() {
    return Text(
      post.content,
      style: const TextStyle(fontSize: 14),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildImage() {
    if (post.imageUrl == null) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 200,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: NetworkImage(post.imageUrl!),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildLocationInfo() {
    return Row(
      children: [
        Text(
          post.location,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const Text(' • ', style: TextStyle(color: Colors.grey)),
        Text(
          post.timeAgo,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildInteractionBar(WidgetRef ref, bool isLiked) {
    return Row(
      children: [
        _buildCommentButton(),
        const SizedBox(width: 16),
        _buildLikeButton(ref, isLiked),
      ],
    );
  }

  Widget _buildCommentButton() {
    return Row(
      children: [
        const Icon(Icons.chat_bubble_outline, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          '댓글 ${post.commentCount}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildLikeButton(WidgetRef ref, bool isLiked) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            ref.read(likedPostsProvider.notifier).toggleLike(index);
          },
          child: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            size: 16,
            color: isLiked ? const Color(0xFFFF7B8E) : Colors.grey,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '좋아요 ${post.likeCount + (isLiked ? 1 : 0)}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
