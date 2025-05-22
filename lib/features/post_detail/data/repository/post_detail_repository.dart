import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sodong_app/features/post_detail/data/dtos/post_detail_dto.dart';

class PostDetailRepository {
  Stream<PostDetail> getPostStream(
      String location, String category, String postId) {
    // 모든 매개변수가 유효한지 확인
    if (location.isEmpty || category.isEmpty || postId.isEmpty) {
      throw ArgumentError('location, category, postId 모두 유효한 값이어야 합니다.');
    }

    // Firebase 경로는 '서울특별시 강남구' 같은 형식으로 되어 있을 수 있음
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(location)
        .collection(category)
        .doc(postId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) {
        print('문서가 존재하지 않음: posts/$location/$category/$postId');
        // 기본 값이 있는 객체 반환
        return PostDetail(
          postId: postId,
          title: '게시물을 찾을 수 없습니다',
          content: '요청하신 게시물이 존재하지 않거나 삭제되었습니다.',
          imageUrl: [],
          location: location,
          category: category,
          createdAt: DateTime.now(),
          userId: '',
        );
      }
      return PostDetail.fromJson(doc.data() ?? {});
    });
  }
}
