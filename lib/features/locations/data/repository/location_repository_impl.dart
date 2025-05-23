import 'package:sodong_app/features/locations/data/data_source/vworld_location_data_source.dart';
import 'package:sodong_app/features/locations/domain/repository/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  LocationRepositoryImpl({required this.dataSource});
  final VworldLocationDataSource dataSource;

  @override
  Future<List<String>> findByLatLng(
      {required double lat, required double lng}) {
    return dataSource.findByLatLng(lat: lat, lng: lng);
  }

  @override
  Future<List<String>> findByName(String query) {
    return dataSource.findByName(query);
  }
}
