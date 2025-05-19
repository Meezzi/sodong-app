import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sodong_app/features/post_list/domain/models/town_life_post.dart';

class FirestorePost {
  final String id;
  final String category;
  final String content;
  final int commentCount;
  final Timestamp createdAt;
  final List<String> imageUrls;
  final bool isAnonymous;
  final String nickname;
  final String title;
  final String userId;
  final RegionInfo region;

  FirestorePost({
    required this.id,
    required this.category,
    required this.content,
    required this.commentCount,
    required this.createdAt,
    required this.imageUrls,
    required this.isAnonymous,
    required this.nickname,
    required this.title,
    required this.userId,
    required this.region,
  });

  factory FirestorePost.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return FirestorePost(
      id: doc.id,
      category: data['category'] ?? '',
      content: data['content'] ?? '',
      commentCount: data['commentCount'] ?? 0,
      createdAt: data['createdAt'] as Timestamp,
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      isAnonymous: data['isAnonymous'] ?? false,
      nickname: data['nickname'] ?? '',
      title: data['title'] ?? '',
      userId: data['userId'] ?? '',
      region: RegionInfo.fromMap(data['region'] as Map<String, dynamic>),
    );
  }

  // Firestore Post를 앱에서 사용하는 TownLifePost로 변환
  TownLifePost toTownLifePost() {
    // 생성 시간으로부터 경과 시간 계산
    final now = DateTime.now();
    final postTime = createdAt.toDate();
    final difference = now.difference(postTime);

    String timeAgo;
    if (difference.inMinutes < 60) {
      timeAgo = '${difference.inMinutes}분 전';
    } else if (difference.inHours < 24) {
      timeAgo = '${difference.inHours}시간 전';
    } else if (difference.inDays < 30) {
      timeAgo = '${difference.inDays}일 전';
    } else {
      timeAgo = '${difference.inDays ~/ 30}달 전';
    }

    return TownLifePost(
      category: category,
      title: title,
      content: content,
      location: '${region.codeName} ${region.displayName}',
      regionId: region.codeName,
      subRegion: region.displayName,
      timeAgo: timeAgo,
      commentCount: commentCount,
      likeCount: 0, // Firestore 데이터에 likeCount가 없으므로 기본값 0 설정
      imageUrl:
          imageUrls.isNotEmpty ? imageUrls[0] : null, // 첫 번째 이미지를 대표 이미지로 사용
      imageUrls: imageUrls, // 모든 이미지 URL 목록 전달
    );
  }
}

class RegionInfo {
  final String codeName;
  final String displayName;
  final String title;

  RegionInfo({
    required this.codeName,
    required this.displayName,
    required this.title,
  });

  factory RegionInfo.fromMap(Map<String, dynamic> map) {
    return RegionInfo(
      codeName: map['codeName'] ?? '',
      displayName: map['displayName'] ?? '',
      title: map['title'] ?? '',
    );
  }
}
