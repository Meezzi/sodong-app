import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/post_detail/data/dtos/post_detail_dto.dart';
import 'package:sodong_app/post_detail/data/repository/post_detail_repository.dart';

final postRepositoryProvider = Provider<PostDetailRepository>((ref) {
  return PostDetailRepository();
});

final postStreamProvider =
    StreamProvider.family<PostDetail, String>((ref, postId) {
  final repository = ref.read(postRepositoryProvider);
  return repository.getPostStream(postId);
});
