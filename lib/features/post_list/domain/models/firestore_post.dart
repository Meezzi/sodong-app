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
    try {
      final data = doc.data() as Map<String, dynamic>? ?? {};

      // 데이터가 없는 경우에도 기본값으로 생성할 수 있도록 함
      Timestamp timestamp;
      try {
        timestamp = data['createdAt'] as Timestamp? ?? Timestamp.now();
      } catch (e) {
        timestamp = Timestamp.now();
      }

      List<String> images = [];
      try {
        if (data['imageUrls'] != null) {
          images = List<String>.from(data['imageUrls']);
        } else if (data['imageUrl'] != null && data['imageUrl'] is String) {
          // 단일 이미지 URL을 리스트로 변환
          images = [data['imageUrl'] as String];
        }
      } catch (e) {
        // 이미지 URL 파싱 에러 처리
      }

      RegionInfo regionInfo;
      try {
        if (data['region'] != null && data['region'] is Map) {
          regionInfo =
              RegionInfo.fromMap(data['region'] as Map<String, dynamic>);
        } else {
          // 지역 정보가 없으면 기본값 사용
          final docPath = doc.reference.path;

          // 경로에서 지역 ID 추출 (posts/seoul_gangnam/question/docId)
          final parts = docPath.split('/');
          String regionId = parts.length > 1 ? parts[1] : '';

          // seoul_gangnam -> Seoul Gangnam 형식으로 변환
          final regionParts = regionId.split('_');
          String regionName = regionId;
          String subRegion = '';

          if (regionParts.length > 1) {
            regionName = regionParts[0].substring(0, 1).toUpperCase() +
                regionParts[0].substring(1);
            subRegion = regionParts[1].substring(0, 1).toUpperCase() +
                regionParts[1].substring(1);
          }

          regionInfo = RegionInfo(
            codeName: regionId,
            displayName: subRegion,
            title: '$regionName $subRegion',
          );
        }
      } catch (e) {
        regionInfo = RegionInfo(
          codeName: 'unknown',
          displayName: 'Unknown',
          title: 'Unknown Location',
        );
      }

      return FirestorePost(
        id: doc.id,
        category: data['category'] as String? ?? '',
        content: data['content'] as String? ?? '',
        commentCount: data['commentCount'] as int? ?? 0,
        createdAt: timestamp,
        imageUrls: images,
        isAnonymous: data['isAnonymous'] as bool? ?? false,
        nickname: data['nickname'] as String? ?? '익명',
        title: data['title'] as String? ?? '',
        userId: data['userId'] as String? ?? '',
        region: regionInfo,
      );
    } catch (e) {
      // 기본값으로 생성
      return FirestorePost(
        id: doc.id,
        category: 'question',
        content: '내용 없음',
        commentCount: 0,
        createdAt: Timestamp.now(),
        imageUrls: [],
        isAnonymous: false,
        nickname: '익명',
        title: '제목 없음',
        userId: '',
        region: RegionInfo(
          codeName: 'unknown',
          displayName: 'Unknown',
          title: 'Unknown Location',
        ),
      );
    }
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
      codeName: map['codeName'] as String? ?? '',
      displayName: map['displayName'] as String? ?? '',
      title: map['title'] as String? ?? '',
    );
  }
}
