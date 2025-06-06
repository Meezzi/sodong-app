import 'package:sodong_app/features/post/domain/repository/report_repository.dart';

class ReportPostUseCase {
  ReportPostUseCase(this.reportRepository);

  final ReportRepository reportRepository;

  Future<bool> reportPost(String uid, String postId) async {
    return await reportRepository.reportPost(uid, postId);
  }
}
