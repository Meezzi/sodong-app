import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/comment/data/data_sources/comment_data_source.dart';
import 'package:sodong_app/features/post_detail/data/repository/comment_repository_impl.dart';
import 'package:sodong_app/features/post_detail/domain/entities/comment_entity.dart';
import 'package:sodong_app/features/post_detail/domain/repositories/comment_repository.dart';
import 'package:sodong_app/features/post_detail/domain/usecases/add_comment_usecase.dart';
import 'package:sodong_app/features/post_detail/domain/usecases/get_comment_usecase.dart';
import 'package:tuple/tuple.dart';

// 데이터 소스
final commentDataSourceProvider = Provider<CommentDataSource>((ref) {
  return CommentDataSource();
});

// 리포지토리
final commentRepositoryProvider = Provider<CommentRepository>((ref) {
  final service = ref.read(commentDataSourceProvider);
  return CommentRepositoryImpl(service);
});

// 댓글 조회 유즈케이스
final getCommentsUseCaseProvider = Provider<GetCommentsUseCase>((ref) {
  final repo = ref.read(commentRepositoryProvider);
  return GetCommentsUseCase(repo);
});

// 댓글 추가 유즈케이스
final addCommentUseCaseProvider = Provider<AddCommentUseCase>((ref) {
  final repo = ref.read(commentRepositoryProvider);
  return AddCommentUseCase(repo);
});

// 댓글 스트림
final commentStreamProvider =
    StreamProvider.family<List<Comment>, Tuple3<String, String, String>>(
        (ref, params) {
  final location = params.item1;
  final category = params.item2;
  final postId = params.item3;

  final useCase = ref.read(getCommentsUseCaseProvider);
  return useCase.stream(location, category, postId);
});
