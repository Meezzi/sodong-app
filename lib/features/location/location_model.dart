class LocationModel {
  LocationModel({
    required this.codeName,
    required this.displayName,
  });
  final String codeName;
  final String displayName;

  @override
  String toString() => displayName;
}
