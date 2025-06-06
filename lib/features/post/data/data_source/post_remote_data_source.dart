import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sodong_app/features/post_list/domain/models/firestore_post.dart';
import 'package:sodong_app/features/post_list/domain/models/town_life_post.dart';

/// 원격 데이터 소스 클래스
///
/// Firestore에서 게시물 데이터를 가져오는 역할을 담당합니다.
class PostRemoteDataSource {
  PostRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  // 페이지네이션 관련 상태
  static const int pageSize = 10;
  DocumentSnapshot? _lastDocument;
  int _totalItemCount = 0;

  /// 초기 게시물 가져오기
  Future<List<TownLifePost>> fetchInitialPosts({
    required String regionId,
    required String subRegion,
    required String category,
  }) async {
    _lastDocument = null;

    try {
      // 문서 ID 생성
      final docId = _getDocumentId(regionId, subRegion);

      // 새로운 Firestore 구조에 맞게 쿼리 수정
      // 'posts' 컬렉션 -> 지역 문서(docId) -> 카테고리 컬렉션
      final countQuery = await _firestore
          .collection('posts')
          .doc(docId)
          .collection(category)
          .count()
          .get();

      _totalItemCount = countQuery.count ?? 0;

      // 데이터가 없으면 빈 리스트 반환
      if (_totalItemCount == 0) {
        _lastDocument = null;
        return [];
      }

      // 초기 데이터 쿼리
      var query = _firestore
          .collection('posts')
          .doc(docId)
          .collection(category)
          .orderBy('createdAt', descending: true)
          .limit(pageSize);

      final querySnapshot = await query.get();

      if (querySnapshot.docs.isEmpty) {
        _lastDocument = null;
        return [];
      }

      // 마지막 문서 저장 (다음 페이지 로드 시 사용)
      _lastDocument = querySnapshot.docs.last;

      // Firestore 문서를 도메인 모델로 변환
      return querySnapshot.docs
          .map((doc) => FirestorePost.fromFirestore(doc).toTownLifePost())
          .toList();
    } catch (e) {
      _lastDocument = null;
      return [];
    }
  }

  /// 신고된 게시물 ID 가져오기
  Future<List<String>> getReportedPostIds(String uid) async {
    try {
      final docSnapshot =
          await _firestore.collection('reports').doc('posts').get();

      if (!docSnapshot.exists) {
        return [];
      }

      final data = docSnapshot.data() as Map<String, dynamic>;

      if (data.containsKey(uid) && data[uid] is List) {
        final postIds = List<String>.from(data[uid]);
        return postIds;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  /// 추가 게시물 가져오기
  Future<List<TownLifePost>> fetchMorePosts({
    required String regionId,
    required String subRegion,
    required String category,
  }) async {
    if (_lastDocument == null) {
      return [];
    }

    try {
      // 문서 ID 생성
      final docId = _getDocumentId(regionId, subRegion);

      // 마지막 문서 이후의 데이터 쿼리
      var query = _firestore
          .collection('posts')
          .doc(docId)
          .collection(category)
          .orderBy('createdAt', descending: true)
          .startAfterDocument(_lastDocument!)
          .limit(pageSize);

      final querySnapshot = await query.get();

      if (querySnapshot.docs.isEmpty) {
        return [];
      }

      // 마지막 문서 업데이트
      _lastDocument = querySnapshot.docs.last;

      // Firestore 문서를 도메인 모델로 변환
      return querySnapshot.docs
          .map((doc) => FirestorePost.fromFirestore(doc).toTownLifePost())
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// 페이지네이션 상태 초기화
  void resetPagination() {
    _lastDocument = null;
    _totalItemCount = 0; // 총 아이템 수도 초기화
  }

  /// 문서 ID 생성 (지역_하위지역 형식에서 '서울특별시 강남구' 형식으로 변경)
  String _getDocumentId(String regionId, String subRegion) {
    // 지역 ID를 한글 지역명으로 변환
    String mainRegion;
    switch (regionId) {
      case 'seoul':
        mainRegion = '서울특별시';
        break;
      case 'busan':
        mainRegion = '부산광역시';
        break;
      case 'gyeonggi':
        mainRegion = '경기도';
        break;
      case 'incheon':
        mainRegion = '인천광역시';
        break;
      default:
        mainRegion = regionId; // 변환 규칙이 없는 경우 그대로 사용
    }

    // 하위 지역이 없으면 한글 지역명만 반환
    if (subRegion.isEmpty) {
      return mainRegion;
    }

    // '지역명 하위지역명' 형식으로 반환 (예: '서울특별시 강남구')
    return '$mainRegion $subRegion';
  }
}
