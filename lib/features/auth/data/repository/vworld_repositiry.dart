import 'package:dio/dio.dart';

class VWorldRepository {
  final Dio _client = Dio(BaseOptions(
    validateStatus: (status) => true,
  ));
}
