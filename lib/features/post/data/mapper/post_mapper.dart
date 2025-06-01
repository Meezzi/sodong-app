import 'package:sodong_app/features/post/data/dto/post_dto.dart';
import 'package:sodong_app/features/post/domain/entities/post.dart';

class PostMapper {
  /// Post Entity -> Post Dto 변환
  PostDto toDto(Post post) {
    return PostDto(
      postId: post.postId,
      category: post.category,
      title: post.title,
      content: post.content,
      region: post.region,
      createdAt: post.createdAt,
      isAnonymous: post.isAnonymous,
      userId: post.userId,
      nickname: post.nickname,
      commentCount: post.commentCount,
      profileImageUrl: post.profileImageUrl,
      imageUrls: post.imageUrls,
    );
  }

/// Post Dto -> Post Entity 변환
  Post fromDto(PostDto dto) {
    return Post(
      postId: dto.postId,
      category: dto.category,
      title: dto.title,
      content: dto.content,
      region: dto.region,
      createdAt: dto.createdAt,
      isAnonymous: dto.isAnonymous,
      userId: dto.userId,
      nickname: dto.nickname,
      commentCount: dto.commentCount,
      profileImageUrl: dto.profileImageUrl,
      imageUrls: dto.imageUrls,
    );
  }
}
