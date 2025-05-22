import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/profile/data/data_sources/profile_data_source.dart';
import 'package:sodong_app/features/profile/data/repositories/profile_repository_impl.dart';

/// Firestore 기반 UserRepository DI 등록
final profileProvider = Provider((ref) {
  final firestore = FirebaseFirestore.instance;
  final dataSource = ProfileDataSource(firestore);
  return ProfileRepositoryImpl(dataSource);
});
