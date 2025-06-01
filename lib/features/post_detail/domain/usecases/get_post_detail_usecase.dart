import 'package:sodong_app/features/post/domain/entities/post.dart';
import 'package:sodong_app/features/post_detail/domain/repositories/post_detail_repository.dart';

class GetPostDetail {
  GetPostDetail(this.repository);
  final PostDetailRepository repository;

  Stream<Post> call(String location, String category, String postId) {
    return repository.getPostDetail(location, category, postId);
  }
}
