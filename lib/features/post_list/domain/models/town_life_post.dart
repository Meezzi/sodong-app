import 'package:sodong_app/features/post_list/domain/models/category.dart';
import 'package:sodong_app/features/post_list/domain/models/region.dart';

class TownLifePost {
  // 모든 이미지 URL 목록
  TownLifePost({
    required this.postId,
    required this.category,
    required this.title,
    required this.content,
    required this.location,
    required this.regionId,
    required this.subRegion,
    required this.timeAgo,
    required this.commentCount,
    required this.likeCount,
    this.imageUrl,
    this.imageUrls = const [],
    required this.userId,
  });

  final String postId; // 게시글 ID
  final String category; // 카테고리 (카테고리 ID: question, news, help 등)
  final String title; // 게시글 제목
  final String content; // 게시글 내용
  final String location; // 위치 정보 (예: 서울시 강남구)
  final String regionId; // 지역 ID (예: seoul, gyeonggi 등)
  final String subRegion; // 하위 지역 (예: 강남구, 마포구 등)
  final String timeAgo; // 게시 시간 (예: 10분 전, 1시간 전 등)
  final int commentCount; // 댓글 수
  final int likeCount; // 좋아요 수
  final String? imageUrl; // 대표 이미지 URL (null일 경우 이미지 없음)
  final List<String> imageUrls; // 모든 이미지 URL 목록
  final String userId; // 게시글 작성자 ID

  // 카테고리 문자열을 enum으로 변환 (ID 기반 매핑)
  TownLifeCategory get categoryEnum {
    // 직접 ID로 매칭 (FirestorePost에서 category 필드가 ID 형태로 저장되므로)
    return TownLifeCategory.fromId(category);
  }

  // 카테고리 표시 텍스트 반환
  String get categoryText {
    return categoryEnum.text;
  }
}

// 더미 데이터 생성 함수 (개발 및 테스트용)
// 최소한의 데이터만 생성하여 실제 데이터가 없을 때 UI 테스트용으로 사용
List<TownLifePost> generateDummyPosts(int count, {int startIndex = 0}) {
  final categories = [
    TownLifeCategory.question.id,
    TownLifeCategory.news.id,
    TownLifeCategory.help.id,
    TownLifeCategory.daily.id,
    TownLifeCategory.food.id,
  ];

  final result = <TownLifePost>[];

  for (int i = 0; i < count; i++) {
    final regionIndex = (startIndex + i) % regionList.length;
    final region = regionList[regionIndex];
    final subRegionIndex = (startIndex + i) % region.subRegions.length;
    final categoryIndex = (startIndex + i) % categories.length;

    result.add(TownLifePost(
      postId: 'post_${startIndex + i}',
      category: categories[categoryIndex],
      title: '샘플 게시물 ${startIndex + i}',
      content: '샘플 내용 ${startIndex + i}',
      location: '${region.name} ${region.subRegions[subRegionIndex]}',
      regionId: region.id,
      subRegion: region.subRegions[subRegionIndex],
      timeAgo: '${(startIndex + i) % 24}시간 전',
      commentCount: (startIndex + i) % 10,
      likeCount: (startIndex + i) % 5,
      imageUrl: null,
      imageUrls: const [],
      userId: 'user_${startIndex + i}',
    ));
  }

  return result;
}
