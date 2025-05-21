import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/post_detail/data/data_sources/comment_data_source.dart';
import 'package:sodong_app/features/post_detail/data/repository/comment_repository_impl.dart';
import 'package:sodong_app/features/post_detail/domain/repositories/comment_repository.dart';
import 'package:sodong_app/features/post_detail/domain/usecases/add_comment_usecase.dart';
import 'package:sodong_app/features/post_detail/domain/usecases/get_comment_usecase.dart';

/// 데이터 소스 주입
final commentDataSourceProvider = Provider<CommentDataSource>((ref) {
  return CommentDataSource();
});

/// 리포지토리 주입
final commentRepositoryProvider = Provider<CommentRepository>((ref) {
  final dataSource = ref.watch(commentDataSourceProvider);
  return CommentRepositoryImpl(dataSource);
});

/// 유즈케이스 주입
final getCommentsUseCaseProvider = Provider<GetCommentsUseCase>((ref) {
  return GetCommentsUseCase(ref.watch(commentRepositoryProvider));
});

final addCommentUseCaseProvider = Provider<AddCommentUseCase>((ref) {
  return AddCommentUseCase(ref.watch(commentRepositoryProvider));
});
