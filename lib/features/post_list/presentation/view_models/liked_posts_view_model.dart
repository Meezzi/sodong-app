import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 좋아요 상태 관리 클래스
///
/// 게시물 인덱스 기반 좋아요 상태 저장 및 관리
class LikedPostsViewModel extends StateNotifier<Map<int, bool>> {
  LikedPostsViewModel() : super({});

  /// 특정 게시물의 좋아요 상태 토글
  ///
  /// [index]: 대상 게시물 인덱스
  void toggleLike(int index) {
    var currentState = Map<int, bool>.from(state);
    currentState[index] = !(currentState[index] ?? false);
    state = currentState;
  }

  /// 좋아요 상태 확인 메서드
  ///
  /// [index]: 확인할 게시물 인덱스
  /// Returns: 좋아요 여부 (기본값 false)
  bool isLiked(int index) {
    return state[index] ?? false;
  }
}

/// 좋아요 상태 관리 프로바이더
final likedPostsProvider =
    StateNotifierProvider<LikedPostsViewModel, Map<int, bool>>((ref) {
  return LikedPostsViewModel();
});
