import 'package:sodong_app/features/post/data/dto/post_dto.dart';
import 'package:sodong_app/features/post_list/domain/models/category.dart';

abstract interface class CreatePostDataSource {
  /// Post 저장
  Future<PostDto> createPostWithImages(
    String location,
    TownLifeCategory category,
    List<String> imageUrls,
    PostDto post,
  );
}