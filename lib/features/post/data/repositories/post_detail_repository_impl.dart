import 'package:sodong_app/features/post/data/data_source/post_detail_data_source.dart';
import 'package:sodong_app/features/post/data/mapper/post_mapper.dart';
import 'package:sodong_app/features/post/domain/entities/post.dart';
import 'package:sodong_app/features/post/domain/repository/post_detail_repository.dart';
import 'package:sodong_app/features/post_list/domain/models/category.dart';

class PostDetailRepositoryImpl implements PostDetailRepository {
  PostDetailRepositoryImpl(this.remoteDataSource, this._postMapper);

  final PostDetailDataSource remoteDataSource;
  final PostMapper _postMapper;

  @override
  Stream<Post> getPostDetail(
    String location,
    TownLifeCategory category,
    String postId,
  ) {
    return remoteDataSource
        .getPostDetail(location, category, postId)
        .map((postDto) => _postMapper.fromDto(postDto));
  }
}
