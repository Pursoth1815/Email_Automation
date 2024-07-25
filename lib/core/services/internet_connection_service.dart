import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'dart:async';

class NetworkNotifier extends StateNotifier<bool> {
  NetworkNotifier() : super(true) {
    _checkInitialConnection();
    _startPeriodicCheck();
  }

  void _checkInitialConnection() async {
    final initialStatus = await hasInternetConnection();
    _updateConnectionStatus(initialStatus);
  }

  void _updateConnectionStatus(bool isConnected) {
    if (state != isConnected) {
      state = isConnected;
    }
  }

  void _startPeriodicCheck() {
    const duration = Duration(seconds: 10);
    Timer.periodic(duration, (timer) async {
      final status = await hasInternetConnection();
      _updateConnectionStatus(status);
    });
  }

  Future<bool> hasInternetConnection() async {
    try {
      final response = await Dio().get('https://www.google.com');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

final networkNotifierProvider = StateNotifierProvider<NetworkNotifier, bool>((ref) {
  return NetworkNotifier();
});
