// connectivity_service.dart
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flowershop/utils/colors_const.dart';
import 'package:flowershop/views/widgets/text_button.dart';

enum ConnectivityStatus { notDetermined, isConnected, isDisconnected }

class ConnectivityStatusNotifier extends StateNotifier<ConnectivityStatus> {
  StreamSubscription? _subscription;
  final Connectivity _connectivity = Connectivity();

  ConnectivityStatus? _lastResult;

  ConnectivityStatusNotifier() : super(ConnectivityStatus.notDetermined) {
    _initConnectivity();
    _setupSubscription();
  }

  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result.first);
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
      state = ConnectivityStatus.notDetermined;
    }
  }

  void _setupSubscription() {
    _subscription = _connectivity.onConnectivityChanged
        .listen((val) => _updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    final newState = _mapResultToStatus(result);

    if (newState != _lastResult) {
      state = newState;
      _lastResult = newState;
    }
  }

  ConnectivityStatus _mapResultToStatus(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
      case ConnectivityResult.wifi:
      case ConnectivityResult.ethernet:
        return ConnectivityStatus.isConnected;
      case ConnectivityResult.none:
        return ConnectivityStatus.isDisconnected;
      default:
        return ConnectivityStatus.notDetermined;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final connectivityProvider =
    StateNotifierProvider<ConnectivityStatusNotifier, ConnectivityStatus>(
        (ref) {
  return ConnectivityStatusNotifier();
});

// connectivity_wrapper.dart
class ConnectivityWrapper extends ConsumerStatefulWidget {
  final Widget child;

  const ConnectivityWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  ConsumerState<ConnectivityWrapper> createState() =>
      _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends ConsumerState<ConnectivityWrapper> {
  @override
  Widget build(BuildContext context) {
    final connectivityStatus = ref.watch(connectivityProvider);

    if (connectivityStatus == ConnectivityStatus.isDisconnected) {
      return _buildDefaultDisconnectedWidget();
    }

    return widget.child;
  }

  Widget _buildDefaultDisconnectedWidget() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 48),
            const SizedBox(height: 16),
            const Text(
              'No Internet Connection',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                await ref
                    .read(connectivityProvider.notifier)
                    ._initConnectivity();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class NoConnectionView extends StatelessWidget {
  NoConnectionView({Key? key});

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.swatch1,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 48),
            const SizedBox(height: 16),
            const Text(
              'No Internet Connection',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            MyTextButton(
              title: 'Retry',
              onPressed: () async {
                Phoenix.rebirth(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
