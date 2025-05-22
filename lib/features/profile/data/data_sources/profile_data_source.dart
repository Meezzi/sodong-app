import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sodong_app/features/profile/data/dtos/profile_dto.dart';

/// Firestore에서 사용자 데이터 조회 및 업데이트
class ProfileDataSource {
  ProfileDataSource(this.firestore);
  final FirebaseFirestore firestore;

  Future<ProfileDto> getUser(String userId) async {
    final doc = await firestore.collection('users').doc(userId).get();
    return ProfileDto.fromJson(doc.data()!);
  }

  Future<void> updateUser(String userId, ProfileDto dto) async {
    await firestore.collection('users').doc(userId).update(dto.toJson());
  }
}
