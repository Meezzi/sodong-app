import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/post/data/data_source/create_post_data_source.dart';
import 'package:sodong_app/features/post/data/data_source/post_detail_data_source.dart';
import 'package:sodong_app/features/post/data/data_source/remote_create_post_data_source.dart';
import 'package:sodong_app/features/post/data/data_source/remote_post_detail_data_source.dart';
import 'package:sodong_app/features/post/data/repositories/post_detail_repository_impl.dart';
import 'package:sodong_app/features/post/data/repositories/remote_post_repository.dart';
import 'package:sodong_app/features/post/domain/entities/post.dart';
import 'package:sodong_app/features/post/domain/repository/post_repository.dart';
import 'package:sodong_app/features/post/domain/use_case/create_post_use_case.dart';
import 'package:sodong_app/features/post/domain/use_case/fetch_post_detail_usecase.dart';
import 'package:sodong_app/features/post/presentation/view_models/create_post_view_model.dart';
import 'package:tuple/tuple.dart';

/// 게시물을 생성하는 CreatePostDataSource Provider
final _createPostDatasourceProvider = Provider<CreatePostDataSource>((ref) {
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  return RemoteCreatePostDataSource(firestore, storage);
});

/// 게시물을 생성하는 PostRepository Provider
final _postRepositoryProvider = Provider<PostRepository>((ref) {
  final datasource = ref.read(_createPostDatasourceProvider);
  return RemotePostRepository(datasource);
});

/// 게시물을 생성하는 CreatePostUseCase Provider
final _createPostUsecaseProvider = Provider<CreatePostUseCase>((ref) {
  final repository = ref.read(_postRepositoryProvider);
  return CreatePostUseCase(repository);
});

/// 게시물을 생성하는 CreatePostViewModel Provider
final createPostViewModelProvider =
    StateNotifierProvider.autoDispose<CreatePostViewModel, CreatePostState>(
        (ref) {
  final usecase = ref.read(_createPostUsecaseProvider);
  return CreatePostViewModel(usecase);
});

/// 게시물의 상세보기 데이터를 가져오는 PostDetailDataSource Provider
final _postDetailDataSourceProvider = Provider<PostDetailDataSource>((ref) {
  return RemotePostDetailDataSource();
});

/// 게시물의 상세보기 데이터를 가져오는 PostDetailRepository Provider
final _postDetailRepositoryProvider = Provider<PostDetailRepositoryImpl>((ref) {
  final datasource = ref.read(_postDetailDataSourceProvider);
  return PostDetailRepositoryImpl(datasource);
});

/// 게시물의 상세보기 데이터를 가져오는 FetchPostDetailUseCase Provider
final fetchPostDetailUseCaseProvider = Provider<FetchPostDetailUseCase>((ref) {
  final repository = ref.read(_postDetailRepositoryProvider);
  return FetchPostDetailUseCase(repository);
});

/// 게시물의 상세보기 데이터를 가져오는 PostDetailStreamProvider
final postDetailStreamProvider = StreamProvider.autoDispose
    .family<Post, Tuple3<String, String, String>>((ref, args) {
  final usecase = ref.read(fetchPostDetailUseCaseProvider);
  return usecase(args.item1, args.item2, args.item3);
});
