import 'package:acs_lunch/app/Screens/LunchBooking/book_lunch.model.dart';
import 'package:acs_lunch/app/utils/http_helper.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Controller extends ControllerMVC {
  //final log = getLogger('template');
  factory Controller() {
    if (_this == null) _this = Controller._();
    return _this;
  }
  static Controller _this;

  Controller._();
//String userID;
  static Controller get controller => _this;
 // AppController appController;
 List data = List();
set isLoading(value) => model.isLoading = value;
get isLoading => model.isLoading;
set isBooked(value) => model.isBooked = value;
get isBooked => model.isBooked;
set isalreadyBooked(value) => model.isalreadyBooked = value;
get isalreadyBooked => model.isalreadyBooked;
set isCancelled(value) => model.isCancelled = value;
get isCancelled => model.isCancelled;
get errorMessage => model.errorMessage;
set errorMessage(value) => model.errorMessage = value;
set userID(value) => model.userID = value;
get userID => model.userID;
Model model=Model();
  @override
  void initState() {
    super.initState();
   // appController = AppController.controller;
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
       
      
  }
  
  void onBookingPressed(BuildContext context) {
     setState(() {
      isLoading = true;
    });
    booking(context); 
  }
  void booking(BuildContext context) async {
       
   var checkresponse = await model.checkbooked();
   if(checkresponse['status']==ResponseStatus.success){
   if(checkresponse['data']['total_count']>0)
   {
      setState(() {
      isLoading = false;
    });
    setState(() {
      isalreadyBooked = true;
    });
    
 Flushbar(
  message: "Booked Already",
  icon: Icon(
    Icons.info_outline,
    size: 28.0,
    color: Colors.red,
    ),
  duration: Duration(seconds: 3),
  leftBarIndicatorColor: Colors.red,
)..show(context);
   
   }
   else{
     var bookingresponse=await model.booking();
 if(bookingresponse['status']==ResponseStatus.success){
    setState(() {
      isLoading = false;
    });
    setState(() {
      isBooked = true;
    });
     Flushbar(
  message: "Booked Successfully",
  icon: Icon(
    Icons.info_outline,
    size: 28.0,
    color: Colors.green,
    ),
  duration: Duration(seconds: 3),
  leftBarIndicatorColor: Colors.red,
)..show(context);
//print("booked successfully");
 }
   }
   }else{
     print(checkresponse['message']);
   }

}
void cancelLunch(BuildContext context) async
{
   var checkresponse = await model.checkbooked();
   if(checkresponse['status']==ResponseStatus.success){
   if(checkresponse['data']['total_count']>0)
   {
     userID =checkresponse['data']['time_entries'][0]['id'];
 model.mySharedPreferences.setInt('userid',userID);
 var cancelresponse = await model.cancelbooked();
 print(cancelresponse);
 if(cancelresponse['status']==ResponseStatus.success){
setState(() {
      isCancelled = true;
    });
  setState(() {
      isBooked =false;
    });  
     Flushbar(
  message: "Cancelled",
  icon: Icon(
    Icons.info_outline,
    size: 28.0,
    color: Colors.red,
    ),
  duration: Duration(seconds: 3),
  leftBarIndicatorColor: Colors.red,
)..show(context);
   }
   else{
     print(cancelresponse['message']);
   }
}}
else{
     print(checkresponse['message']);
   }

}
void fetchmenuitems (BuildContext context) async {

 var fetchresponse = await model.menuitems();
 
setState(() {
  print(fetchresponse['data']['custom_fields']);
      data = fetchresponse['data']!=null?fetchresponse['data']['custom_fields']:List();
    });

    print("hello");

}
void lunchcancelDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext contexts) {
        return AlertDialog(
          title: Text(
            'Cancel your Lunch',
            textAlign: TextAlign.center,
          ),
          content: const Text('Are you sure you want to cancel?'),
          actions: <Widget>[
            FlatButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: const Text('Yes'),
              onPressed: () {
               cancelLunch(context);
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

}