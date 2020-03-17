import 'package:acs_lunch/constant/app_theme.dart';
import 'package:acs_lunch/utils/loader.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                  side: BorderSide(width: 2, color: AppColors.themeColor)),
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
                ])));

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

            floatingActionButton:
                _controller.loaderStatus == LoaderStatus.loaded
                    ? FloatingActionButton.extended(
                        onPressed: () {
                          if ((DateTime.now().hour >= 1) &&
                              (DateTime.now().hour <= 10)) {
                            _controller.navigationPage(context);
                          } else {
                            redflushbar(context, "Time up !");
                          }
                        },
                        backgroundColor: AppColors.themeColor,
                        icon: Icon(Icons.fastfood),
                        label: Text("Go to Lunch Booking"),
                      )
                    : null));
  }
}
