import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:thiran_tech/core/services/data/network/base_api_services.dart';

class NetworkApiServices extends BaseApiServices {
  final dio = Dio();
  final baseUrl = 'https://api.github.com/search/repositories';

  @override
  Future<dynamic> getApi() async {
    dynamic responseJson;

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
        if (kDebugMode) {
          log(response.statusCode.toString());
          log("${response.data}");
        }
        responseJson = response.data;
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
