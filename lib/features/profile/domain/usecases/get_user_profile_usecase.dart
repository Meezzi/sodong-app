import 'package:sodong_app/features/profile/domain/entities/profile_entity.dart';
import 'package:sodong_app/features/profile/domain/repositories/profile_repository.dart';

/// 사용자 프로필 조회 유스케이스
class GetUserProfileUsecase {
  GetUserProfileUsecase(this.repository);
  final ProfileRepository repository;

  Future<Profile> call(String userId) {
    return repository.getUser(userId);
  }
}
