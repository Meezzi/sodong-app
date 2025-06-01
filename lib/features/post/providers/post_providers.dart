import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/post/data/data_source/create_post_data_source.dart';
import 'package:sodong_app/features/post/data/data_source/post_detail_data_source.dart';
import 'package:sodong_app/features/post/data/data_source/remote_create_post_data_source.dart';
import 'package:sodong_app/features/post/data/data_source/remote_post_detail_data_source.dart';
import 'package:sodong_app/features/post/data/mapper/post_mapper.dart';
import 'package:sodong_app/features/post/data/repositories/post_detail_repository_impl.dart';
import 'package:sodong_app/features/post/data/repositories/remote_post_repository.dart';
import 'package:sodong_app/features/post/domain/entities/post.dart';
import 'package:sodong_app/features/post/domain/repository/post_repository.dart';
import 'package:sodong_app/features/post/domain/use_case/create_post_use_case.dart';
import 'package:sodong_app/features/post/domain/use_case/fetch_post_detail_usecase.dart';
import 'package:sodong_app/features/post/presentation/view_models/create_post_view_model.dart';
import 'package:sodong_app/features/post_list/domain/models/category.dart';
import 'package:tuple/tuple.dart';

final _postMapperProvider = Provider<PostMapper>((ref) {
  return PostMapper();
});

final _createPostDatasourceProvider = Provider<CreatePostDataSource>((ref) {
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  return RemoteCreatePostDataSource(firestore, storage);
});

final _postDetailDataSourceProvider = Provider<PostDetailDataSource>((ref) {
  return RemotePostDetailDataSource();
});

final _postRepositoryProvider = Provider<PostRepository>(
  (ref) {
    final datasource = ref.read(_createPostDatasourceProvider);
    final mapper = ref.read(_postMapperProvider);
    return RemotePostRepository(datasource, mapper);
  },
);

final _createPostUsecaseProvider = Provider(
  (ref) {
    final repository = ref.read(_postRepositoryProvider);
    return CreatePostUseCase(repository);
  },
);

final createPostViewModelProvider =
    StateNotifierProvider.autoDispose<CreatePostViewModel, CreatePostState>(
        (ref) {
  final usecase = ref.read(_createPostUsecaseProvider);
  return CreatePostViewModel(usecase);
});

final _postDetailRepositoryProvider = Provider((ref) {
  final datasource = ref.read(_postDetailDataSourceProvider);
  final mapper = ref.read(_postMapperProvider);
  PostDetailRepositoryImpl(datasource, mapper);
});

final fetchPostDetailUseCaseProvider = Provider<FetchPostDetailUseCase>((ref) {
  final repository = ref.read(_postDetailRepositoryProvider);
  return FetchPostDetailUseCase(repository);
});

final postDetailStreamProvider = StreamProvider.autoDispose
    .family<Post, Tuple3<String, TownLifeCategory, String>>((ref, args) {
  final usecase = ref.read(fetchPostDetailUseCaseProvider);
  return usecase(args.item1, args.item2, args.item3);
});
