import 'package:sodong_app/features/post_list/domain/models/category.dart';

class TownLifePost {
  TownLifePost({
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
  });
  final String category; // 카테고리 (우리동네질문, 동네소식 등)
  final String title; // 게시글 제목
  final String content; // 게시글 내용
  final String location; // 위치 정보 (예: 서울시 강남구)
  final String regionId; // 지역 ID (예: seoul, gyeonggi 등)
  final String subRegion; // 하위 지역 (예: 강남구, 마포구 등)
  final String timeAgo; // 게시 시간 (예: 10분 전, 1시간 전 등)
  final int commentCount; // 댓글 수
  final int likeCount; // 좋아요 수
  final String? imageUrl; // 이미지 URL (null일 경우 이미지 없음)

  // 카테고리 문자열을 enum으로 변환
  TownLifeCategory get categoryEnum {
    switch (category) {
      case '우리동네질문':
        return TownLifeCategory.question;
      case '동네소식':
        return TownLifeCategory.news;
      case '해주세요':
        return TownLifeCategory.help;
      case '일상':
        return TownLifeCategory.daily;
      case '동네맛집':
        return TownLifeCategory.food;
      case '분실/실종':
        return TownLifeCategory.lost;
      case '동네모임':
        return TownLifeCategory.meeting;
      case '같이해요':
        return TownLifeCategory.together;
      default:
        return TownLifeCategory.all;
    }
  }
}
