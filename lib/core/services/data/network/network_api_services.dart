import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thiran_tech/core/services/data/network/base_api_services.dart';

class NetworkApiServices extends BaseApiServices {
  final dio = Dio();
  final baseUrl = 'https://api.github.com/search/repositories';

  @override
  Future<dynamic> getApi() async {
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
        throw Exception(
            "Error occurred while communicating with API: ${response.statusCode}");
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
