abstract interface class ReportDataSource {
  Future<bool> report(String uid, String postId);
}
