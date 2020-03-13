import 'package:acs_lunch/app/Screens/LunchBooking/book_lunch.model.dart';
import 'package:acs_lunch/app/utils/http_helper.dart';
import 'package:acs_lunch/constant/app_theme.dart';
import 'package:acs_lunch/utils/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'book_lunch.controller.dart';

class BookLunchScreen extends StatefulWidget {
  BookLunchScreen({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _BookLunchScreenState createState() => _BookLunchScreenState();
}

class _BookLunchScreenState extends StateMVC<BookLunchScreen> {
  _BookLunchScreenState() : super(Controller());
  Controller _controller;

  @override
  void initState() {
    //runs second
    super.initState();
    _controller = Controller.controller;

    _controller.init();
  }

  Model model = Model();

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

  Widget lunchmenu() {
    return Center(
        child: Column(children: <Widget>[
      Text(
        "Select one of the Menu Items",
        style:
            TextStyle(color: AppColors.themeColor, fontWeight: FontWeight.w500),
      ),
      customSizedBox(height: 20.0),
      Container(
          width: 300.0,
          height: 50.0,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  width: 3.0,
                  style: BorderStyle.solid,
                  color: AppColors.themeColor),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          ),
          child: DropdownButtonHideUnderline(
              child: DropdownButton(
            // isExpanded: true,
            value: _controller.selectedLunchOption,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: AppColors.themeColor),
            items: _controller.options.map<DropdownMenuItem>((item) {
              print(item);
              return new DropdownMenuItem(
                child: Center(
                    child: Container(
                  height: 50.0,
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: 200.0,
                            child: Text(
                              item['label'],
                              style: TextStyle(
                                  color: AppColors.themeColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.0),
                            ),
                          )
                        ],
                      )),
                )),
                value: item,
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _controller.selectedLunchOption = newValue;
              });
            },
          )))
    ]));
  }

  Widget extraItems() {
    return Center(
        child: Column(children: <Widget>[
      Text(
        "Select one of the Optional Items",
        style:
            TextStyle(color: AppColors.themeColor, fontWeight: FontWeight.w500),
      ),
      customSizedBox(height: 10.0),
      Container(
        constraints: BoxConstraints(
          maxHeight: 100.0,
        ),
        child: SingleChildScrollView(
          child: MultiSelectChip(
            _controller.specialOptions,
            onSelectionChanged: (selectedList) {
              setState(() {
                _controller.selectedExtraMenus = selectedList;
              });
            },
          ),
        ),
      ),
    ]));
  }

  Widget existcard() {
    return _controller.isalreadyBooked && !_controller.isLoading
        ? Center(
            child: Card(
                elevation: 10.0,
                child: new Container(
                  width: 300.0,
                  height: 120.0,
                  child: ListTile(
                    title: Text(
                      "Your lunch is Booked",
                      style: TextStyle(
                          color: AppColors.themeColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 15.0),
                    ),
                    subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "\nYou have booked:",
                            style: TextStyle(
                                color: AppColors.themeColor,
                                //fontWeight: FontWeight.w500,
                                fontSize: 15.0),
                          ),
                          // Text(
                          //   _controller.selectedLunchOption['label'].toString(),
                          //   style: TextStyle(
                          //       color: AppColors.themeColor,
                          //       //fontWeight: FontWeight.w500,
                          //       fontSize: 15.0),
                          // ),
                          Text(
                            _controller.selectedExtraItemValue,
                            style: TextStyle(
                                color: AppColors.themeColor,
                                //fontWeight: FontWeight.w500,
                                fontSize: 15.0),
                          )
                        ]),
                  ),
                )))
        : Container();
  }

  Widget cardMessage() {
    return Card(
        elevation: 10.0,
        child: new Container(
          width: 300.0,
          height: 120.0,
          child: ListTile(
            title: Text(
              "Your lunch is Booked",
              style: TextStyle(
                  color: AppColors.themeColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 15.0),
            ),
            subtitle:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "\nYou have booked:",
                style: TextStyle(
                    color: AppColors.themeColor,
                    //fontWeight: FontWeight.w500,
                    fontSize: 15.0),
              ),
              Text(
                _controller.selectedLunchOption['label'].toString(),
                style: TextStyle(
                    color: AppColors.themeColor,
                    //fontWeight: FontWeight.w500,
                    fontSize: 15.0),
              ),
              Text(
                _controller.selectedExtraItemValue,
                style: TextStyle(
                    color: AppColors.themeColor,
                    //fontWeight: FontWeight.w500,
                    fontSize: 15.0),
              )
            ]),
          ),
        ));
  }

  // Widget   successcard() {
  //   return _controller.isBooked && !_controller.isLoading
  //       ? cardMessage()
  //       : existcard();
  // }

  Widget bookOrCancelButton() {
    return _controller.isalreadyBooked
        ? new FloatingActionButton.extended(
            elevation: 10.0,
            onPressed: () {
              _controller.lunchcancelDialog(context);
            },
            backgroundColor: Colors.red,
            icon: Icon(Icons.fastfood),
            label: Text("Cancel Lunch"),
          )
        : new FloatingActionButton.extended(
            elevation: 10.0,
            onPressed: () {
              _controller.onBookingPressed(context);
              setState(() {
                _controller.isalreadyBooked = true;
              });
            },
            backgroundColor: AppColors.themeColor,
            icon: Icon(Icons.fastfood),
            label: Text("Book Lunch"),
          );
  }

  Widget floatingButton(BuildContext context) {
    return _controller.isLoading
        ? new Center(
            child: SpinKitCircle(
              color: Colors.blue,
              size: 50.0,
            ),
          )
        : bookOrCancelButton();
  }

  Widget lunchUI() {
    switch (_controller.loaderStatus) {
      case LoaderStatus.loading:
        return Center(
          child: SpinKitCircle(
            color: Colors.blue,
            size: 50.0,
            duration: const Duration(seconds: 10),
          ),
        );
        break;
      case LoaderStatus.loaded:
        return _controller.isalreadyBooked
            ? existcard()
            : SingleChildScrollView(
                child: Column(
                children: <Widget>[
                  customSizedBox(height: 50.0),
                  lunchmenu(),
                  customSizedBox(height: 50.0),
                  extraItems(),
                  customSizedBox(height: 20.0),
                  //  successcard(),
                ],
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
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.themeColor,
          elevation: 5.0,
          title: Text('Book your lunch'),
        ),
        body: lunchUI(),
        floatingActionButton: _controller.loaderStatus == LoaderStatus.loaded
            ? floatingButton(context)
            : null);
  }
}

class MultiSelectChip extends StatefulWidget {
  final List extrasList;
  final Function(List) onSelectionChanged;

  MultiSelectChip(this.extrasList, {this.onSelectionChanged});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List selectedChoices = List();

  _buildChoiceList() {
    List<Widget> choices = List();

    widget.extrasList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item["label"]),
          elevation: 5.0,
          selected: selectedChoices.contains(item),
          selectedColor: AppColors.themeColor,
          backgroundColor: Colors.grey,
          labelStyle: TextStyle(color: Colors.white, fontSize: 15.0),
          onSelected: (selected) {
            if (selectedChoices.contains(item)) //alerady selected
            {
              setState(() {
                selectedChoices.remove(item);
              });
            } else {
              selectedChoices.clear();
              setState(() {
                selectedChoices.length < 1 ? selectedChoices.add(item) : null;
              });
            }
            widget.onSelectionChanged(selectedChoices);
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
