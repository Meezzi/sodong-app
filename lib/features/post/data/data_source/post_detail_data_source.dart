import 'package:sodong_app/features/post/data/dto/post_dto.dart';
import 'package:sodong_app/features/post/domain/entities/category.dart';

abstract interface class PostDetailDataSource {
  /// Post 상세 보기
  Stream<PostDto> getPostDetail(
    String location,
    TownLifeCategory category,
    String postId,
  );
}
