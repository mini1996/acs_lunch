import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'splashcontroller.dart';

class Splashscreen extends StatefulWidget {
  Splashscreen({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends StateMVC<Splashscreen> {
  _SplashscreenState() : super(Controller());
  Controller _controller;
  @override
  void initState() {
    //runs second
    super.initState();
    _controller = Controller.controller;
   
    _controller.init(); //use this
  }

  @override
  void dispose() {
    //runs first
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
 //  _controller.context = context;
 
    return  Scaffold(
      body: Center(
       
       child: SpinKitFoldingCube(

          color: Colors.red,
          size: 100.0,
        )
      ),
    );
  }
}
