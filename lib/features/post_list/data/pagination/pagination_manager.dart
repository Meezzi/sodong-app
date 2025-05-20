import 'package:sodong_app/features/post_list/data/repository/post_repository.dart';
import 'package:sodong_app/features/post_list/domain/models/region.dart';
import 'package:sodong_app/features/post_list/domain/models/town_life_post.dart';

/// 게시물 페이지네이션 관리 클래스
///
/// 무한 스크롤 구현에 필요한 페이지네이션 로직을 담당합니다.
class PaginationManager {
  final PostRepository _postRepository;

  // 페이지네이션 상태 변수
  bool _hasMorePosts = true;

  // 현재 설정된 필터링 상태
  Region? _currentRegion;
  String _currentSubRegion = '';
  String _currentCategory = '';

  PaginationManager(this._postRepository);

  /// 더 불러올 게시물이 있는지 여부
  bool get hasMorePosts => _hasMorePosts;

  /// 지역 설정
  void setRegion(Region region) {
    if (_currentRegion?.id != region.id) {
      _currentRegion = region;
      _resetPagination();

      // 지역이 설정되면 해당 지역의 첫 번째 하위 지역도 함께 설정
      if (region.subRegions.isNotEmpty) {
        _currentSubRegion = region.subRegions.first;
      } else {
        _currentSubRegion = '';
      }

      // 저장소에 지역 정보 설정
      _postRepository.setRegion(region);
    }
  }

  /// 하위 지역 설정
  void setSubRegion(String subRegion) {
    if (_currentSubRegion != subRegion) {
      _currentSubRegion = subRegion;
      _resetPagination();

      // 저장소에 하위 지역 정보 설정
      _postRepository.setSubRegion(subRegion);
    }
  }

  /// 카테고리 설정
  void setCategory(String category) {
    if (_currentCategory != category) {
      _currentCategory = category;
      _resetPagination();

      // 저장소에 카테고리 정보 설정
      _postRepository.setCategory(category);
    }
  }

  /// 페이지네이션 상태 초기화
  void _resetPagination() {
    _hasMorePosts = true;
  }

  /// 초기 게시물 로드
  ///
  /// 첫 페이지의 게시물을 로드합니다.
  /// [return]: 로드된 게시물 목록
  Future<List<TownLifePost>> loadInitialPosts() async {
    try {
      final posts = await _postRepository.fetchInitialPosts();

      // 다음 페이지 존재 여부 확인
      _hasMorePosts = posts.isNotEmpty;

      return posts;
    } catch (e) {
      rethrow;
    }
  }

  /// 추가 게시물 로드
  ///
  /// 다음 페이지의 게시물을 로드합니다.
  /// [return]: 로드된 게시물 목록
  Future<List<TownLifePost>> loadMorePosts() async {
    if (!_hasMorePosts) return [];

    try {
      final posts = await _postRepository.fetchMorePosts();

      // 다음 페이지 존재 여부 확인
      _hasMorePosts = posts.isNotEmpty;

      return posts;
    } catch (e) {
      rethrow;
    }
  }

  /// 현재 선택된 지역과 카테고리의 게시물 로드
  ///
  /// [categoryId]: 로드할 카테고리 ID
  /// [return]: 로드된 게시물 목록
  Future<List<TownLifePost>> loadCurrentRegionCategoryPosts(
      String categoryId) async {
    try {
      // 원래 카테고리 저장
      final originalCategory = _currentCategory;

      // 타겟 카테고리로 변경
      _postRepository.setCategory(categoryId);

      // 해당 카테고리의 게시물 로드
      final posts = await _postRepository.fetchInitialPosts();

      // 원래 카테고리로 복원
      _postRepository.setCategory(originalCategory);

      return posts;
    } catch (e) {
      rethrow;
    }
  }
}
