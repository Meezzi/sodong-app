import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sodong_app/features/post_detail/data/dtos/post_detail_dto.dart';

class PostDetailRepository {
  Stream<PostDetail> getPostStream(
      String location, String category, String postId) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(location)
        .collection(category)
        .doc(postId)
        .snapshots()
        .map((doc) => PostDetail.fromJson(doc.data() ?? {}));
  }
}
