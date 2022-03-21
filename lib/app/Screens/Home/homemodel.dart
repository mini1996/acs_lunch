import 'package:acs_lunch/app/data/repository/book_screen/book_repository.dart';
import 'package:acs_lunch/app/utils/http_helper.dart';
import 'package:acs_lunch/utils/loader.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Model {
  BuildContext context;
  bool isLoading = false;
  String errorMessage;
  var internetSubscription;
  SharedPreferences mySharedPreferences;
  LoaderStatus loaderStatus = LoaderStatus.loading;
  String currentmonthname = "";
  String previousmonthname = "";
  String loginUser = "";
  Map dateWiseResults;
  DateTime backButtonPressTime;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  LunchBookingRepository bookRepo = LunchBookingRepository();

  bool isInternetAvailable = true;
  fetchLunchCount() async {
    var response = await bookRepo.lunchBookedMonthWiseEntries();
    if (response['status'] == ResponseStatus.success) {
      List lastMonthBookings = List();
      List currentMonthBookings = List();
      var timeEntries = response['data']['time_entries'];
      for (Map timeEntry in timeEntries) {
        DateTime date = DateTime.parse(timeEntry['spent_on']);

        if (DateTime.now().month == 1) {
          if (date.month == 12) {
            lastMonthBookings.add(timeEntry);
          }
        }
        if (date.month == DateTime.now().month - 1) {
          lastMonthBookings.add(timeEntry);
        } else if (date.month == DateTime.now().month) {
          currentMonthBookings.add(timeEntry);
        }
      }
      List<Map> currentMonthSpecials = [];
      List<Map> lastMonthSpecials = [];

      currentMonthBookings.forEach((eachday) {
        List<dynamic> customFields = eachday["custom_fields"];
        // String customItem = "";
        customFields.forEach((customField) {
          if (customField["id"] == 47 &&
              customField["value"] != null &&
              customField["value"] != "") {
            bool isExists = false;
            currentMonthSpecials.forEach((item) {
              if (item["name"] == customField["value"]) {
                isExists = true;
                item["count"] += 1;
              }
            });
            if (isExists == false) {
              currentMonthSpecials.add(format(customField["value"], 1));
            } else {
              isExists = false;
            }
          }
        });
      });
      lastMonthBookings.forEach((eachday) {
        List<dynamic> customFields = eachday["custom_fields"];
        // String customItem = "";
        customFields.forEach((customField) {
          if (customField["id"] == 47 &&
              customField["value"] != null &&
              customField["value"] != "") {
            bool isExists = false;
            lastMonthSpecials.forEach((item) {
              if (item["name"] == customField["value"]) {
                isExists = true;
                item["count"] += 1;
              }
            });
            if (isExists == false) {
              lastMonthSpecials.add(format(customField["value"], 1));
            } else {
              isExists = false;
            }
          }
        });
      });
      response['data'] = {
        'thisMonth': currentMonthBookings,
        'lastMonth': lastMonthBookings,
        'thisMonthSpecials': currentMonthSpecials,
        'lastMonthSpecials': lastMonthSpecials
      };
      return response;
    } else
      return response;
  }

  Map format(String name, int count) {
    return {"name": name, "count": count};
  }
}
