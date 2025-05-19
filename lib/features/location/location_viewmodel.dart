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
    // 만약 권한이 없다면 아래에서 권한을 요청
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // 사용자에게 권한 허용을 요청하여 시스템 팝업이 뜨고 사용자가 '허용' 또는 '거부'를 선택할 수 있게함
      permission = await Geolocator.requestPermission();
      // 위치권한을 거부하면 해당 텍스트 출력하고 진행 중단, 하지 않으면 계속 진행
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        print("위치 권한이 거부되었습니다.");
        return;
      }
    }
    // 2. gps가져와서 로케이션 세팅

    // 3. 위도 경도로 한국의 지역명 가져오기
    // 4. 로케이션 뷰모델에 한국의 지역명 저장하기
  }
}
