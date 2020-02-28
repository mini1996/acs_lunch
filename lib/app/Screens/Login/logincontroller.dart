import 'dart:convert';
import 'package:acs_lunch/app/Screens/Home/homeview.dart';
import 'package:acs_lunch/app/data/repository/auth_screen/data_auth_screen_respository.dart';
import 'package:acs_lunch/app/utils/http_helper.dart';
import 'package:acs_lunch/constant/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flushbar/flushbar.dart';
import 'loginmodel.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:http/http.dart' as http;

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

  Model model=Model(DataAuthScreenRepository());
  //Router _router = Router();
  FocusNode get usernameNode => model.usernameNode;
  FocusNode get passwordNode => model.passwordNode;
  get isLoading => model.isLoading;
  get formKey => model.formKey;
  bool get isAutoValidateMode => model.isAutoValidateMode;
  get userNameController => model.userNameController;
  get passwordController => model.passwordController;

  set isAutoValidateMode(boolean) => model.isAutoValidateMode = boolean;
  set isLoading(value) => model.isLoading = value;


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
    _this = null;
    super.dispose();
  }

  init() async {
     model.mySharedPreferences =
        await SharedPreferences.getInstance();
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
    String params = base64.encode(utf8.encode(loginData["username"]+":"+loginData["password"]));
    model.mySharedPreferences.setString(Preferences.auth_token,params );
    var response = await model.login();
 
    if(response['status']==ResponseStatus.success){
Navigator.push( this.stateMVC.context,MaterialPageRoute(builder: (context) => Homescreen()), );
    }else{
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
    
 
    //return ;
    // var data = jsonEncode({
    //   "password": loginData["password"],
    //   "username": loginData["username"], 
    //   "grant_type": "password",
    // });
    // print('login data ${data}');
    // setState(() {
    //   isLoading = true;
    // });
    // SharedPreferences mySharedPreferences =
    //     await SharedPreferences.getInstance();
    // var response = await model.login(data);
    // print("responselogin${response}");
    // if (response["success"]) {
    //   if (response['data']['role_id'] == 4) {
    //     print(response['data']);
    //     var authToken = response['data']['access_token'];
    //     var userId = response['data']['id'];
    //     var refreshToken = response['data']['refresh_token'];
    //     print(refreshToken);
    //     var userRole = response['data']['role_id'];
    //     var userName = response['data']['firstname'];
    //     print("$authToken");
    //     mySharedPreferences.setString('authToken', authToken);
    //     mySharedPreferences.setString('idOfUser', userId.toString());
    //     mySharedPreferences.setString('refreshToken', refreshToken);
    //     mySharedPreferences.setString('userRole', userRole.toString());
    //     mySharedPreferences.setString('userName', userName.toString());
    //     setState(() {
    //       isLoading = false;
    //     });
    //     print("Login success. Taking to next page");
    //   // _router.navigate(Pages.fetchingScreen, this.stateMVC.context, {});
    //   } else {
    //     setState(() {
    //       isLoading = false;
    //       model.errorMessage = "Please use Warehouse Login";
    //     });
    //     userNameController.addListener(() {
    //       setState(() {
    //         model.errorMessage = null;
    //       });
    //     });
    //     passwordController.addListener(() {
    //       setState(() {
    //         model.errorMessage = null;
    //       });
    //     });
    //   }
    // } else {
    //   setState(() {
    //     isLoading = false;
    //     model.errorMessage = response["data"] != null
    //         ? response["data"]["errors"]["message"]
    //         : response["message"];
    //   });
    //   userNameController.addListener(() {
    //     setState(() {
    //       model.errorMessage = null;
    //     });
    //   });
    //   passwordController.addListener(() {
    //     setState(() {
    //       model.errorMessage = null;
    //     });
    //   });
   // }
  }
}
