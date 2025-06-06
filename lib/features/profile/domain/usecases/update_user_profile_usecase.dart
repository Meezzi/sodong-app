import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/profile/data/providers/profile_provider.dart';
import 'package:sodong_app/features/profile/domain/entities/profile_entity.dart';
import 'package:sodong_app/features/profile/domain/repositories/profile_repository.dart';

/// 사용자 프로필 업데이트 유스케이스
class UpdateUserProfileUsecase {
  UpdateUserProfileUsecase(this.repository);
  final ProfileRepository repository;

  Future<void> call(String userId, Profile user) {
    return repository.updateUser(userId, user);
  }
}

final updateUserProfileUsecaseProvider = Provider<UpdateUserProfileUsecase>(
  (ref) {
    final repository = ref.read(profileRepositoryProvider);
    return UpdateUserProfileUsecase(repository);
  },
);
