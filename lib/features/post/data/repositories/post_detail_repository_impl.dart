import 'package:sodong_app/features/post/data/data_source/post_detail_data_source.dart';
import 'package:sodong_app/features/post/domain/entities/post.dart';
import 'package:sodong_app/features/post/domain/repository/post_detail_repository.dart';

class PostDetailRepositoryImpl implements PostDetailRepository {
  PostDetailRepositoryImpl(this.remoteDataSource);

  final PostDetailDataSource remoteDataSource;

  @override
  Stream<Post> getPostDetail(
    String location,
    String category,
    String postId,
  ) {
    return remoteDataSource
        .getPostDetail(location, category, postId)
        .map((postDto) => postDto.toEntity(postDto));
  }
}
