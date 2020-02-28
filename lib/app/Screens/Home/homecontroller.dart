import 'dart:async';
import 'package:acs_lunch/app/Screens/Home/homemodel.dart';
import 'package:acs_lunch/app/Screens/Login/loginview.dart';
import 'package:acs_lunch/app/Screens/LunchBooking/book_lunch.view.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  get currentmonthname =>model.currentmonthname;
 set currentmonthname(value) =>model.currentmonthname=value;
   get previousmonthname =>model.previousmonthname;
 set previousmonthname(value) =>model.previousmonthname=value;
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
      model.mySharedPreferences =
        await SharedPreferences.getInstance();
        var now = new DateTime.now();
        
        var formatter = new DateFormat.MMMM();
      
        setState(() {
        currentmonthname = formatter.format(now);
        
        });
        setState(() {
        //previousmonthname = formatter.add_MMMM();
        });
     print("ddsddsds") ;  
  }
  void previousmonth() async{
  var totallist=await model.bookingList();
 

  }
  void currentmonth() async{
    
  var totallist=await model.bookingList();
  
  print(currentmonthname);
  }
  void navigationPage(BuildContext context) {
    print(currentmonthname);
     Navigator.push( this.stateMVC.context,MaterialPageRoute(builder: (context) => BookLunchScreen()), );
     
  }

  
}
