import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/locations/data/data_source/vworld_location_datasource_impl.dart';
import 'package:sodong_app/features/locations/data/repository/location_repository_impl.dart';
import 'package:sodong_app/features/locations/domain/repository/location_repository.dart';
import 'package:sodong_app/features/locations/domain/usecase/get_location_by_latlng_usecase.dart';

// Dio Provider
final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

// Repository Provider
final locationRepositoryProvider = Provider<LocationRepository>(
  (ref) => LocationRepositoryImpl(
      dataSource: ref.read(vworldLocationDataSourceProvider)),
);

// DataSource Provider
final vworldLocationDataSourceProvider = Provider<VWorldLocationDataSourceImpl>(
  (ref) => VWorldLocationDataSourceImpl(client: ref.read(dioProvider)),
);

// UseCase Provider
final getLocationByLatLngUseCaseProvider = Provider<GetLocationByLatLngUseCase>(
  (ref) {
    final repository = ref.read(locationRepositoryProvider);
    return GetLocationByLatLngUseCase(repository: repository);
  },
);
