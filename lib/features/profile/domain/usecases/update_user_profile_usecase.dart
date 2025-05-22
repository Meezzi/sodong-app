import 'package:sodong_app/features/profile/domain/entities/profile_entity.dart';
import 'package:sodong_app/features/profile/domain/repositories/profile_repository.dart';

/// 사용자 프로필 업데이트 유스케이스
class UpdateUserProfileUsecase {
  UpdateUserProfileUsecase(this.repository);
  final ProfileRepository repository;

  Future<void> call(String userId, ProfileEntity user) {
    return repository.updateUser(userId, user);
  }
}
