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

  // 한글 지역명을 영문으로 변환하는 매핑 테이블
  static const Map<String, String> _koToEnRegionMap = {
    // 서울
    '강남': 'gangnam',
    '강동': 'gangdong',
    '강북': 'gangbuk',
    '강서': 'gangseo',
    '관악': 'gwanak',
    '광진': 'gwangjin',
    '구로': 'guro',
    '금천': 'geumcheon',
    '노원': 'nowon',
    '도봉': 'dobong',
    '동대문': 'dongdaemun',
    '동작': 'dongjak',
    '마포': 'mapo',
    '서대문': 'seodaemun',
    '서초': 'seocho',
    '성동': 'seongdong',
    '성북': 'seongbuk',
    '송파': 'songpa',
    '양천': 'yangcheon',
    '영등포': 'yeongdeungpo',
    '용산': 'yongsan',
    '은평': 'eunpyeong',
    '종로': 'jongno',
    '중구': 'junggu',
    '중랑': 'jungnang',
  };

  // 부산 지역 매핑 테이블 (중복 방지)
  static const Map<String, String> _busanRegionMap = {
    '강서': 'gangseo',
    '금정': 'geumjeong',
    '기장': 'gijang',
    '남구': 'namgu',
    '동구': 'donggu',
    '동래': 'dongnae',
    '부산진': 'busanjin',
    '북구': 'bukgu',
    '사상': 'sasang',
    '사하': 'saha',
    '서구': 'seogu',
    '수영': 'suyeong',
    '연제': 'yeonje',
    '영도': 'yeongdo',
    '중구': 'junggu',
    '해운대': 'haeundae',
  };

  // 경기도 지역 매핑 테이블 추가
  static const Map<String, String> _gyeonggiRegionMap = {
    '고양': 'goyang',
    '과천': 'gwacheon',
    '광명': 'gwangmyeong',
    '광주': 'gwangju',
    '구리': 'guri',
    '군포': 'gunpo',
    '김포': 'gimpo',
    '남양주': 'namyangju',
    '동두천': 'dongducheon',
    '부천': 'bucheon',
    '성남': 'seongnam',
    '수원': 'suwon',
    '시흥': 'siheung',
    '안산': 'ansan',
    '안성': 'anseong',
    '안양': 'anyang',
    '양주': 'yangju',
    '여주': 'yeoju',
    '오산': 'osan',
    '용인': 'yongin',
    '의왕': 'uiwang',
    '의정부': 'uijeongbu',
    '이천': 'icheon',
    '파주': 'paju',
    '평택': 'pyeongtaek',
    '포천': 'pocheon',
    '하남': 'hanam',
    '화성': 'hwaseong',
    '가평': 'gapyeong',
    '양평': 'yangpyeong',
    '연천': 'yeoncheon',
  };

  // 인천 지역 매핑 테이블 추가
  static const Map<String, String> _incheonRegionMap = {
    '계양': 'gyeyang',
    '남동': 'namdong',
    '동구': 'donggu',
    '미추홀': 'michuhol',
    '부평': 'bupyeong',
    '서구': 'seogu',
    '연수': 'yeonsu',
    '중구': 'junggu',
    '강화': 'ganghwa',
    '옹진': 'ongjin',
  };

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

      // 먼저 컬렉션에 있는 문서 수를 가져옵니다
      final countQuery = await _firestore
          .collection('posts')
          .doc(docId)
          .collection(category)
          .count()
          .get();

      _totalItemCount = countQuery.count ?? 0;

      // 데이터가 없으면 빈 리스트 반환
      if (_totalItemCount == 0) {
        _lastDocument = null; // 명시적으로 null 설정
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
        _lastDocument = null; // 데이터가 없으면 명시적으로 null 설정
        return [];
      }

      // 마지막 문서 저장 (다음 페이지 로드 시 사용)
      _lastDocument = querySnapshot.docs.last;

      // Firestore 문서를 도메인 모델로 변환
      return querySnapshot.docs
          .map((doc) => FirestorePost.fromFirestore(doc).toTownLifePost())
          .toList();
    } catch (e) {
      // 오류 발생 시 빈 리스트 반환
      _lastDocument = null; // 오류 발생 시 명시적으로 null 설정
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
      // 오류 발생 시 빈 리스트 반환
      return [];
    }
  }

  /// 페이지네이션 상태 초기화
  void resetPagination() {
    _lastDocument = null;
    _totalItemCount = 0; // 총 아이템 수도 초기화
  }

  /// 문서 ID 생성 (지역_하위지역 형식)
  String _getDocumentId(String regionId, String subRegion) {
    // 하위 지역이 없으면 지역 ID만 반환
    if (subRegion.isEmpty) {
      return regionId;
    }

    // 하위 지역에서 '구', '군', '시' 제거
    String koreanName =
        subRegion.replaceAll('구', '').replaceAll('시', '').replaceAll('군', '');

    // 한글 지역명을 영문으로 변환 (지역에 따라 다른 매핑 테이블 사용)
    String englishName;

    if (regionId == 'busan') {
      englishName = _busanRegionMap[koreanName] ?? koreanName.toLowerCase();
    } else if (regionId == 'gyeonggi') {
      englishName = _gyeonggiRegionMap[koreanName] ?? koreanName.toLowerCase();
    } else if (regionId == 'incheon') {
      englishName = _incheonRegionMap[koreanName] ?? koreanName.toLowerCase();
    } else {
      englishName = _koToEnRegionMap[koreanName] ?? koreanName.toLowerCase();
    }

    // {도시}_{구} 형식으로 반환 (seoul_gangnam, busan_haeundae 등)
    return '${regionId}_$englishName';
  }
}
