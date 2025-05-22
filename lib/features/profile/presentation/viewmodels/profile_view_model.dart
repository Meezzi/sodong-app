import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/profile/data/providers/profile_provider.dart';
import 'package:sodong_app/features/profile/domain/entities/profile_entity.dart';
import 'package:sodong_app/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:sodong_app/features/profile/domain/usecases/update_user_profile_usecase.dart';

class ProfileViewModel extends StateNotifier<AsyncValue<Profile>> {
  ProfileViewModel({
    required this.getUserProfile,
    required this.updateUserProfile,
  }) : super(const AsyncValue.loading());
  final GetUserProfileUsecase getUserProfile;
  final UpdateUserProfileUsecase updateUserProfile;

  Future<void> fetchUser(String userId) async {
    state = const AsyncValue.loading();
    try {
      final user = await getUserProfile(userId);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateUser(String userId, Profile user) async {
    try {
      await updateUserProfile(userId, user);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final profileViewModelProvider =
    StateNotifierProvider<ProfileViewModel, AsyncValue<Profile>>((ref) {
  return ProfileViewModel(
    getUserProfile: ref.watch(getUserProfileUsecaseProvider),
    updateUserProfile: ref.watch(updateUserProfileUsecaseProvider),
  );
});

