import 'package:acs_lunch/app/domain/repository/auth_screen/auth_screen.respository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Model {
  Model(this.loginRepo);
  bool isLoading = false;
  bool isAutoValidateMode = false;
  FocusNode usernameNode;
  FocusNode passwordNode;
  String errorMessage;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  String loginUserName = "";
  int loginId;
  SharedPreferences mySharedPreferences;
  var internetSubscription;
  bool isInternetAvailable = true;
  DateTime backButtonPressTime;
  AuthScreenRepository loginRepo;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  login() async {
    return await loginRepo.loginUser();
  }
}
