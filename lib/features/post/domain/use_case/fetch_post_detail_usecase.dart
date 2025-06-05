import 'package:sodong_app/features/post/domain/entities/post.dart';
import 'package:sodong_app/features/post/domain/repository/post_detail_repository.dart';

class FetchPostDetailUseCase {
  FetchPostDetailUseCase(this.repository);
  final PostDetailRepository repository;

  Stream<Post> call(String location, String category, String postId) {
    return repository.getPostDetail(location, category, postId);
  }
}
