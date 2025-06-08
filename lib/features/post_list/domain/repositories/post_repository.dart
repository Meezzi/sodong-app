import 'package:sodong_app/features/post/domain/entities/region.dart';
import 'package:sodong_app/features/post_list/domain/models/town_life_post.dart';

/// 게시물 저장소 인터페이스
abstract interface class PostRepository {
  /// 초기 게시물 가져오기
  Future<List<TownLifePost>> fetchInitialPosts(String uid);

  /// 추가 게시물 가져오기 (페이지네이션)
  Future<List<TownLifePost>> fetchMorePosts(String uid);

  /// 현재 지역에 대한 특정 카테고리 게시물 가져오기
  Future<List<TownLifePost>> fetchCurrentRegionCategoryPosts(String categoryId, String uid);

  /// 지역 설정
  void setRegion(Region region);

  /// 하위 지역 설정
  void setSubRegion(String subRegion);

  /// 카테고리 설정
  void setCategory(String category);

  /// 추가 게시물 존재 여부
  bool get hasMorePosts;
}
