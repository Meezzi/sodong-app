abstract interface class ReportDataSource {
  Future<bool> reportPost(String uid, String postId);
}
