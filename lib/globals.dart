import 'package:flutter/material.dart';

class Globals {
  factory Globals() {
    if (_this == null) {
      print("creating new instance of globals");
      _this = Globals._();
    }
    return _this;
  }
  static Globals _this;
  Globals._();
BuildContext context;
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  static bool isNetworkAvailable = true;
  String currentRoute;
}
