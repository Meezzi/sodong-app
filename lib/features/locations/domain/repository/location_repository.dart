abstract interface class LocationRepository {
  Future<List<String>> findByName(String query);
  Future<List<String>> findByLatLng({
    required double lat,
    required double lng,
  });
}
