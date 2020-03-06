import 'package:acs_lunch/constant/app_theme.dart';
import 'package:acs_lunch/utils/loader.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'homecontroller.dart';
import 'dart:io';

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
        return Container(
            child: new RefreshIndicator(
                color: AppColors.themeColor,
                displacement: 40,
                onRefresh: _controller.fetchLunchCountMonthWise,
                child: new ListView(children: <Widget>[
                  Card(
                      elevation: 10.0,
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(_controller.previousmonthname,
                                      style:
                                          TextStyle(color: Colors.blueAccent)),
                                  Text(lastMonthData.length.toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 34.0))
                                ],
                              ),
                              Material(
                                  color: AppColors.themeColor,
                                  borderRadius: BorderRadius.circular(24.0),
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Icon(Icons.date_range,
                                        color: Colors.white, size: 30.0),
                                  )))
                            ]),
                      )),
                  Card(
                      elevation: 10.0,
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(_controller.currentmonthname,
                                      style:
                                          TextStyle(color: Colors.blueAccent)),
                                  Text(currentMonthData.length.toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 34.0))
                                ],
                              ),
                              Material(
                                  color: AppColors.themeColor,
                                  borderRadius: BorderRadius.circular(24.0),
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Icon(Icons.date_range,
                                        color: Colors.white, size: 30.0),
                                  )))
                            ]),
                      )),
                ])));

      case LoaderStatus.error:
        return Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: Text(_controller.errorMessage),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _controller.onWillPop,
        child: Scaffold(
            key: _controller.scaffoldKey,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: AppColors.themeColor,
              elevation: 5.0,
              leading: Icon(Icons.home),
              title: Row(children: <Widget>[
                Text('Home'),
              ]),
            ),
            body: homeUi(),
            //
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                _controller.navigationPage(context);
              },
              backgroundColor: AppColors.themeColor,
              icon: Icon(Icons.fastfood),
              label: Text("Go to Lunch Booking"),
            )));
  }
}
