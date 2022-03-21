import 'dart:async';
import 'package:acs_lunch/constant/app_theme.dart';
import 'package:acs_lunch/utils/loader.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:ntp/ntp.dart';
import 'homecontroller.dart';

class Homescreen extends StatefulWidget {
  Homescreen({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends StateMVC<Homescreen> {
  _HomescreenState() : super(Controller());
  Controller _controller;
  var deviceday;
  var actualday;
  Timer timer;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  displayNotification() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description',
        importance: Importance.Max);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    DateTime now = DateTime.now();
    var daynow = new DateTime.now();
    String startDay = daynow.day.toString();
    print(startDay);
    print("--");
    String formattedTime = DateFormat.Hm().format(now);
    if (formattedTime.compareTo("10:30") == 0) {
      await flutterLocalNotificationsPlugin.show(
          0,
          "AcsLunch",
          "Hey buddy! Please book your lunch if not booked",
          //DateTime.now().add(Duration(seconds: 5)),
          NotificationDetails(
              androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics));
    } else {
      print("not match");
    }
    if (startDay.compareTo("1") == 0) {
      if (formattedTime.compareTo("10:00") == 0) {
        await flutterLocalNotificationsPlugin.show(
            0,
            "AcsLunch",
            "Hey buddy! Please pay for your last month lunch if not paid",
            NotificationDetails(
                androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics));
        print("matchessssssssssssssssss");
      } else {
        print("not matched tym");
      }
    } else {
      print("not matched datesss");
    }
  }

  @override
  void initState() {
    //runs second
    super.initState();
    _controller = Controller.controller;
    _controller.init();
    //-------------------- Initialization Code---------------------
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        AndroidInitializationSettings('applogo');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    // timer = Timer.periodic(
    //     Duration(minutes: 1), (Timer t) => displayNotification());
    // displayNotification();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    //--------------------------------------

    //setState(() {});
  }

  @override
  void dispose() {
    //runs first
    timer?.cancel();
    super.dispose();
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      print("np:$payload");
    }
    //  _controller.navigationPage(context);
    // await Navigator.push(
    //   context, new MaterialPageRoute(builder: (context) => new Homescreen()));
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    await showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () {},
          )
        ],
      ),
    );
  }

  void redflushbar(BuildContext context, String msg) {
    Flushbar(
      message: msg,
      icon: Icon(
        Icons.info_outline,
        size: 28.0,
        color: Colors.red,
      ),
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: Colors.red,
    )..show(context);
  }

  Widget homeUi() {
    switch (_controller.loaderStatus) {
      case LoaderStatus.loading:
        return Center(
          child: Loader.loader(context),
        );
        break;
      case LoaderStatus.loaded:
        List<dynamic> lastMonthData = _controller.dateWiseResults['lastMonth'];
        List<dynamic> currentMonthData =
            _controller.dateWiseResults['thisMonth'];
        List<dynamic> lastMonthSpecialsData =
            _controller.dateWiseResults['lastMonthSpecials'];
        List<dynamic> currentMonthSpecialsData =
            _controller.dateWiseResults['thisMonthSpecials'];

        List<Widget> lastMonthSpecialsDataList = [];

        // print(now);
        lastMonthSpecialsData.forEach((data) {
          lastMonthSpecialsDataList.add(Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  data["name"],
                  style: TextStyle(
                    color: AppColors.themeColor,
                    height: 1.2,
                  ),
                ),
                Text(
                  data["count"].toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, height: 1.2),
                ),
              ]));
        }); //populate data

        List<Widget> currentMonthSpecialsDataList = [];

        currentMonthSpecialsData.forEach((data) {
          currentMonthSpecialsDataList.add(Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    // width: 80,
                    child: Text(
                  data["name"],
                  style: TextStyle(
                    color: AppColors.themeColor,
                    height: 1.2,
                  ),
                )),
                Text(data["count"].toString(),
                    style: TextStyle(color: Colors.black, height: 1.2),
                    textAlign: TextAlign.center),
              ]));
        });
        //populate data
        Widget cardUi(
            String monthName, String lunchCount, int pay, List dataList) {
          return Card(
              elevation: 3.0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                  side: BorderSide(width: 1, color: AppColors.grey)),
              child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(children: <Widget>[
                    Text(
                      monthName,
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 20.0),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(children: <Widget>[
                                Text(
                                  'Bookings',
                                  style: TextStyle(
                                    color: AppColors.themeColor,
                                  ),
                                ),
                                Text(
                                  lunchCount,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ]),
                              SizedBox(width: 20),
                              Column(children: <Widget>[
                                Text(
                                  'Payable',
                                  style: TextStyle(
                                    color: AppColors.themeColor,
                                  ),
                                ),
                                Text(
                                  pay.toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ]),
                              SizedBox(width: 20),
                              Wrap(
                                spacing: 20,
                                children: dataList,
                              )
                            ]))
                  ])));
        }
        return Container(
            child: new RefreshIndicator(
          color: AppColors.themeColor,
          displacement: 40,
          onRefresh: _controller.fetchLunchCountMonthWise,
          child: new ListView(children: <Widget>[
            cardUi(
                _controller.previousmonthname,
                lastMonthData.length.toString(),
                (lastMonthData.length * 10),
                lastMonthSpecialsDataList),
            cardUi(
                _controller.currentmonthname,
                currentMonthData.length.toString(),
                (currentMonthData.length * 10),
                currentMonthSpecialsDataList),
          ]),
        ));

      case LoaderStatus.error:
        return Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: Text(_controller.errorMessage ?? ""),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    //SharedPreferences mySharedPreferences;
    return WillPopScope(
        onWillPop: _controller.onWillPop,
        child: Scaffold(
            key: _controller.scaffoldKey,
            appBar: AppBar(
                //[[[[centerTitle: true,
                backgroundColor: AppColors.themeColor,
                leading: Icon(Icons.home),
                title: Text('Welcome  ${_controller.loginUser ?? ""}')),
            body: _controller.isInternetAvailable
                ? homeUi()
                : Center(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                      child: Text("Please check your internet connection"),
                    ),
                  ),
            //

            floatingActionButton: _controller.loaderStatus ==
                        LoaderStatus.loaded &&
                    _controller.isInternetAvailable
                ? FloatingActionButton.extended(
                    onPressed: () async {
                      // _controller.loaderStatus == LoaderStatus.loading;
                      DateTime deviceDate = DateTime.now().toLocal();
                      DateTime actualDate = await NTP.now();

                      setState(() {
                        deviceday =
                            new DateFormat("dd_MM_yyyy").format(deviceDate);
                        actualday =
                            new DateFormat("dd_MM_yyyy").format(actualDate);
                      });
                      print(DateTime.now().minute);
                      DateTime currentDate = DateTime.now();
                      if ((actualday.compareTo(deviceday)) == 0) {
                        if ((currentDate.isAfter(DateTime(
                                currentDate.year,
                                currentDate.month,
                                currentDate.day,
                                1,
                                0,
                                0))) &&
                            (currentDate.isBefore(DateTime(
                                currentDate.year,
                                currentDate.month,
                                currentDate.day,
                                11,
                                20,
                                0)))) {
                          _controller.navigationPage(context);
                        } else {
                          redflushbar(context, "Time up!");
                        }
                      } else {
                        redflushbar(
                            context, "Ensure you have correct device date!");
                      }
                    },
                    backgroundColor: AppColors.themeColor,
                    icon: Icon(Icons.fastfood),
                    label: Text("Go to Lunch Booking"))
                : null));
  }
}
