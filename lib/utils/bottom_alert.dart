import 'package:flutter/material.dart';

showSnackBar(context, message) {
  print(context);
  Scaffold.of(context).hideCurrentSnackBar();
  Scaffold.of(context).showSnackBar(new SnackBar(
    content: new Text("$message"),
    duration: Duration(seconds: 2),
  ));
}