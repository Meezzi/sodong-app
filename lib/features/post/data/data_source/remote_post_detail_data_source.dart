import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sodong_app/features/post/data/data_source/post_detail_data_source.dart';
import 'package:sodong_app/features/post_detail/data/dtos/post_detail_dto.dart';

class RemotePostDetailDataSource implements PostDetailDataSource {
  
  @override
  Stream<PostDetailModel> getPostDetail(
      String location, String category, String postId) {
    final postDocRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(location.trim())
        .collection(category)
        .doc(postId);

    return postDocRef.snapshots().asyncMap((docSnapshot) async {
      if (!docSnapshot.exists) {
        return PostDetailModel(
          postId: postId,
          title: '게시물을 찾을 수 없습니다',
          content: '요청하신 게시물이 존재하지 않거나 삭제되었습니다.',
          imageUrl: [],
          location: location,
          category: category,
          createdAt: DateTime.now(),
          userId: '',
          nickname: '익명',
          profileImageUrl: 'https://yourdomain.com/default_anonymous.png',
          isAnonymous: true,
        );
      }

      final data = docSnapshot.data()!;
      final userId = data['userId'] ?? '';
      final isAnonymous = data['isAnonymous'] ?? false;

      String nickname = '익명';
      String profileImageUrl = 'https://yourdomain.com/default_anonymous.png';

      if (!isAnonymous && userId.isNotEmpty) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        nickname = userDoc.data()?['nickname'] ?? '알 수 없음';
        profileImageUrl = userDoc.data()?['profileImageUrl'] ??
            'https://yourdomain.com/default_profile.png';
      }

      return PostDetailModel.fromJson(
        data,
        nickname: nickname,
        profileImageUrl: profileImageUrl,
      );
    });
  }
}
