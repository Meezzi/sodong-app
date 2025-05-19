import 'package:flutter_riverpod/flutter_riverpod.dart';

class Location {
  double x;
  double y;
  Location({required this.x, required this.y});
}

class LocationViewmodel extends Notifier<Location> {
  @override
  build() {
    return Location(x: 129.0823133, y: 35.2202216);
  }

  void getLocation() {
    // 1. 위치 권한 허용하기
    // 2. gps가져와서 로케이션 세팅
    // 3. 위도 경도로 한국의 지역명 가져오기
    // 4. 로케이션 뷰모델에 한국의 지역명 저장하기
  }
}
