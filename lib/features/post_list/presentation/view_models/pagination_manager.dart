import 'package:sodong_app/features/post/domain/entities/region.dart';
import 'package:sodong_app/features/post/domain/use_case/post_service.dart';
import 'package:sodong_app/features/post_list/domain/models/town_life_post.dart';

/// 페이지네이션 관리 클래스
///
/// 무한 스크롤 및 게시물 추가 로드 기능 담당
class PaginationManager {
  PaginationManager(this._postService);

  final PostService _postService;

  /// 추가 게시물 로드 메서드
  ///
  /// Returns: 다음 페이지 게시물 목록
  Future<List<TownLifePost>> loadMorePosts() async {
    return await _postService.getMorePosts();
  }

  /// 초기 게시물 로드 메서드
  ///
  /// Returns: 첫 페이지 게시물 목록
  Future<List<TownLifePost>> loadInitialPosts() async {
    return await _postService.getInitialPosts();
  }

  /// 특정 카테고리 게시물 로드 메서드
  ///
  /// [categoryId]: 로드할 카테고리 ID
  /// Returns: 해당 카테고리 게시물 목록
  Future<List<TownLifePost>> loadCategoryPosts(String categoryId) async {
    _postService.setCategory(categoryId);
    return await _postService.getInitialPosts();
  }

  /// 현재 지역 특정 카테고리 게시물 로드 메서드
  ///
  /// [categoryId]: 로드할 카테고리 ID
  /// Returns: 현재 지역 해당 카테고리 게시물 목록
  Future<List<TownLifePost>> loadCurrentRegionCategoryPosts(
      String categoryId) async {
    return await _postService.getCurrentRegionCategoryPosts(categoryId);
  }

  /// 다음 페이지 존재 여부 확인
  ///
  /// Returns: 다음 페이지 존재 여부
  bool get hasMorePosts => _postService.hasMorePosts;

  /// 지역 설정 메서드
  void setRegion(Region region) {
    _postService.setRegion(region);
  }

  /// 하위 지역 설정 메서드
  ///
  /// [subRegion]: 설정할 하위 지역
  void setSubRegion(String subRegion) {
    _postService.setSubRegion(subRegion);
  }

  /// 카테고리 설정 메서드
  ///
  /// [category]: 설정할 카테고리 ID
  void setCategory(String category) {
    _postService.setCategory(category);
  }
}
