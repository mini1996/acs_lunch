import 'dart:convert';
import 'package:acs_lunch/app/Screens/Home/homeview.dart';
import 'package:acs_lunch/app/data/repository/auth_screen/data_auth_screen_respository.dart';
import 'package:acs_lunch/app/utils/http_helper.dart';
import 'package:acs_lunch/constant/preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flushbar/flushbar.dart';
import 'loginmodel.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class Controller extends ControllerMVC {
  //final log = getLogger('template');
  factory Controller() {
    if (_this == null) _this = Controller._();
    return _this;
  }
  static Controller _this;

  Controller._();

  static Controller get controller => _this;
  // AppController appController;

  Map loginData = {"username": "", "password": ""};

  Model model = Model(DataAuthScreenRepository());
  //Router _router = Router();
  FocusNode get usernameNode => model.usernameNode;
  FocusNode get passwordNode => model.passwordNode;
  get isLoading => model.isLoading;
  get formKey => model.formKey;
  bool get isAutoValidateMode => model.isAutoValidateMode;
  get userNameController => model.userNameController;
  get passwordController => model.passwordController;
  get isInternetAvailable => model.isInternetAvailable;
  set isInternetAvailable(boolean) => model.isInternetAvailable = boolean;
  set isAutoValidateMode(boolean) => model.isAutoValidateMode = boolean;
  set isLoading(value) => model.isLoading = value;
  get loginUserName => model.loginUserName;
  set loginUserName(value) => model.loginUserName = value;

  get errorMessage => model.errorMessage;
  set errorMessage(value) => model.errorMessage = value;

  @override
  void initState() {
    //runs first, avoid using this unless mandatory
    super.initState();
    // appController = AppController.controller;
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
          model.isInternetAvailable = true;
        });
    });
    model.mySharedPreferences = await SharedPreferences.getInstance();
  }

  void onLoginPressed(BuildContext context) {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      setState(() {
        isLoading = true;
      });
      login(context);
    } else {
      setState(() {
        isAutoValidateMode = true;
      });
    }
  }

  void login(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    String params = base64.encode(
        utf8.encode(loginData["username"] + ":" + loginData["password"]));
    model.mySharedPreferences.setString(Preferences.auth_token, params);

    var response = await model.login();

    if (response['status'] == ResponseStatus.success) {
      var data = response['data']['user'];
      loginUserName = data['firstname'];
      model.mySharedPreferences
          .setString(Preferences.login_token, loginUserName);

      // List<Map> data =
      //     response['data'] != null ? response['data']['user'] : List();
      // data.forEach((item) {
      //   loginUserName = item['firstname'];
      //   // return name;
      // });
      Navigator.push(
        this.stateMVC.context,
        MaterialPageRoute(builder: (context) => Homescreen()),
      );
    } else {
      // print(response['message']);
      setState(() {
        isLoading = false;
      });
      Flushbar(
        message: response['message'],
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.red,
        ),
        duration: Duration(seconds: 3),
        leftBarIndicatorColor: Colors.red,
      )..show(context);
    }
  }
}
