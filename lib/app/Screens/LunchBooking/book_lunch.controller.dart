import 'package:acs_lunch/app/Screens/LunchBooking/book_lunch.model.dart';
import 'package:acs_lunch/app/utils/http_helper.dart';
import 'package:acs_lunch/constant/app_theme.dart';
import 'package:acs_lunch/utils/flushbar.dart';
import 'package:acs_lunch/utils/loader.dart';
import 'package:acs_lunch/utils/logger.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Controller extends ControllerMVC {
  //final log = getLogger('template');
  factory Controller() {
    if (_this == null) _this = Controller._();
    return _this;
  }
  static Controller _this;

  Controller._();

  static Controller get controller => _this;
  get loaderStatus => model.loaderStatus;
  get options => model.options;
  set options(value) => model.options = value;
  get specialOptions => model.specialOptions;
  set specialOptions(value) => model.specialOptions = value;
  get selectedLunchOption => model.selectedLunchOption;
  set selectedLunchOption(selectedLunchOption) =>
      model.selectedLunchOption = selectedLunchOption;
  get selectedLunchOptionValue => model.selectedLunchOptionValue;
  set selectedLunchOptionValue(value) => model.selectedLunchOptionValue = value;
  get selectedExtraMenus => model.selectedExtraMenus;
  set selectedExtraMenus(selectedExtraMenus) =>
      model.selectedExtraMenus = selectedExtraMenus;
  get selectedExtraItemValue => model.selectedExtraItemValue;
  set selectedExtraItemValue(value) => model.selectedExtraItemValue = value;
  set isLoading(value) => model.isLoading = value;
  get isLoading => model.isLoading;
  set isBooked(value) => model.isBooked = value;
  get isBooked => model.isBooked;
  set isalreadyBooked(value) => model.isalreadyBooked = value;
  get isalreadyBooked => model.isalreadyBooked;
  set isCancelled(value) => model.isCancelled = value;
  get isEnabled => model.isEnabled;
  set isEnabled(value) => model.isEnabled = value;
  get isCancelled => model.isCancelled;
  get errorMessage => model.errorMessage;
  set errorMessage(value) => model.errorMessage = value;
  set userID(value) => model.userID = value;
  get userID => model.userID;
  Model model = Model();

  final log = getLogger('book lunch screen');
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
    model.mySharedPreferences = await SharedPreferences.getInstance();
    await fetchMenuItems();
    await fetchSpecialMenuItems();
    await checkBookCount();
  }

  checkBookCount() async {
    var checkresponse = await model.checkBooked();
    if (checkresponse['status'] == ResponseStatus.success) {
      if (checkresponse['data']['total_count'] > 0) {
        setState(() {
          isalreadyBooked = true;
        });
        var parsedData =
            model.parseBookedItems(checkresponse['data']['time_entries']);
        setState(() {
          selectedLunchOptionValue = parsedData['mainItem'];
          selectedExtraItemValue = parsedData['optionalItem'];
          model.isalreadyBooked = true;
        });
      }
    }
  }

  fetchMenuItems() async {
    var fetchresponse = await model.menuItems();

    if (fetchresponse['status'] == ResponseStatus.success) {
      // log.d('sdfdb ${fetchresponse['data']}');
      options = fetchresponse['data'];
      selectedLunchOption =
          fetchresponse['data'].length > 0 ? fetchresponse['data'][0] : null;
      setState(() {
        model.loaderStatus = LoaderStatus.loaded;
      });
    } else {
      setState(() {
        model.loaderStatus = LoaderStatus.error;
        model.errorMessage = fetchresponse['message'];
      });

      FlushBarHelper.show(this.stateMVC.context,
          message: fetchresponse['message']);
    }
  }

  void fetchSpecialMenuItems() async {
    var fetchadditionalresponse = await model.specialMenuItems();

    if (fetchadditionalresponse['status'] == ResponseStatus.success) {
      // log.d('sdfdb ${fetchresponse['data']}');
      specialOptions = fetchadditionalresponse['data'];

      setState(() {
        model.loaderStatus = LoaderStatus.loaded;
      });
    } else {
      setState(() {
        model.loaderStatus = LoaderStatus.error;
      });

      FlushBarHelper.show(this.stateMVC.context,
          message: fetchadditionalresponse['message']);
    }
  }

  void onBookingPressed(BuildContext context) {
    setState(() {
      isLoading = true;
    });
    booking(context);
  }

  void booking(BuildContext context) async {
    var checkresponse = await model.checkBooked();
    if (checkresponse['status'] == ResponseStatus.success) {
      if (checkresponse['data']['total_count'] > 0) {
        setState(() {
          isLoading = false;

          model.isalreadyBooked = true;
        });
        Flushbar(
          message: "Booked Already",
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.orange,
          ),
          duration: Duration(seconds: 2),
          leftBarIndicatorColor: Colors.orange,
        )..show(context);
      } else {
        int selectedId = int.parse(selectedLunchOption['value']);
        var bookingresponse;
        Map selectedExtraItem;
        if (selectedExtraMenus.isEmpty) {
          bookingresponse = await model.booking(selectedId, "");
        } else {
          selectedExtraItem = selectedExtraMenus.first;
          selectedExtraItemValue = selectedExtraItem['value'];
          bookingresponse =
              await model.booking(selectedId, selectedExtraItemValue);
        }

        if (bookingresponse['status'] == ResponseStatus.success) {
          setState(() {
            isLoading = false;
          });
          setState(() {
            isBooked = true;
            isalreadyBooked = true;
          });

          setState(() {
            selectedExtraMenus.clear();
          });
          Flushbar(
            message: "Booked Successfully",
            icon: Icon(
              Icons.check,
              size: 28.0,
              color: Colors.green,
            ),
            duration: Duration(seconds: 2),
            leftBarIndicatorColor: Colors.green,
          )..show(context);
        } else {
          FlushBarHelper.show(this.stateMVC.context,
              message: bookingresponse['message']);
        }
      }
    } else {
      print(checkresponse['message']);
    }
  }

  void cancelLunch(BuildContext context) async {
    var checkresponse = await model.checkBooked();
    if (checkresponse['status'] == ResponseStatus.success) {
      if (checkresponse['data']['total_count'] > 0) {
        userID = checkresponse['data']['time_entries'][0]['id'];
        model.mySharedPreferences.setInt('userid', userID);
        var cancelresponse = await model.cancelBooked();
        //print(cancelresponse);
        if (cancelresponse['status'] == ResponseStatus.success) {
          setState(() {
            isalreadyBooked = false;
          });

          setState(() {
            isCancelled = true;
          });
          setState(() {
            isBooked = false;
          });

          Flushbar(
            message: "Cancelled",
            icon: Icon(
              Icons.cancel,
              size: 28.0,
              color: Colors.red,
            ),
            duration: Duration(seconds: 2),
            leftBarIndicatorColor: Colors.red,
          )..show(context);
        } else {
          print(cancelresponse['message']);
        }
      }
    } else {
      print(checkresponse['message']);
    }

    setState(() {
      isLoading = false;
    });
  }

  void lunchcancelDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext contexts) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text(
            'Cancel your Lunch',
            // style: TextStyle(color:Colors.red),
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'Are you sure you want to cancel?',
            //style: TextStyle(color:AppColors.themeColor),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text(
                'No',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: const Text(
                'Yes',
                style: TextStyle(color: AppColors.themeColor),
              ),
              onPressed: () {
                setState(() {
                  isLoading = true;
                });

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
