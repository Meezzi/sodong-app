import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/post_detail/data/dtos/post_detail_dto.dart';
import 'package:sodong_app/features/post_detail/data/repository/post_detail_repository_impl.dart';
import 'package:tuple/tuple.dart';

final postRepositoryProvider = Provider<PostDetailRepository>((ref) {
  return PostDetailRepository();
});

final postStreamProvider = StreamProvider.autoDispose
    .family<PostDetail, Tuple3<String?, String?, String?>>((ref, arg) {
  final repository = ref.read(postRepositoryProvider);

  final location = arg.item1;
  final category = arg.item2;
  final postId = arg.item3;

  if (location == null || category == null || postId == null) {
    throw Exception('location/category/postId가 설정되지 않았습니다.');
  }

  return repository.getPostStream(location, category, postId);
});
