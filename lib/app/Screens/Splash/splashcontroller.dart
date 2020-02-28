import 'dart:async';
import 'package:acs_lunch/app/Screens/Home/homeview.dart';
import 'package:acs_lunch/app/Screens/Login/loginview.dart';
import 'package:acs_lunch/constant/preferences.dart';

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'splashmodel.dart';

class Controller extends ControllerMVC {
 // final log = getLogger('splash');
  factory Controller() {
    if (_this == null) _this = Controller._();
    return _this;
  }
  static Controller _this;

  Controller._();

  static Controller get controller => _this;
 
  Model model = Model();
  // get context => model.context;
  // set context(value)=>model.context = value;
  
  @override
  void initState() {
    //runs first, avoid using this unless mandatory
    super.initState();
  
  }

  @override
  void dispose() {
    //runs second
    _this = null;
    super.dispose();
  }
init() async {
   var _duration = new Duration(seconds: 4);
   model.mySharedPreferences =
        await SharedPreferences.getInstance();
     String token=   model.mySharedPreferences.getString(Preferences.auth_token);
       if (token != null && token != "") {
    return new Timer(_duration,  tokenPresentnavigationPage);
       }
       else{
          return new Timer(_duration, tokenAbsentnavigationPage);
       }
    
  }
  void tokenPresentnavigationPage() {
     Navigator.push( this.stateMVC.context,MaterialPageRoute(builder: (context) => Homescreen()), );
  }
 void tokenAbsentnavigationPage() {
     Navigator.push( this.stateMVC.context,MaterialPageRoute(builder: (context) => Loginscreen()), );
  }
  
}
