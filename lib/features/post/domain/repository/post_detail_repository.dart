import 'package:sodong_app/features/post/domain/entities/post.dart';
import 'package:sodong_app/features/post/domain/entities/category.dart';

abstract class PostDetailRepository {
  Stream<Post> getPostDetail(
    String location,
    TownLifeCategory category,
    String postId,
  );
}
