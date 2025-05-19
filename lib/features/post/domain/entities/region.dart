// lib/domain/entities/region.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Region {
  const Region({
    required this.codeName,
    required this.displayName,
  });

  final String codeName; // 'seoul_gangnam'
  final String displayName; // '강남구'

  factory Region.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data()!;
    return Region(
      codeName: snapshot.id,
      displayName: data['displayName'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'codeName': codeName,
      'displayName': displayName,
    };
  }
}
