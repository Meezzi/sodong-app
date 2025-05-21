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
          final Map<String, dynamic> regionData =
              data['region'] as Map<String, dynamic>;

          // 실제 데이터에서 표시 형식을 적절히 조정
          String displayName = regionData['displayName'] as String? ?? '';
          String codeName = regionData['codeName'] as String? ?? '';
          String title = regionData['title'] as String? ?? '';

          // title이 없거나 displayName이 실제 지역명인 경우 적절히 처리
          if (title.isEmpty || title.contains(codeName)) {
            // 지역코드에서 실제 지역명 추출 시도
            if (codeName.contains('_')) {
              final parts = codeName.split('_');
              String mainRegion = _getRegionNameFromId(parts[0]);
              displayName = displayName.isNotEmpty
                  ? displayName
                  : _capitalizeFirstLetter(parts[1]);
              title = '$mainRegion $displayName';
            }
          }

          regionInfo = RegionInfo(
            codeName: codeName,
            displayName: displayName,
            title: title.isNotEmpty ? title : '$codeName $displayName',
          );
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
            String mainRegion = _getRegionNameFromId(regionParts[0]);
            subRegion = _capitalizeFirstLetter(regionParts[1]);
            regionName = mainRegion;
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
          displayName: '알 수 없음',
          title: '알 수 없는 지역',
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
          displayName: '알 수 없음',
          title: '알 수 없는 지역',
        ),
      );
    }
  }

  // 첫 글자를 대문자로 변환
  static String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text.substring(0, 1).toUpperCase() + text.substring(1);
  }

  // 지역 ID에서 지역명 가져오기
  static String _getRegionNameFromId(String regionId) {
    switch (regionId) {
      case 'seoul':
        return '서울특별시';
      case 'gyeonggi':
        return '경기도';
      case 'incheon':
        return '인천광역시';
      case 'busan':
        return '부산광역시';
      default:
        return _capitalizeFirstLetter(regionId);
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

    // 지역 정보 가공 (title 사용, 이미 fromFirestore에서 적절히 가공됨)
    String locationText = region.title;

    // title이 여전히 코드네임을 포함하는 경우 추가 가공
    if (locationText.contains(region.codeName) &&
        region.codeName != 'unknown') {
      // 코드네임이 지역 ID인 경우
      if (region.codeName.contains('_')) {
        final parts = region.codeName.split('_');
        final mainRegion = _getRegionNameFromId(parts[0]);
        final subRegion = region.displayName.isNotEmpty
            ? region.displayName
            : _capitalizeFirstLetter(parts[1]);
        locationText = '$mainRegion $subRegion';
      }
    }

    return TownLifePost(
      category: category,
      title: title,
      content: content,
      location: locationText,
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
