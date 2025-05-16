import 'package:sodong_app/features/post_list/domain/models/category.dart';
import 'package:sodong_app/features/post_list/domain/models/region.dart';

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

// 더미 데이터
List<TownLifePost> generateDummyPosts(int count, {int startIndex = 0}) {
  final categories = [
    '우리동네질문',
    '동네소식',
    '해주세요',
    '일상',
    '동네맛집',
  ];

  final contents = [
    '이사온지 얼마 안 됐는데, 이 동네 맛집 어디 있을까요? 특히 분위기 좋은 카페나 맛있는 식당 추천 부탁드립니다. 친구들이 놀러 올 때 데려가고 싶어요.',
    '내일 ○○공원에서 벼룩시장 열립니다. 많은 참여 부탁드립니다. 아이들 용품, 의류, 생활용품 등 다양한 물건들이 저렴하게 판매될 예정입니다.',
    '전기자전거가 갑자기 고장났는데, 동네에서 수리 가능하신 분 있을까요? 모터 부분에 문제가 있는 것 같아요. 사진도 첨부합니다.',
    '매일 아침 우리 집 앞에 오는 고양이예요. 이제는 먹이를 주면 도망가지 않고 옆에서 먹네요. 귀엽지 않나요? 이름을 뭐라고 지을까 고민중입니다.',
    '어제 새로 오픈한 ○○베이커리 가봤어요. 크로와상이 정말 맛있어요! 오픈 세일 중이라 가격도 저렴하고 사장님도 친절하세요. 동네 주민이라고 하면 10% 할인도 해주신다고 하니 참고하세요.',
  ];

  final titles = [
    '이 동네 맛집 추천해주세요',
    '내일 ○○공원에서 벼룩시장 열립니다',
    '전기자전거 수리 가능하신 분 계신가요?',
    '동네 고양이 근황',
    '새로 생긴 빵집 강추합니다',
  ];

  final timeAgos = [
    '10분 전',
    '1시간 전',
    '3시간 전',
    '5시간 전',
    '7시간 전',
  ];

  final imageUrls = [
    'https://images.unsplash.com/photo-1506706435692-290e0c5b4505',
    'https://images.unsplash.com/photo-1485965120184-e220f721d03e',
    'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba',
    'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    'https://images.unsplash.com/photo-1512621776951-a57141f2eefd',
  ];

  final result = <TownLifePost>[];

  for (int i = 0; i < count; i++) {
    final regionIndex = (startIndex + i) % 3;
    final region = regionList[regionIndex];
    final subRegionIndex = (startIndex + i) % region.subRegions.length;

    result.add(TownLifePost(
      category: categories[(startIndex + i) % categories.length],
      title: titles[(startIndex + i) % titles.length],
      content: contents[(startIndex + i) % contents.length],
      location: '${region.name} ${region.subRegions[subRegionIndex]}',
      regionId: region.id,
      subRegion: region.subRegions[subRegionIndex],
      timeAgo: timeAgos[(startIndex + i) % timeAgos.length],
      commentCount: (startIndex + i) % 40,
      likeCount: (startIndex + i) % 50,
      imageUrl: (startIndex + i) % 3 == 0
          ? imageUrls[(startIndex + i) % imageUrls.length]
          : null,
    ));
  }

  return result;
}

final List<TownLifePost> dummyTownLifePosts = generateDummyPosts(20);
