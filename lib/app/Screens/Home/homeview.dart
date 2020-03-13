import 'package:acs_lunch/constant/app_theme.dart';
import 'package:acs_lunch/utils/loader.dart';
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

        lastMonthSpecialsData.forEach((data) {
          lastMonthSpecialsDataList.add(Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    width: 80,
                    child: Text(
                      data["name"],
                      style: TextStyle(
                        color: AppColors.themeColor,
                        height: 1.2,
                      ),
                    )),
                Text(
                  data["count"].toString(),
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
                    width: 80,
                    child: Text(
                      data["name"],
                      style: TextStyle(
                        color: AppColors.themeColor,
                        height: 1.2,
                      ),
                    )),
                Text(
                  data["count"].toString(),
                  style: TextStyle(color: Colors.black, height: 1.2),
                ),
              ]));
        });
        //populate data
        Widget cardUi(
            String monthName, String lunchCount, int pay, List dataList) {
          return Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                  side: BorderSide(width: 3, color: AppColors.themeColor)),
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
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          Row(
                            children: dataList,
                          )
                        ])
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
              elevation: 5.0,
              leading: Icon(Icons.home),
              title: Row(children: <Widget>[
                Text('Welcome' + "  " + _controller.loginUser)
              ]),
            ),
            body: homeUi(),
            //
            floatingActionButton:
                _controller.loaderStatus == LoaderStatus.loaded
                    ? FloatingActionButton.extended(
                        onPressed: () {
                          _controller.navigationPage(context);
                        },
                        backgroundColor: AppColors.themeColor,
                        icon: Icon(Icons.fastfood),
                        label: Text("Go to Lunch Booking"),
                      )
                    : null));
  }
}
