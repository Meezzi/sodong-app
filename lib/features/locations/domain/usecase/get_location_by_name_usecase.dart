import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:sodong_app/features/locations/domain/repository/location_repository.dart';

class GetLocationByNameUsecase {
  GetLocationByNameUsecase({required this.repository});
  final LocationRepository repository;
  Future<List<String>> findByName(String query) {
    return repository.findByName(query);
  }

  Future<List<String>> execute() async {
    return await repository.call();
  }
}
