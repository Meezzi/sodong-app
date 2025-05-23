import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/post_detail/data/data_sources/post_detail_data_source.dart';
import 'package:sodong_app/features/post_detail/data/repository/post_detail_repository_impl.dart';
import 'package:sodong_app/features/post_detail/domain/entities/post_detail_entity.dart';
import 'package:sodong_app/features/post_detail/domain/usecases/get_post_detail_usecase.dart';
import 'package:tuple/tuple.dart';

final remoteDataSourceProvider = Provider((ref) => PostDetailDataSource());

final postDetailRepositoryProvider = Provider(
    (ref) => PostDetailRepositoryImpl(ref.read(remoteDataSourceProvider)));

final getPostDetailProvider =
    Provider((ref) => GetPostDetail(ref.read(postDetailRepositoryProvider)));

final postDetailStreamProvider = StreamProvider.autoDispose
    .family<PostDetail, Tuple3<String, String, String>>((ref, args) {
  final usecase = ref.read(getPostDetailProvider);
  return usecase(args.item1, args.item2, args.item3);
});
