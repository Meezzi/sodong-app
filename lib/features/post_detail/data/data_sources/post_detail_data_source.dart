import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sodong_app/features/post_detail/data/dtos/post_detail_dto.dart';

class PostDetailDataSource {
  Stream<PostDetailModel> getPostDetail(
      String location, String category, String postId) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(location)
        .collection(category)
        .doc(postId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) {
        return PostDetailModel(
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
      return PostDetailModel.fromJson({
        ...doc.data()!,
        'postId': doc.id,
        'location': location,
        'category': category,
      });
    });
  }
}
