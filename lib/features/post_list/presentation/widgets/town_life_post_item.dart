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

    return GestureDetector(
      onTap: () => _navigateToDetailPage(context),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF7B8E).withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 게시물 헤더 (카테고리, 작성자, 시간 정보)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    _buildCategoryTag(),
                    const Spacer(),
                    _buildLocationInfo(),
                  ],
                ),
              ),

              // 게시물 제목
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: _buildTitle(),
              ),

              // 게시물 내용
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: _buildContent(),
              ),

              // 게시물 이미지 (있는 경우)
              _buildImage(),

              // 상호작용 바 (댓글, 좋아요)
              Padding(
                padding: const EdgeInsets.all(16),
                child: _buildInteractionBar(ref, isLiked),
              ),
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
        const SnackBar(
          content: Text('게시물 정보가 유효하지 않습니다. 다시 시도해주세요.'),
          backgroundColor: Color(0xFFFF7B8E),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
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

  Widget _buildCategoryTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE4E8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        post.category,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFF7B8E),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      post.title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildContent() {
    return Text(
      post.content,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black54,
        height: 1.4,
      ),
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
          decoration: const BoxDecoration(
            color: Color(0xFFF5F5F5),
          ),
          child: ClipRRect(
            child: Image.network(
              post.imageUrl!,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Color(0xFFFF7B8E)),
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
                  color: const Color(0xFFFFE4E8),
                  child: const Center(
                    child: Icon(Icons.error_outline, color: Color(0xFFFF7B8E)),
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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(post.imageUrl!),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    // 여러 이미지가 있는 경우 - 이미지 캐러셀 형태로 표시
    return SizedBox(
      height: 200,
      width: double.infinity,
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
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFFFF7B8E)),
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFFFFE4E8),
                    child: const Center(
                      child:
                          Icon(Icons.error_outline, color: Color(0xFFFF7B8E)),
                    ),
                  );
                },
              ),
              // 이미지 인디케이터
              if (post.imageUrls.length > 1)
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${index + 1}/${post.imageUrls.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLocationInfo() {
    return Row(
      children: [
        const Icon(
          Icons.access_time_rounded,
          size: 14,
          color: Colors.grey,
        ),
        const SizedBox(width: 4),
        Text(
          post.timeAgo,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildInteractionBar(WidgetRef ref, bool isLiked) {
    return Row(
      children: [
        _buildCommentButton(),
        const Spacer(),
        _buildLikeButton(ref, isLiked),
      ],
    );
  }

  Widget _buildCommentButton() {
    return Row(
      children: [
        const Icon(
          Icons.chat_bubble_outline_rounded,
          size: 18,
          color: Color(0xFFFF7B8E),
        ),
        const SizedBox(width: 6),
        Text(
          '댓글 ${post.commentCount}',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
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
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isLiked ? const Color(0xFFFFE4E8) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border_rounded,
              size: 18,
              color: const Color(0xFFFF7B8E),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '좋아요 ${post.likeCount + (isLiked ? 1 : 0)}',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
