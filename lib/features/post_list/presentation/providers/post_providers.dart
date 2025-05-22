import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/post_list/data/datasources/post_cache_data_source.dart';
import 'package:sodong_app/features/post_list/data/datasources/post_remote_data_source.dart';
import 'package:sodong_app/features/post_list/data/repositories/post_repository_impl.dart';
import 'package:sodong_app/features/post_list/domain/repositories/post_repository.dart';
import 'package:sodong_app/features/post_list/domain/services/post_service.dart';

/// Firestore 인스턴스 제공
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

/// 원격 데이터 소스 제공
final postRemoteDataSourceProvider = Provider<PostRemoteDataSource>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return PostRemoteDataSource(firestore: firestore);
});

/// 캐시 데이터 소스 제공
final postCacheDataSourceProvider = Provider<PostCacheDataSource>((ref) {
  return PostCacheDataSource();
});

/// 저장소 구현체 제공
final postRepositoryProvider = Provider<PostRepository>((ref) {
  final remoteDataSource = ref.watch(postRemoteDataSourceProvider);
  final cacheDataSource = ref.watch(postCacheDataSourceProvider);

  return PostRepositoryImpl(
    remoteDataSource: remoteDataSource,
    cacheDataSource: cacheDataSource,
  );
});

/// 게시물 서비스 제공
final postServiceProvider = Provider<PostService>((ref) {
  final repository = ref.watch(postRepositoryProvider);
  return PostService(repository);
});
