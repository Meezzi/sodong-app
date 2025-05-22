import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/post_detail/presentation/pages/post_detail_page.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => _navigateToDetailPage(context),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        elevation: 0,
        color: isDark ? const Color(0xFF2A2A2A) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isDark ? Colors.transparent : const Color(0xFFFFD5DE),
            width: 0.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategoryTag(isDark),
              const SizedBox(height: 12),
              _buildTitle(isDark),
              const SizedBox(height: 8),
              _buildContent(isDark),
              const SizedBox(height: 12),
              _buildImage(isDark),
              _buildLocationInfo(isDark),
              const SizedBox(height: 16),
              _buildInteractionBar(ref, isLiked, isDark),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToDetailPage(BuildContext context) {
    // location, category, postId가 모두 유효한지 확인
    if (post.location.isEmpty || post.category.isEmpty || post.postId.isEmpty) {
      // 데이터가 유효하지 않으면 스낵바로 알림
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('게시물 정보가 유효하지 않습니다. 다시 시도해주세요.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailPage(
          location: post.location,
          category: post.category,
          postId: post.postId,
        ),
      ),
    );
  }

  Widget _buildCategoryTag(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF424242) : Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        post.category,
        style: TextStyle(
          fontSize: 12,
          color: isDark ? Colors.grey[300] : Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildTitle(bool isDark) {
    return Text(
      post.title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _buildContent(bool isDark) {
    return Text(
      post.content,
      style: TextStyle(
        fontSize: 14,
        color: isDark ? Colors.grey[300] : Colors.black87,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildImage(bool isDark) {
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
                  color: isDark ? Colors.grey[800] : Colors.grey[300],
                  child: Center(
                    child: Icon(
                      Icons.error_outline,
                      color: isDark ? Colors.grey[400] : Colors.grey,
                    ),
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
                      color: isDark ? Colors.grey[800] : Colors.grey[300],
                      child: Center(
                        child: Icon(
                          Icons.error_outline,
                          color: isDark ? Colors.grey[400] : Colors.grey,
                        ),
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
                        color: const Color.fromRGBO(0, 0, 0, 0.6),
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

  Widget _buildLocationInfo(bool isDark) {
    return Row(
      children: [
        Text(
          post.location,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        Text(' • ',
            style: TextStyle(color: isDark ? Colors.grey[500] : Colors.grey)),
        Text(
          post.timeAgo,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildInteractionBar(WidgetRef ref, bool isLiked, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 16,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Text(
              '${post.commentCount}',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                // 좋아요 상태 토글
                ref.read(likedPostsProvider.notifier).toggleLike(index);
              },
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                size: 16,
                color: isLiked
                    ? isDark
                        ? const Color(0xFFFF9CAA)
                        : const Color(0xFFFF7B8E)
                    : isDark
                        ? Colors.grey[400]
                        : Colors.grey[600],
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '${post.likeCount}',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
