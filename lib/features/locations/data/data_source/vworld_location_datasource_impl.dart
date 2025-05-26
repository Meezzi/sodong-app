import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sodong_app/features/locations/data/data_source/vworld_location_data_source.dart';

class VWorldLocationDataSourceImpl implements VworldLocationDataSource {
  VWorldLocationDataSourceImpl({required this.client});
  final Dio client;

  @override
  Future<List<String>> findByName(String query) async {
    final String apiKey = dotenv.env['VWORLD_API_KEY'] ?? '';
    try {
      final response = await client.get(
        'https://api.vworld.kr/req/search',
        queryParameters: {
          'request': 'search',
          'key': apiKey,
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
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<String>> findByLatLng({
    required double lat,
    required double lng,
  }) async {
    final String apiKey = dotenv.env['VWORLD_API_KEY'] ?? '';
    try {
      final response = await client.get(
        'https://api.vworld.kr/req/data',
        queryParameters: {
          'request': 'GetFeature',
          'data': 'LT_C_ADEMD_INFO',
          'key': apiKey,
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
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
