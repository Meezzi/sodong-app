import 'package:sodong_app/features/post/data/data_source/remote_post_detail_data_source.dart';
import 'package:sodong_app/features/post/domain/entities/post.dart';
import 'package:sodong_app/features/post_detail/domain/repositories/post_detail_repository.dart';

class PostDetailRepositoryImpl implements PostDetailRepository {
  PostDetailRepositoryImpl(this.remoteDataSource);
  final RemotePostDetailDataSource remoteDataSource;

  @override
  Stream<Post> getPostDetail(
      String location, String category, String postId) {
    return remoteDataSource.getPostDetail(location, category, postId);
  }
}
