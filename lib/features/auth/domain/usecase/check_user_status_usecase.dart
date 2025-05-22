import 'package:sodong_app/features/auth/domain/repositories/user_repository.dart';

enum UserStatus {
  notLoggedIn,
  agreementNotComplete,
  agreementComplete,
}

class CheckUserStatusUseCase {
  CheckUserStatusUseCase(this.repository);

  final UserRepository repository;

  Future<UserStatus> execute() async {
    final user = repository.getCurrentUser();
    if (user == null) return UserStatus.notLoggedIn;

    final isComplete = await repository.isAgreementComplete(user.uid);
    return isComplete == true
        ? UserStatus.agreementComplete
        : UserStatus.agreementNotComplete;
  }
}
