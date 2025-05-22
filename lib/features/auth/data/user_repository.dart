import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/auth/domain/repositories/user_repository.dart';

class RemoteUserRepository implements UserRepository {
  
  RemoteUserRepository({
    required this.auth,
    required this.firestore,
  });
  
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  @override
  User? getCurrentUser() => auth.currentUser;

  @override
  Future<bool?> isAgreementComplete(String uid) async {
    final doc = await firestore.collection('users').doc(uid).get();
    return doc.data()?['isAgreementComplete'] == true;
  }
}

final remoteUserRepositoryProvider = Provider<UserRepository>((ref) {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
    return RemoteUserRepository(auth: auth, firestore: firestore);
});
