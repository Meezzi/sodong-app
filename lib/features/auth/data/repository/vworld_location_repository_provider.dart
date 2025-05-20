// vworld_location_repository_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/auth/data/repository/vworld_Location_repositiry.dart';

final vworldRepositoryProvider = Provider<VWorldLocationRepository>((ref) {
  return VWorldLocationRepository();
});
