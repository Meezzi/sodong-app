import 'package:sodong_app/features/profile/domain/entities/profile_entity.dart';

/// 사용자 데이터에 접근하기 위한 추상 레포지토리
abstract interface class ProfileRepository {
  Future<ProfileEntity> getUser(String userId);
  Future<void> updateUser(String userId, ProfileEntity user);
}
