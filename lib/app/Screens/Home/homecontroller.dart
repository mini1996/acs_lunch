import 'package:acs_lunch/app/Screens/Home/homemodel.dart';
import 'package:acs_lunch/app/Screens/LunchBooking/book_lunch.view.dart';
import 'package:acs_lunch/app/utils/http_helper.dart';
import 'package:acs_lunch/constant/preferences.dart';
import 'package:acs_lunch/utils/flushbar.dart';
import 'package:acs_lunch/utils/loader.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

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
  get loaderStatus => model.loaderStatus;
  get loginUser => model.loginUser;
  get isInternetAvailable => model.isInternetAvailable;
  set isInternetAvailable(boolean) => model.isInternetAvailable = boolean;
  set loginUser(value) => model.loginUser = value;
  get currentmonthname => model.currentmonthname;
  set currentmonthname(value) => model.currentmonthname = value;
  get previousmonthname => model.previousmonthname;
  set previousmonthname(value) => model.previousmonthname = value;
  get dateWiseResults => model.dateWiseResults;
  set dateWiseResults(value) => model.dateWiseResults = value;
  get backButtonPressTime => model.backButtonPressTime;
  set backButtonPressTime(value) => model.backButtonPressTime = value;
  get scaffoldKey => model.scaffoldKey;
  set scaffoldKey(value) => model.scaffoldKey;
  get errorMessage => model.errorMessage;
  set errorMessage(value) => model.errorMessage = value;
  static const snackBarDuration = Duration(seconds: 3);
  final snackBar = SnackBar(
    content: Text('Press back again to exit'),
    duration: snackBarDuration,
  );

  @override
  void initState() {
    //runs first, avoid using this unless mandatory
    super.initState();
  }

  @override
  void dispose() {
    //runs second
    model.internetSubscription.cancel();
    _this = null;
    super.dispose();
  }

  init() async {
    model.internetSubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // Got a new connectivity status!
      if (result == ConnectivityResult.none)
        setState(() {
          isInternetAvailable = false;
        });
      else
        setState(() {
          isInternetAvailable = true;
        });
    });
    model.mySharedPreferences = await SharedPreferences.getInstance();
    loginUser = model.mySharedPreferences.getString(Preferences.login_token);
    monthNames();
    await fetchLunchCountMonthWise();
  }

  monthNames() async {
    var now = new DateTime.now();
    var formatter = new DateFormat.MMMM();
    setState(() {
      currentmonthname = formatter.format(now);
    });
    var prevMonth = new DateTime(now.year, now.month - 1, now.day);
    setState(() {
      previousmonthname = formatter.format(prevMonth);
    });
  }

  Future<void> fetchLunchCountMonthWise() async {
    var lunchCountResponse = await model.fetchLunchCount();
    if (lunchCountResponse['status'] == ResponseStatus.success) {
      dateWiseResults = lunchCountResponse['data'];
      setState(() {
        model.loaderStatus = LoaderStatus.loaded;
      });
    } else {
      setState(() {
        model.loaderStatus = LoaderStatus.error;
        model.errorMessage = lunchCountResponse['message'];
      });

      FlushBarHelper.show(this.stateMVC.context,
          message: lunchCountResponse['message']);
    }
  }

  void navigationPage(BuildContext context) async {
    final result = await Navigator.push(
      this.stateMVC.context,
      MaterialPageRoute(builder: (context) => BookLunchScreen()),
    );
    if (result == true) {
      fetchLunchCountMonthWise();
    }
  }

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();

    bool backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
        backButtonPressTime == null ||
            currentTime.difference(backButtonPressTime) > snackBarDuration;

    if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
      backButtonPressTime = currentTime;
      scaffoldKey.currentState.showSnackBar(snackBar);
      return false;
    }

    exit(0);
    return false; //true sends it to previous page
  }
}
