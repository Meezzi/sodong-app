import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sodong_app/features/post/data/data_source/post_detail_data_source.dart';
import 'package:sodong_app/features/post/data/dto/post_dto.dart';
import 'package:sodong_app/features/post_list/domain/models/category.dart';

class RemotePostDetailDataSource implements PostDetailDataSource {
  @override
  Stream<PostDto> getPostDetail(
      String location, TownLifeCategory category, String postId) {
    final postDocRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(location.trim())
        .collection(category.id)
        .doc(postId);

    return postDocRef.snapshots().asyncMap((docSnapshot) async {
      if (!docSnapshot.exists) {
        return PostDto(
          postId: postId,
          category: category,
          title: '게시물을 찾을 수 없습니다',
          content: '요청하신 게시물이 존재하지 않거나 삭제되었습니다.',
          region: location,
          createdAt: DateTime.now(),
          isAnonymous: true,
          userId: '',
          nickname: '익명',
          commentCount: 0,
          profileImageUrl: 'https://yourdomain.com/default_anonymous.png',
          imageUrls: [],
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

      return PostDto(
        postId: postId,
        category: category,
        title: data['title'] ?? '',
        content: data['content'] ?? '',
        region: data['region'] ?? '',
        createdAt: (data['createdAt'] as Timestamp).toDate(),
        isAnonymous: isAnonymous,
        userId: userId,
        nickname: nickname,
        commentCount: data['commentCount'] ?? 0,
        imageUrls: List<String>.from(data['imageUrls'] ?? []),
        profileImageUrl: profileImageUrl,
      );
    });
  }
}
