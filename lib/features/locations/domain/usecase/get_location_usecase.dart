import 'package:geolocator/geolocator.dart';
import 'package:sodong_app/features/locations/data/data_source/vworld_location_data_source.dart';
import 'package:sodong_app/features/locations/domain/entity/location.dart';

class GetLocationUseCase {
  GetLocationUseCase(this.repository);
  final VworldLocationDataSource repository;

  Future<Location> call() async {
    // 위치 권한 체크 및 요청
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        throw Exception('위치 권한 거부됨');
      }
    }

    // GPS 가져오도록 함
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    final results = await repository.findByLatLng(
        lat: position.latitude, lng: position.longitude);

    String? region;
    if (results.isNotEmpty) {
      final parts = results.first.split(' ');
      region = parts.length >= 2 ? '${parts[0]} ${parts[1]}' : results.first;
    }

    return Location(
        x: position.longitude, y: position.latitude, region: region);
  }
}
