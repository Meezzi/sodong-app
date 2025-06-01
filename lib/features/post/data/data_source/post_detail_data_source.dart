import 'package:sodong_app/features/post/data/dto/post_dto.dart';

abstract interface class PostDetailDataSource {
  /// Post 상세 보기
  Stream<PostDto> getPostDetail(
    String location,
    String category,
    String postId,
  );
}
