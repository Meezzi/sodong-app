import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sodong_app/features/locations/domain/entity/location.dart';
import 'package:sodong_app/features/locations/domain/usecase/get_location_by_latlng_usecase.dart';
import 'package:sodong_app/features/locations/presentation/provider/providers.dart';

class LocationViewmodel extends Notifier<Location> {
  late final GetLocationByLatLngUseCase getLocationUseCase =
      ref.read(getLocationByLatLngUseCaseProvider);

  @override
  Location build() {
    // 초기의 기본 위치값 설정(초기 위치 일단 null로 지정)
    return Location(x: 129.0823133, y: 35.2202216, region: null);
  }

  Future<bool> getLocation() async {
    try {
      // 1. 권한 확인 및 요청
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          return false; // 권한 거부 시 종료
        }
      }

      // 2. 위치 가져오기
      final position = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.high),
      );

      // 3. UseCase 호출해서 지역명 얻기
      final results = await getLocationUseCase(
        lat: position.latitude,
        lng: position.longitude,
      );

      final fullRegion = results.isNotEmpty ? results.first : null;
      String? region;
      if (fullRegion != null) {
        final parts = fullRegion.split(' ');
        region = parts.length >= 2 ? '${parts[0]} ${parts[1]}' : fullRegion;
      }

      // 4. 상태 업데이트
      state = Location(
        x: position.longitude,
        y: position.latitude,
        region: region,
      );

      return region != null;
    } catch (e) {
      return false;
    }
  }
}

// provider 선언
final locationProvider = NotifierProvider<LocationViewmodel, Location>(
  () => LocationViewmodel(),
);
