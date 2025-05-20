import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class VWorldLocationRepository {
  final Dio _client = Dio(BaseOptions(
    validateStatus: (status) => true,
  ));

  Future<List<String>> findByName(String query) async {
    final String _apiKey = dotenv.env['VWORLD_API_KEY'] ?? '';
    try {
      final response = await _client.get(
        'https://api.vworld.kr/req/search',
        queryParameters: {
          'request': 'search',
          'key': _apiKey,
          'query': query,
          'type': 'DISTRICT',
          'category': 'L4',
          'size': 100,
        },
      );

      if (response.statusCode == 200 &&
          response.data['response']['status'] == 'OK') {
        return List.of(response.data['response']['result']['items'])
            .map((e) => e['title'].toString())
            .toList();
      } else {
        print(
            'findByName 실패: status=${response.statusCode}, message=${response.data}');
        return [];
      }
    } catch (e) {
      print('findByName 예외 발생: $e');
      return [];
    }
  }

  Future<List<String>> findByLatLng({
    required double lat,
    required double lng,
  }) async {
    final String _apiKey = dotenv.env['VWORLD_API_KEY'] ?? '';
    try {
      final response = await _client.get(
        'https://api.vworld.kr/req/data',
        queryParameters: {
          'request': 'GetFeature',
          'data': 'LT_C_ADEMD_INFO',
          'key': _apiKey,
          'geomfilter': 'point($lng $lat)',
          'geometry': 'false',
          'size': 100,
        },
      );

      if (response.statusCode == 200 &&
          response.data['response']['status'] == 'OK') {
        return List.of(response.data['response']['result']['featureCollection']
                ['features'])
            .map((e) => e['properties']['full_nm'].toString())
            .toList();
      } else {
        print(
            'findByLatLng 실패: status=${response.statusCode}, message=${response.data}');
        return [];
      }
    } catch (e) {
      print('findByLatLng 예외 발생: $e');
      return [];
    }
  }
}
