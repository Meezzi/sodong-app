import 'package:sodong_app/features/profile/domain/entities/profile_entity.dart';
import 'package:sodong_app/features/profile/domain/repositories/profile_repository.dart';

class UpdateUserProfileUsecase {
  UpdateUserProfileUsecase(this.repository);
  final ProfileRepository repository;

  Future<void> call(String userId, ProfileEntity user) {
    return repository.updateUser(userId, user);
  }
}
