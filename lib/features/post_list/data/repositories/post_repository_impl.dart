import 'package:sodong_app/features/post_list/data/datasources/post_cache_data_source.dart';
import 'package:sodong_app/features/post_list/data/datasources/post_remote_data_source.dart';
import 'package:sodong_app/features/post_list/domain/models/region.dart';
import 'package:sodong_app/features/post_list/domain/models/town_life_post.dart';
import 'package:sodong_app/features/post_list/domain/repositories/post_repository.dart';

/// PostRepository 인터페이스 구현체
class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource _remoteDataSource;
  final PostCacheDataSource _cacheDataSource;

  // 상태 변수들
  bool _hasMore = true;
  String _currentRegionId = 'seoul';
  String _currentSubRegion = '';
  String _currentCategory = 'question';

  PostRepositoryImpl({
    required PostRemoteDataSource remoteDataSource,
    required PostCacheDataSource cacheDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _cacheDataSource = cacheDataSource {
    // 초기화 시 기본 선택된 지역에 대한 하위 지역 설정
    if (_currentSubRegion.isEmpty && regionList.isNotEmpty) {
      // regionList에서 현재 선택된 지역 ID에 맞는 지역 찾기
      final region = regionList.firstWhere(
        (r) => r.id == _currentRegionId,
        orElse: () => regionList.first,
      );

      // 해당 지역의 첫 번째 하위 지역 선택
      if (region.subRegions.isNotEmpty) {
        _currentSubRegion = region.subRegions.first;
      }
    }
  }

  @override
  Future<List<TownLifePost>> fetchInitialPosts() async {
    try {
      final posts = await _remoteDataSource.fetchInitialPosts(
        regionId: _currentRegionId,
        subRegion: _currentSubRegion,
        category: _currentCategory,
      );

      // 게시물이 비어있거나 예상 페이지 크기보다 적은 경우 더 이상 불러올 게시물이 없음
      _hasMore = posts.length >= PostRemoteDataSource.pageSize;

      // 캐시 업데이트
      _cacheDataSource.updateCategoryCache(_currentCategory, posts);

      return posts;
    } catch (e) {
      // 에러 발생 시 캐시된 데이터 반환 시도
      final cachedPosts = _cacheDataSource.getCategoryPosts(_currentCategory);
      if (cachedPosts.isNotEmpty) {
        _hasMore = false; // 에러 발생 시 더 이상 불러올 게시물이 없다고 설정
        return cachedPosts;
      }

      // 캐시도 없으면 빈 리스트 반환
      _hasMore = false;
      return [];
    }
  }

  @override
  Future<List<TownLifePost>> fetchMorePosts() async {
    if (!_hasMore) return [];

    try {
      final posts = await _remoteDataSource.fetchMorePosts(
        regionId: _currentRegionId,
        subRegion: _currentSubRegion,
        category: _currentCategory,
      );

      // 게시물이 비어있거나 예상 페이지 크기보다 적은 경우 더 이상 불러올 게시물이 없음
      _hasMore = posts.length >= PostRemoteDataSource.pageSize;

      // 캐시에 새 게시물 추가
      final currentCache = _cacheDataSource.getCategoryPosts(_currentCategory);
      _cacheDataSource
          .updateCategoryCache(_currentCategory, [...currentCache, ...posts]);

      return posts;
    } catch (e) {
      // 에러 발생 시 빈 리스트 반환
      _hasMore = false;
      return [];
    }
  }

  @override
  Future<List<TownLifePost>> fetchCurrentRegionCategoryPosts(
      String categoryId) async {
    // 원래 카테고리와 hasMore 상태 저장
    final originalCategory = _currentCategory;
    final originalHasMore = _hasMore;

    // 요청된 카테고리로 변경
    _currentCategory = categoryId;

    try {
      // 해당 카테고리의 게시물 로드
      final posts = await fetchInitialPosts();

      // 원래 카테고리로 복원
      _currentCategory = originalCategory;

      // 원래 카테고리의 hasMore 상태 복원
      _hasMore = originalHasMore;

      return posts;
    } catch (e) {
      // 원래 카테고리와 hasMore 상태로 복원
      _currentCategory = originalCategory;
      _hasMore = originalHasMore;
      return [];
    }
  }

  @override
  void setRegion(Region region) {
    if (_currentRegionId != region.id) {
      _currentRegionId = region.id;
      _currentSubRegion = region.subRegions.first;

      // 캐시 관리
      _cacheDataSource.clearAllCache();

      // 원격 데이터 소스에 업데이트
      _remoteDataSource.resetPagination();

      // 상태 초기화
      _hasMore = true;
    }
  }

  @override
  void setSubRegion(String subRegion) {
    if (_currentSubRegion != subRegion) {
      _currentSubRegion = subRegion;

      // 캐시 관리
      _cacheDataSource.clearAllCache();

      // 원격 데이터 소스에 업데이트
      _remoteDataSource.resetPagination();

      // 상태 초기화
      _hasMore = true;
    }
  }

  @override
  void setCategory(String category) {
    if (_currentCategory != category) {
      _currentCategory = category;

      // 원격 데이터 소스에 업데이트
      _remoteDataSource.resetPagination();

      // 상태 초기화
      _hasMore = true;
    }
  }

  @override
  bool get hasMorePosts => _hasMore;
}
