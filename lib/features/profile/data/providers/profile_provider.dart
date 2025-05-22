import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/profile/data/data_sources/profile_data_source.dart';
import 'package:sodong_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:sodong_app/features/profile/domain/repositories/profile_repository.dart';

/// Firestore 기반 UserRepository DI 등록
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final dataSource = ref.watch(profileDataSourceProvider);
  return ProfileRepositoryImpl(dataSource);
});
