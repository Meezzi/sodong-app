import 'package:sodong_app/features/post_detail/data/data_sources/post_detail_data_source.dart';
import 'package:sodong_app/features/post_detail/domain/entities/post_detail_entity.dart';
import 'package:sodong_app/features/post_detail/domain/repositories/post_detail_repository.dart';

class PostDetailRepositoryImpl implements PostDetailRepository {
  PostDetailRepositoryImpl(this.remoteDataSource);
  final PostDetailDataSource remoteDataSource;

  @override
  Stream<PostDetail> getPostDetail(
      String location, String category, String postId) {
    return remoteDataSource.getPostDetail(location, category, postId);
  }
}
