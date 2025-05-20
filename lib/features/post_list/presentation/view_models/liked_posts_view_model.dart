import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 게시물 좋아요 상태 관리 클래스
///
/// 각 게시물의 좋아요 상태를 관리하는 클래스입니다.
class LikedPostsViewModel extends StateNotifier<Map<int, bool>> {
  LikedPostsViewModel() : super({});

  /// 게시물 좋아요 상태 토글
  ///
  /// [postId]: 좋아요 상태를 토글할 게시물 ID
  void toggleLike(int postId) {
    final isLiked = state[postId] ?? false;
    state = {...state, postId: !isLiked};
  }

  /// 게시물 좋아요 상태 설정
  ///
  /// [postId]: 좋아요 상태를 설정할 게시물 ID
  /// [isLiked]: 설정할 좋아요 상태 (true: 좋아요, false: 좋아요 해제)
  void setLike(int postId, bool isLiked) {
    state = {...state, postId: isLiked};
  }

  /// 게시물 좋아요 상태 확인
  ///
  /// [postId]: 좋아요 상태를 확인할 게시물 ID
  /// Returns: 좋아요 상태 (좋아요: true, 좋아요 안함: false)
  bool isLiked(int postId) {
    return state[postId] ?? false;
  }
}
