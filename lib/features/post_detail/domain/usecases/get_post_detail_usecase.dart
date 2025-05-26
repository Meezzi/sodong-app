import 'package:sodong_app/features/post_detail/domain/entities/post_detail_entity.dart';
import 'package:sodong_app/features/post_detail/domain/repositories/post_detail_repository.dart';

class GetPostDetail {
  GetPostDetail(this.repository);
  final PostDetailRepository repository;

  Stream<PostDetail> call(String location, String category, String postId) {
    return repository.getPostDetail(location, category, postId);
  }
}
