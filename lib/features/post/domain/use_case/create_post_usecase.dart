import 'package:sodong_app/core/result/result.dart';
import 'package:sodong_app/features/post/domain/entities/post.dart';
import 'package:sodong_app/features/post/domain/repository/post_repository.dart';
import 'package:sodong_app/features/post_list/domain/models/category.dart';

class CreatePostUsecase {
  CreatePostUsecase(this._repository);

  final PostRepository _repository;

  Future<Result<Post>> execute({
    required String location,
    required TownLifeCategory category,
    required Post post,
    required List<String> imagePaths,
  }) async {
    return await _repository.createPostWithImages(
      location,
      category,
      imagePaths,
      post,
    );
  }
}
