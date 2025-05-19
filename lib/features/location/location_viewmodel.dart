import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

class Location {
  double x;
  double y;
  String? region;
  Location({required this.x, required this.y, this.region});
}

class LocationViewmodel extends Notifier<Location> {
  @override
  Location build() {
    // 초기의 기본 위치값 설정(초기 위치 일단 null로 지정)
    return Location(x: 129.0823133, y: 35.2202216, region: null);
  }

  void getLocation() async {
    // 1. 위치 권한 허용하기
    LocationPermission permission = await Geolocator.checkPermission();

    // 2. gps가져와서 로케이션 세팅

    // 3. 위도 경도로 한국의 지역명 가져오기
    // 4. 로케이션 뷰모델에 한국의 지역명 저장하기
  }
}
