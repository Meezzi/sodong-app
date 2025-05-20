class PostDetail {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final String location;

  PostDetail({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.location,
  });

  factory PostDetail.fromDocument(String id, Map<String, dynamic> json) {
    return PostDetail(
      id: id,
      title: json['title'] ?? '제목 없음',
      content: json['content'] ?? '내용 없음',
      imageUrl: json['imageUrl'] ?? '',
      location: json['location'] ?? '위치 없음',
    );
  }
}
