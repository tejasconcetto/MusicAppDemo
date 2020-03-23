import 'dart:async';

import 'package:connectivity/connectivity.dart';

///
/// Network is wrapper on Connectivity.
/// This class will return the network which we are currently connected to.
/// ConnectionState enum is returned.

enum NetworkState {
  mobile,
  wifi,
  off,
}

///used to check network available or not
class NetworkManagerImpl extends NetworkManager {
  StreamController<NetworkState> _networkState = StreamController.broadcast();

  NetworkManagerImpl() {
    Connectivity().onConnectivityChanged.listen((result) {
      checkNetwork();
    });
  }

  void checkNetwork() async {
    NetworkState value = await getNetworkState();
    _networkState.add(value);
  }

  @override
  Stream<NetworkState> getNetworkStateStream() {
    return _networkState.stream;
  }

  ///
  /// Method will help to get currently connected network status.
  ///
  @override
  Future<NetworkState> getNetworkState() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return NetworkState.mobile;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return NetworkState.wifi;
    }
    return NetworkState.off;
  }
}

abstract class NetworkManager {
  Future<NetworkState> getNetworkState();

  Stream<NetworkState> getNetworkStateStream();
}