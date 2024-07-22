import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thiran_tech/core/services/data/network/base_api_services.dart';

class NetworkApiServices extends BaseApiServices {
  final dio = Dio();
  final baseUrl = 'https://api.github.com/search/repositories';
  final getTokenUrl = 'https://oauth2.googleapis.com/token';

  @override
  Future<dynamic> post(Map requestData) async {
    try {
      final response = await dio.post(getTokenUrl,
          options: Options(
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          ),
          data: requestData);

      if (response.statusCode == 200) {
        return response.data['access_token'];
      } else {
        throw Exception('Failed to obtain access token: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error response data: ${(e as DioException).response?.data}');
      print('Error response headers: ${(e).response?.headers}');
      throw Exception('Error obtaining access token: $e');
    }
  }

  @override
  Future<dynamic> get() async {
    List<Map<String, dynamic>> responseJson;

    final DateTime now = DateTime.now();
    final DateTime lastDate = now.subtract(Duration(days: 30));
    final String fromDate = lastDate.toIso8601String();

    final Map<String, dynamic> params = {
      'q': 'created:>$fromDate',
      'sort': 'stars',
      'order': 'desc',
    };

    try {
      final response = await dio.get(baseUrl, queryParameters: params);

      if (response.statusCode == 200) {
        responseJson = List<Map<String, dynamic>>.from(response.data["items"]);
      } else {
        throw Exception("Error occurred while communicating with API: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception(e);
    }

    return responseJson;
  }
}

final networkServiceProvider = Provider<NetworkApiServices>((ref) {
  return NetworkApiServices();
});
