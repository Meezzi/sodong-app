abstract interface class ReportRepository {
  Future<bool> reportPost(String uid, String postId);
}
