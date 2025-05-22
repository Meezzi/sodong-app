import 'package:sodong_app/features/profile/domain/entities/profile_entity.dart';

abstract interface class UserRepository {
  Future<ProfileEntity> getUser(String userId);
  Future<void> updateUser(String userId, ProfileEntity user);
}
