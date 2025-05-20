import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sodong_app/post_detail/data/dtos/post_detail_dto.dart';

class PostDetailRepository {
  Stream<PostDetail> getPostStream(String postId) {
    return FirebaseFirestore.instance
        .doc('posts/busan/news/$postId')
        .snapshots()
        .map((doc) => PostDetail.fromJson(doc.data() ?? {}));
  }
}
