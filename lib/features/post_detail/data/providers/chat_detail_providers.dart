import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/post_detail/data/dtos/post_detail_dto.dart';
import 'package:sodong_app/features/post_detail/data/repository/post_detail_repository.dart';
import 'package:tuple/tuple.dart';

final postInfoProvider = StateProvider<Tuple3<String?, String?, String?>>(
    (ref) => const Tuple3(null, null, null));

final postRepositoryProvider = Provider<PostDetailRepository>((ref) {
  return PostDetailRepository();
});

final postStreamProvider = StreamProvider<PostDetail>((ref) {
  final postInfo = ref.watch(postInfoProvider);
  final repository = ref.read(postRepositoryProvider);

  final location = postInfo.item1;
  final category = postInfo.item2;
  final postId = postInfo.item3;

  if (location == null || category == null || postId == null) {
    throw Exception('location/category/postId가 설정되지 않았습니다.');
  }

  return repository.getPostStream(location, category, postId);
});
