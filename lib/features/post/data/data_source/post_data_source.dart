import 'package:sodong_app/features/post/domain/entities/post.dart';
import 'package:sodong_app/features/post_list/domain/models/category.dart';

abstract interface class PostDataSource {
  /// Post 저장
  Future<Post> createPostWithImages(
    String location,
    TownLifeCategory category,
    List<String> imageUrls,
    Post post,
  );
}