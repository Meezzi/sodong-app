import 'package:sodong_app/features/post/data/data_source/remote_report_data_source.dart';
import 'package:sodong_app/features/post/domain/repository/report_repository.dart';

class RemoteReportRepository implements ReportRepository {
  RemoteReportRepository(this.reportDataSource);

  final RemoteReportDataSource reportDataSource;

  @override
  Future<bool> reportPost(String uid, String postId) async {
    final response = await reportDataSource.reportPost(uid, postId);

    return response;
  }
}
