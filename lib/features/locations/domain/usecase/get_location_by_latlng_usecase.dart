import 'package:sodong_app/features/locations/domain/repository/location_repository.dart';

class GetLocationByLatLngUseCase {
  GetLocationByLatLngUseCase({required this.repository});
  final LocationRepository repository;
// 레포지토리 구현체에서 요청
  Future<List<String>> call({
    required double lat,
    required double lng,
  }) {
    return repository.findByLatLng(lat: lat, lng: lng);
  }
}
// 프로바이더 만들기 뷰모델에서 프로바이더 콜 함수로 호출
