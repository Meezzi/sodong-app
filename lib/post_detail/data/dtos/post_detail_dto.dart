class PostDetail {
  final String title;
  final String content;
  final String location;
  final String imageUrl;

  PostDetail({
    required this.title,
    required this.content,
    required this.location,
    required this.imageUrl,
  });

  factory PostDetail.fromJson(Map<String, dynamic> json) {
    return PostDetail(
      title: json['title'] ?? '제목 없음',
      content: json['content'] ?? '내용 없음',
      location: json['location'] ?? '위치 없음',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
