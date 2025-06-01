import 'package:sodong_app/features/post/domain/entities/post.dart';

abstract class PostDetailRepository {
  Stream<Post> getPostDetail(
      String location, String category, String postId);
}
