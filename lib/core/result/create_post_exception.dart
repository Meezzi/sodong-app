sealed class CreatePostException implements Exception {
  const CreatePostException(this.message);
  final String message;
}

class NetworkFailure extends CreatePostException {
  const NetworkFailure() : super('인터넷 연결을 확인해주세요.');
}

class PermissionFailure extends CreatePostException {
  const PermissionFailure() : super('권한이 없습니다.');
}

class UnknownFailure extends CreatePostException {
  const UnknownFailure(super.message);
}
