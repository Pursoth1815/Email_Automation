import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define a ChangeNotifier class for managing connectivity status
class NetworkNotifier extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  bool _isConnected = true;

  NetworkNotifier() {
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (results.isNotEmpty) {
        _updateConnectionStatus(results.first);
      }
    });
  }

  bool get isConnected => _isConnected;

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    final wasConnected = _isConnected;
    if (connectivityResult == ConnectivityResult.none) {
      _isConnected = false;
    } else {
      _isConnected = true;
    }

    if (wasConnected != _isConnected) {
      notifyListeners();
    }
  }
}

// Create a ChangeNotifierProvider for NetworkNotifier
final networkNotifierProvider = ChangeNotifierProvider<NetworkNotifier>((ref) {
  return NetworkNotifier();
});
