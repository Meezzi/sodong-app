import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/post_detail/data/dtos/post_detail_dto.dart';
import 'package:sodong_app/post_detail/data/repository/post_detail_repository.dart';

final postIdProvider = StateProvider<String?>((ref) => null);

final postRepositoryProvider = Provider<PostDetailRepository>((ref) {
  return PostDetailRepository();
});

final postStreamProvider = StreamProvider<PostDetail>((ref) {
  final postId = ref.watch(postIdProvider);
  final repository = ref.read(postRepositoryProvider);

  if (postId == null) {
    throw Exception('postId가 설정되지 않았습니다.');
  }

  return repository.getPostStream(postId);
});
