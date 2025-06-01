import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/post/domain/use_case/create_post_use_case.dart';
import 'package:sodong_app/features/post/data/data_source/post_data_source.dart';
import 'package:sodong_app/features/post/data/data_source/remote_post_data_source.dart';
import 'package:sodong_app/features/post/data/repositories/remote_post_repository.dart';
import 'package:sodong_app/features/post/domain/repository/post_repository.dart';

final _postDatasourceProvider = Provider<PostDataSource>((ref) {
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  return RemotePostDataSource(firestore, storage);
});

final _postRepositoryProvider = Provider<PostRepository>(
  (ref) {
    final datasource = ref.read(_postDatasourceProvider);
    return RemotePostRepository(datasource);
  },
);

final _createPostUsecaseProvider = Provider(
  (ref) {
    final repository = ref.read(_postRepositoryProvider);
    return CreatePostUseCase(repository);
  },
);
