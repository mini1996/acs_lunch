import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class FlushBarHelper {
  static Flushbar show(context,
      {@required String message,
      String title,
      Duration duration = const Duration(seconds: 2)}) {
    return Flushbar(
      title: title,
      message: message,
      duration: duration,
    )..show(context);
  }
}
