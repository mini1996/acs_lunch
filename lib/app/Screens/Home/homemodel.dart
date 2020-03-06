import 'package:acs_lunch/app/data/repository/book_screen/book_repository.dart';
import 'package:acs_lunch/app/utils/http_helper.dart';
import 'package:acs_lunch/utils/loader.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Model {
  BuildContext context;
  bool isLoading = false;
  String errorMessage;
  SharedPreferences mySharedPreferences;
  LoaderStatus loaderStatus = LoaderStatus.loading;
  String currentmonthname = "";
  String previousmonthname = "";
  Map dateWiseResults;
  DateTime backButtonPressTime;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  LunchBookingRepository bookRepo = LunchBookingRepository();
  fetchLunchCount() async {
    var response = await bookRepo.lunchBookedMonthWiseEntries();
    if (response['status'] == ResponseStatus.success) {
      // int lastMonthCount = 0;
      // int thisMonthCount = 0;
      List lastMonthBookings = List();
      List currentMonthBookings = List();
      // int chickenFryCount = 0;
      // int fishFryCount = 0;
      var timeEntries = response['data']['time_entries'];
      for (Map timeEntry in timeEntries) {
        DateTime date = DateTime.parse(timeEntry['spent_on']);
        if (date.month == DateTime.now().month - 1) {
          lastMonthBookings.add(timeEntry);
        } else if (date.month == DateTime.now().month) {
          currentMonthBookings.add(timeEntry);
        }
      }
      // var extrasEntries = response['data']['time_entries']['custom_fields'];
      // Map dataWithOptions = extrasEntries.firstWhere((item) {
      //   return item['id'] == 47;
      // });
      // if ((dataWithOptions['value']) == "Chicken Fry") {
      //   chickenFryCount++;
      // }
      // if ((dataWithOptions['value']) == "Fish Fry") {
      //   fishFryCount++;
      // }
      // [{"name":"Lunch","count":20},{"name":"Chicken Fry","count":2},]

      List<specialFormat> currentMonthSpecials = [];
      currentMonthBookings.forEach((eachday) {
        List<dynamic> customFields = eachday["custom_fields"];
        String customItem = "";
        customFields.forEach((ee) {
          // if (ee["name"] == "Additional Item" && ee["name"] != null && ee["name"] != "") {
          //   bool isExist = false;
          //   currentMonthSpecials.forEach((e){
          //     if(e.name == ssssssssssssss )
          //   });
          //   currentMonthSpecials.add(new specialFormat(ee["value"], 1));

          // }
        });
      });
      response['data'] = {
        'thisMonth': currentMonthBookings,
        'lastMonth': lastMonthBookings,
      };
      return response;
    } else
      return response;
  }

  Map format(String name, int count) {
    return {"name": name, "count": count};
  }
}

class specialFormat {
  String name;
  int count;
  specialFormat(this.name, this.count);
}
