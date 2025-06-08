import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sodong_app/features/post/data/data_source/report_data_source.dart';

class RemoteReportDataSource implements ReportDataSource {
  RemoteReportDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Future<bool> reportPost(String uid, String postId) async {
    final reportDoc = _firestore.collection('reports').doc('posts');

    try {
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(reportDoc);
        if (!snapshot.exists) {
          // 문서가 없으면 새로 생성
          transaction.set(reportDoc, {
            uid: [postId],
          });
        } else {
          // 문서가 있으면 업데이트
          final data = snapshot.data() as Map<String, dynamic>;

          final reportedPostIds = List<String>.from(data[uid] ?? []);

          if (!reportedPostIds.contains(postId)) {
            reportedPostIds.add(postId);
          }

          transaction.update(reportDoc, {
            uid: reportedPostIds,
          });
        }
      });
      return true;
    } catch (e) {
      throw Exception(e);
    }
  }
}
