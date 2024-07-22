import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

// Define a StateNotifier class for managing connectivity status
class NetworkNotifier extends StateNotifier<bool> {
  NetworkNotifier() : super(true) {
    _checkInitialConnection();
    InternetConnectionChecker().onStatusChange.listen((status) {
      _updateConnectionStatus(status == InternetConnectionStatus.connected);
    });
  }

  void _checkInitialConnection() async {
    final initialStatus = await InternetConnectionChecker().hasConnection;
    _updateConnectionStatus(initialStatus);
  }

  void _updateConnectionStatus(bool isConnected) {
    if (state != isConnected) {
      state = isConnected;
    }
  }
}

final networkNotifierProvider = StateNotifierProvider<NetworkNotifier, bool>((ref) {
  return NetworkNotifier();
});
