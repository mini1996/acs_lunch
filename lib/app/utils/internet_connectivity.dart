import 'package:connectivity/connectivity.dart';

class NetworkChecker {
  get isAvailable async {
    Map connectionStatus;
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      connectionStatus = {"status": true, "connectionType": "mobile"};
      return connectionStatus;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      connectionStatus = {"status": true, "type": "wifi"};
      return connectionStatus;
    } else {
      connectionStatus = {"status": false, "type": null};
      return connectionStatus;
    }
  }
}
