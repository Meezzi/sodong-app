import 'package:sodong_app/features/post_detail/data/dtos/post_detail_dto.dart';

abstract interface class PostDetailDataSource {
  /// Post 상세 보기
  Stream<PostDetailModel> getPostDetail(
    String location,
    String category,
    String postId,
  );
}
