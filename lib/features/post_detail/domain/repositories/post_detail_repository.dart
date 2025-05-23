import 'package:sodong_app/features/post_detail/domain/entities/post_detail_entity.dart';

abstract class PostDetailRepository {
  Stream<PostDetail> getPostDetail(
      String location, String category, String postId);
}
