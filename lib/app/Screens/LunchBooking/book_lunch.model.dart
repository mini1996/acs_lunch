import 'package:acs_lunch/app/data/repository/book_screen/book_repository.dart';
import 'package:acs_lunch/app/utils/http_helper.dart';
import 'package:acs_lunch/constant/settings.dart';
import 'package:acs_lunch/utils/loader.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Model {
  BuildContext context;
  bool isLoading = false;
  bool isBooked = false;
  bool isalreadyBooked = false;
  bool isCancelled = false;
  bool isEnabled = true;
  String errorMessage;
  String selectedExtraItemValue = "";
  String selectedLunchOptionValue = "";
  SharedPreferences mySharedPreferences;
  LoaderStatus loaderStatus = LoaderStatus.loading;
  List options = List();
  List specialOptions = List();
  List selectedExtraMenus = List();
  Map selectedLunchOption;
  int userID;
  LunchBookingRepository bookRepo = LunchBookingRepository();
  checkBooked() async {
    return await bookRepo.checkLunchBooked();
  }

  booking(int selectedId, String specialItemId) async {
    return await bookRepo
        .bookLunch(Settings.timeEntry(selectedId, specialItemId));
  }

  cancelBooked() async {
    return await bookRepo.cancelLunch();
  }

  menuItems() async {
    try {
      var fetchResponse = await bookRepo.getMenuItems();
      if (fetchResponse['status'] != ResponseStatus.success)
        return fetchResponse;
      List data = fetchResponse['data'] != null
          ? fetchResponse['data']['custom_fields']
          : List();
      Map dataWithOptions = data.firstWhere((item) {
        return item['id'] == 41;
      });
      fetchResponse['data'] = dataWithOptions['possible_values'];
      return fetchResponse;
    } catch (e) {
      return HttpHelper().provideResponse(status: ResponseStatus.error);
    }
  }

  specialMenuItems() async {
    try {
      var fetchResponse = await bookRepo.getMenuItems();
      if (fetchResponse['status'] != ResponseStatus.success)
        return fetchResponse;
      List data = fetchResponse['data'] != null
          ? fetchResponse['data']['custom_fields']
          : List();
      Map dataWithOptions = data.firstWhere((item) {
        return item['id'] == 47;
      });
      // print('final $dataWithOptions');
      fetchResponse['data'] = dataWithOptions['possible_values'];
      print(fetchResponse);
      return fetchResponse;
    } catch (e) {
      return HttpHelper().provideResponse(status: ResponseStatus.error);
    }
  }

  parseBookedItems(List timeEntries) {
    // var itemsResponse = await bookRepo.checkLunchBooked();

    Map todaysEntry = timeEntries[0];
    List customFields = todaysEntry['custom_fields'];

    String optionalItem;
    String mainItemId;

    customFields.forEach((customField) {
      if (customField["id"] == 47) {
        optionalItem = customField["value"];
      }
      if (customField["id"] == 41) {
        mainItemId = customField["value"];
      }
    });
    Map mainItem = options.firstWhere((lunchOption) {
      return lunchOption['value'] == mainItemId;
    });
    return {
      'mainItem': mainItem['label'],
      'optionalItem': optionalItem,
    };
  }
}
