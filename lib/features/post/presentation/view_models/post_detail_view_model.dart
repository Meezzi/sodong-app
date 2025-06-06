import 'package:sodong_app/features/post/domain/use_case/report_post_use_case.dart';

class ReportViewModel {
  ReportViewModel(this.reportPostUseCase);

  final ReportPostUseCase reportPostUseCase;

  Future<void> reportPost(String uid, String postId) async {
    try {
      await reportPostUseCase.reportPost(uid, postId);
    } catch (e) {
      throw Exception('신고 처리에 실패했습니다.');
    }
  }
}
