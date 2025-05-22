import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/post_list/domain/models/town_life_post.dart';
import 'package:sodong_app/features/post_list/presentation/view_models/liked_posts_view_model.dart';

class TownLifePostItem extends ConsumerWidget {
  const TownLifePostItem({
    super.key,
    required this.post,
    required this.index,
  });

  final TownLifePost post;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isLiked = ref.watch(likedPostsProvider)[index] ?? false;

    return GestureDetector(
      // TODO: 상세페이지 연결
      // onTap: () => _navigateToDetailPage(context),
      child: Card(
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
      ),
    );
  }
  // TODO: 상세페이지 연결
  // void _navigateToDetailPage(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => PostDetailPage(
  //         post: post,
  //         index: index,
  //       ),
  //     ),
  //   );
  // }

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
    // 이미지가 없는 경우
    if (post.imageUrl == null && post.imageUrls.isEmpty) {
      return const SizedBox.shrink();
    }

    // 이미지가 하나만 있는 경우
    if (post.imageUrls.length <= 1) {
      // Firebase Storage URL이 포함된 이미지 처리
      if (post.imageUrl != null &&
          post.imageUrl!.contains('firebasestorage.googleapis.com')) {
        return Container(
          height: 200,
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              post.imageUrl!,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.error_outline, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
        );
      }

      // 일반 이미지
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

    // 여러 이미지가 있는 경우 - 이미지 캐러셀 형태로 표시
    return Container(
      height: 200,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: PageView.builder(
          itemCount: post.imageUrls.length,
          itemBuilder: (context, index) {
            final imageUrl = post.imageUrls[index];
            return Stack(
              children: [
                Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.error_outline, color: Colors.grey),
                      ),
                    );
                  },
                ),
                // 이미지 인디케이터
                if (post.imageUrls.length > 1)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${index + 1}/${post.imageUrls.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
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
