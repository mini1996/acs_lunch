import 'dart:convert';
import 'package:acs_lunch/app/Screens/LunchBooking/book_lunch.model.dart';
import 'package:acs_lunch/app/domain/repository/booking_screen/book_screen.repository.dart';
import 'package:acs_lunch/app/utils/http_helper.dart';
import 'package:acs_lunch/constant/endpoints.dart';
import 'package:acs_lunch/constant/settings.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// OfflineHelper offlineHelper = OfflineHelper();
HttpHelper httpHelper = HttpHelper();
class LunchBookingRepository implements BookingScreenRepository {
 
  bookLunch() async {
    return await httpHelper.request(HttpMethods.post,endPoint:Endpoints.lunchBookingUrl,authenticationRequired:true,data:json.encode(Settings.timeEntry) );

  }
  cancelLunch() async{
SharedPreferences mySharedPreferences;
mySharedPreferences=await SharedPreferences.getInstance();
     String cancelid=mySharedPreferences.getInt('userid').toString();
    var cancelidUrl=Endpoints.lunchCancellingUrl +cancelid + ".json";
     return await httpHelper.request(HttpMethods.delete,endPoint:cancelidUrl,authenticationRequired:true );

  }
  getmenuitems() async{ 
     return await httpHelper.request(HttpMethods.get,endPoint:Endpoints.menuDisplayUrl,authenticationRequired:true,isAdmin: true );
  }
  bookingList() async
   {
    var checkurl = Endpoints.checkBookingUrl ;
return await httpHelper.request(HttpMethods.get,endPoint:checkurl,authenticationRequired:true );
  }
  checkUser() async
  {
    var now = new DateTime.now();
    var checkurl = Endpoints.checkBookingUrl + new DateFormat("yyyy-MM-dd").format(now);
return await httpHelper.request(HttpMethods.get,endPoint:checkurl,authenticationRequired:true );
  }

  
 
  }

  

  

