abstract interface class VworldLocationDataSource {
  Future<List<String>> findByName(String query);
  Future<List<String>> findByLatLng({
    required double lat,
    required double lng,
  });
}
