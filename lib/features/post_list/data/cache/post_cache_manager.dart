import '../../domain/models/town_life_post.dart';

/// TownLife 게시물 캐시 관리 클래스
///
/// 카테고리별로 게시물을 캐싱하고 관리합니다.
class PostCacheManager {
  // 카테고리별 캐시 저장소
  final Map<String, List<TownLifePost>> _categoryCache = {};

  // 전체 카테고리 통합 캐시
  List<TownLifePost> _allCategoryCache = [];

  /// 특정 카테고리의 캐시 업데이트
  ///
  /// [categoryId]: 카테고리 ID
  /// [posts]: 캐싱할 게시물 목록
  void updateCategoryCache(String categoryId, List<TownLifePost> posts) {
    _categoryCache[categoryId] = List.from(posts);
  }

  /// 전체 카테고리 통합 캐시 업데이트
  ///
  /// [posts]: 캐싱할 모든 게시물 목록
  void updateAllCategoryCache(List<TownLifePost> posts) {
    _allCategoryCache = List.from(posts);
  }

  /// 특정 카테고리의 캐시된 게시물 가져오기
  ///
  /// [categoryId]: 카테고리 ID
  /// [return]: 캐시된 게시물 목록
  List<TownLifePost> getCategoryPosts(String categoryId) {
    return _categoryCache[categoryId] ?? [];
  }

  /// 전체 카테고리 통합 캐시에서 게시물 가져오기
  ///
  /// [return]: 모든 카테고리의 통합 게시물 목록
  List<TownLifePost> getAllCategoryPosts() {
    return List.from(_allCategoryCache);
  }

  /// 특정 카테고리의 캐시 초기화
  ///
  /// [categoryId]: 초기화할 카테고리 ID
  void clearCategoryCache(String categoryId) {
    _categoryCache[categoryId]?.clear();
  }

  /// 모든 카테고리 캐시 초기화
  void clearAllCache() {
    _categoryCache.clear();
    _allCategoryCache.clear();
  }

  /// 게시물을 카테고리별로 정렬
  ///
  /// 동일 카테고리의 게시물은 날짜순으로 정렬됨
  /// [posts]: 정렬할 게시물 목록
  /// [return]: 카테고리별로 정렬된 게시물 목록
  List<TownLifePost> sortPostsByCategory(List<TownLifePost> posts) {
    if (posts.isEmpty) return [];

    // 카테고리별로 게시물 그룹화
    final Map<String, List<TownLifePost>> categorizedPosts = {};

    for (var post in posts) {
      if (!categorizedPosts.containsKey(post.category)) {
        categorizedPosts[post.category] = [];
      }
      categorizedPosts[post.category]!.add(post);
    }

    // 각 카테고리 내에서 게시물을 날짜순으로 정렬
    // timeAgo 문자열을 직접 비교하는 것은 정확하지 않으므로
    // 댓글 수, 좋아요 수 등으로 인기도 정렬 로직 대체
    for (var category in categorizedPosts.keys) {
      categorizedPosts[category]!.sort((a, b) {
        // 1. 댓글 수 비교 (댓글이 많은 게시물이 더 앞에 표시)
        final commentDiff = b.commentCount - a.commentCount;
        if (commentDiff != 0) return commentDiff;

        // 2. 좋아요 수 비교
        final likeDiff = b.likeCount - a.likeCount;
        if (likeDiff != 0) return likeDiff;

        // 3. 시간 비교 (timeAgo 문자열 기반으로 대략적인 시간 비교)
        final aTime = _parseTimeAgo(a.timeAgo);
        final bTime = _parseTimeAgo(b.timeAgo);
        return bTime.compareTo(aTime); // 최신 게시물이 더 앞에 표시
      });
    }

    // 모든 카테고리의 최신 게시물을 번갈아가며 결합
    final List<TownLifePost> sortedPosts = [];
    bool hasMore = true;
    int index = 0;

    while (hasMore) {
      hasMore = false;

      for (var category in categorizedPosts.keys) {
        final categoryPosts = categorizedPosts[category]!;
        if (index < categoryPosts.length) {
          sortedPosts.add(categoryPosts[index]);
          hasMore = true;
        }
      }

      index++;
    }

    return sortedPosts;
  }

  // timeAgo 문자열을 분 단위로 변환하여 비교 가능하게 함
  int _parseTimeAgo(String timeAgo) {
    final parts = timeAgo.split(' ');
    if (parts.length < 2) return 0;

    try {
      final value = int.parse(parts[0]);
      final unit = parts[1];

      if (unit.contains('분')) return value;
      if (unit.contains('시간')) return value * 60;
      if (unit.contains('일')) return value * 60 * 24;
      if (unit.contains('달')) return value * 60 * 24 * 30;
      return 0;
    } catch (e) {
      return 0;
    }
  }
}
