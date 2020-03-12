import 'package:acs_lunch/constant/app_theme.dart';
import 'package:acs_lunch/constant/strings.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'logincontroller.dart';

class Loginscreen extends StatefulWidget {
  Loginscreen({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _LoginscreenState createState() => _LoginscreenState();
}

class _LoginscreenState extends StateMVC<Loginscreen> {
  _LoginscreenState() : super(Controller());
  Controller _controller;
  bool _passwordVisible = false;
  @override
  void initState() {
    //runs second
    super.initState();
    _controller = Controller.controller;

    _controller.init(); //use this
  }

  @override
  void dispose() {
    //runs first
    super.dispose();
  }

  Widget customSizedBox({double height}) {
    return SizedBox(
      height: height,
    );
  }

  TextStyle customTextStyle() {
    return TextStyle(
      color: AppColors.themeColor,
    );
  }

  InputDecoration customTextDecoration(
      String text, IconData icon, BuildContext context,
      {secure: false}) {
    return InputDecoration(
      labelStyle: TextStyle(color: Colors.grey),
      labelText: text,
      prefixIcon: Icon(icon, color: AppColors.themeColor),
      suffixIcon: secure == true
          ? IconButton(
              icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  semanticLabel:
                      _passwordVisible ? 'hide password' : 'show password',
                  color: AppColors.greyColorTemp),
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              })
          : null,
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.themeColor)),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.themeColor)),
      errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).errorColor)),
    );
  }

  Widget loginButton(BuildContext context) {
    // globals.context = context;
    return _controller.isLoading
        ? CircularProgressIndicator(
            strokeWidth: 1.5, backgroundColor: AppColors.white)
        : SizedBox(
            height: 45.0,
            width: double.infinity,
            child: RaisedButton(
              color: AppColors.themeColor,
              child: Text(
                Strings.loginButton,
                style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: Theme.of(context).textTheme.title.fontSize),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              onPressed: () {
                _controller.onLoginPressed(context);
              },
            ),
          );
  }

  Widget loginUi() {
    return Form(
        key: _controller.formKey,
        autovalidate: _controller.isAutoValidateMode,
        child: Center(
            child: Column(children: <Widget>[
          customSizedBox(height: 150.0),
          Container(
            height: 100.0,
            child: Image.asset("lib/assets/loginscreenlogo.png"),
          ),
          customSizedBox(height: 20.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _controller.userNameController,
                  enabled: true,
                  //   autofocus: true,
                  focusNode: _controller.usernameNode,
                  style: customTextStyle(),
                  cursorColor: Colors.blueAccent,
                  textInputAction: TextInputAction.next,
                  decoration: customTextDecoration(
                      Strings.usernameLabel, Icons.person, context),
                  textCapitalization: TextCapitalization.none,
                  onFieldSubmitted: (term) {
                    fieldFocusChange(context, _controller.usernameNode,
                        _controller.passwordNode);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return Strings.usernameEmptyMessage;
                    }
                  },
                  onSaved: (String value) {
                    _controller.loginData["username"] = value;
                  },
                ),
                TextFormField(
                  enabled: true,
                  controller: _controller.passwordController,
                  obscureText: !_passwordVisible,
                  textInputAction: TextInputAction.done,
                  style: customTextStyle(),
                  cursorColor: Colors.blueAccent,
                  focusNode: _controller.passwordNode,
                  decoration: customTextDecoration(
                      Strings.passwordLabel, Icons.lock, context,
                      secure: true),
                  validator: (value) {
                    if (value.isEmpty) {
                      return Strings.passwordEmptyMessage;
                    }
                  },
                  onSaved: (String value) {
                    _controller.loginData["password"] = value;
                  },
                  onFieldSubmitted: (term) {
                    _controller.passwordNode.unfocus();
                    _controller.onLoginPressed(context);
                  },
                ),
                customSizedBox(height: 15.0),
                Text(
                  _controller.errorMessage ?? "",
                  style: TextStyle(color: Theme.of(context).errorColor),
                ),
                customSizedBox(height: 2.0),
                loginButton(context),
                customSizedBox(height: 30.0),
              ],
            ),
          )
        ])));
  }

  @override
  Widget build(BuildContext context) {
    //  _controller.context = context;

    return Scaffold(
      body: SingleChildScrollView(child: loginUi()),
    );
  }
}

fieldFocusChange(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}
