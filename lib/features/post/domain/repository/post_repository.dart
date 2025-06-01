import 'package:sodong_app/core/result/result.dart';
import 'package:sodong_app/features/post/domain/entities/post.dart';
import 'package:sodong_app/features/post/domain/entities/category.dart';

abstract interface class PostRepository {
  /// Post 저장
  Future<Result<Post>> createPostWithImages(
    String location,
    TownLifeCategory category,
    List<String> imagePaths,
    Post post,
  );
}
