import 'package:sodong_app/features/profile/domain/entities/profile_entity.dart';
import 'package:sodong_app/features/profile/domain/repositories/profile_repository.dart';

class GetUserProfileUsecase {
  GetUserProfileUsecase(this.repository);
  final ProfileRepository repository;

  Future<ProfileEntity> call(String userId) {
    return repository.getUser(userId);
  }
}
