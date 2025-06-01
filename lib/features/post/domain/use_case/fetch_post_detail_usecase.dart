import 'package:sodong_app/features/post/domain/entities/post.dart';
import 'package:sodong_app/features/post/domain/repository/post_detail_repository.dart';
import 'package:sodong_app/features/post/domain/entities/category.dart';

class FetchPostDetailUseCase {
  FetchPostDetailUseCase(this.repository);
  final PostDetailRepository repository;

  Stream<Post> call(String location, TownLifeCategory category, String postId) {
    return repository.getPostDetail(location, category, postId);
  }
}
