import 'package:sodong_app/features/post/domain/entities/post.dart';
import 'package:sodong_app/features/post_list/domain/models/category.dart';

abstract class PostDetailRepository {
  Stream<Post> getPostDetail(
    String location,
    TownLifeCategory category,
    String postId,
  );
}
