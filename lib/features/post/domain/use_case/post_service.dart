import 'package:sodong_app/features/post/domain/entities/region.dart';
import 'package:sodong_app/features/post_list/domain/models/town_life_post.dart';
import 'package:sodong_app/features/post_list/domain/repositories/post_repository.dart';

/// 게시물 관련 비즈니스 로직을 담당하는 서비스
class PostService {
  PostService(this._repository);

  final PostRepository _repository;

  /// 초기 게시물 조회 UseCase
  Future<List<TownLifePost>> getInitialPosts() async {
    return await _repository.fetchInitialPosts();
  }

  /// 추가 게시물 조회 UseCase
  Future<List<TownLifePost>> getMorePosts() async {
    return await _repository.fetchMorePosts();
  }

  /// 현재 지역 특정 카테고리 게시물 조회 UseCase
  Future<List<TownLifePost>> getCurrentRegionCategoryPosts(
      String categoryId) async {
    return await _repository.fetchCurrentRegionCategoryPosts(categoryId);
  }

  /// 지역 설정 UseCase
  void setRegion(Region region) {
    _repository.setRegion(region);
  }

  /// 하위 지역 설정 UseCase
  void setSubRegion(String subRegion) {
    _repository.setSubRegion(subRegion);
  }

  /// 카테고리 설정 UseCase
  void setCategory(String category) {
    _repository.setCategory(category);
  }

  /// 추가 게시물 존재 여부 확인
  bool get hasMorePosts => _repository.hasMorePosts;
}
