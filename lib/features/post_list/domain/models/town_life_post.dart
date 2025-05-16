class TownLifePost {
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
}
