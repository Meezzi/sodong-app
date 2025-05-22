import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sodong_app/features/profile/data/dtos/profile_dto.dart';

class UserRemoteDataSource {
  UserRemoteDataSource(this.firestore);
  final FirebaseFirestore firestore;

  Future<ProfileDto> getUser(String userId) async {
    final doc = await firestore.collection('users').doc(userId).get();
    return ProfileDto.fromJson(doc.data()!);
  }

  Future<void> updateUser(String userId, ProfileDto dto) async {
    await firestore.collection('users').doc(userId).update(dto.toJson());
  }
}
