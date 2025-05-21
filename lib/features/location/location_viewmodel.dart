import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sodong_app/features/auth/data/repository/vworld_Location_repositiry.dart';
import 'package:sodong_app/features/auth/data/repository/vworld_location_repository_provider.dart';
import 'package:sodong_app/features/location/location_model.dart';

class Location {
  Location({required this.x, required this.y, this.region});
  final double x;
  final double y;
  final LocationModel? region;
}

class LocationViewmodel extends Notifier<Location> {
  late final VWorldLocationRepository _repository =
      ref.read(vworldRepositoryProvider);

  @override
  Location build() {
    // 초기의 기본 위치값 설정(초기 위치 일단 null로 지정)
    return Location(x: 129.0823133, y: 35.2202216, region: null);
  }

  Future<void> getLocation() async {
    // 1. 위치 권한 허용하기
    LocationPermission permission = await Geolocator.checkPermission();
    // 만약 권한이 없다면 아래에서 권한을 요청
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // 사용자에게 권한 허용을 요청하여 시스템 팝업이 뜨고 사용자가 '허용' 또는 '거부'를 선택할 수 있게함
      permission = await Geolocator.requestPermission();
      // 위치권한을 거부하면 해당 텍스트 출력하고 진행 중단, 하지 않으면 계속 진행
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }
    // 2. gps가져와서 로케이션 세팅
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
    // position 객체에서 위도를 추출
    double latitude = position.latitude;
    // position 객체에서 경도를 추출
    double longitude = position.longitude;

    // 3. 위도 경도로 한국의 지역명 가져오기
    final results = await _repository.findByLatLng(
      lat: latitude,
      lng: longitude,
    );
    LocationModel? regionModel;

    if (results.isNotEmpty) {
      final displayName = results.first; // ex: "서울특별시 강남구"
      final codeName =
          displayName.toLowerCase().replaceAll(RegExp(r'[\s]'), '_');
      regionModel = LocationModel(codeName: codeName, displayName: displayName);
    }
    // final fullRegion = results.isNotEmpty ? results.first : null;
    // String? region;
    // if (fullRegion != null) {
    //   final parts = fullRegion.split(' ');
    //   if (parts.length >= 2) {
    //     region = '${parts[0]} ${parts[1]}'; // 시 + 구단위 까지만 나오도록 설정
    //   } else {
    //     region = fullRegion; // 예외 처리
    //   }
    // }

    // 4. 로케이션 뷰모델에 한국의 지역명 저장하기
    state = Location(x: longitude, y: latitude, region: regionModel);
  }
}

// provider 선언
final locationProvider = NotifierProvider<LocationViewmodel, Location>(
  () => LocationViewmodel(),
);
