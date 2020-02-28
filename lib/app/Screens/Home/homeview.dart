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

  @override
  Widget build(BuildContext context) {
 //  _controller.context = context;
 return 
    WillPopScope(
    onWillPop: () async {
          Future.value(
              false); 
        },
    child:  Scaffold(
       appBar: AppBar(
        centerTitle: true,
              backgroundColor: Colors.lightBlue,
            elevation: 5.0,
             leading:  Icon(Icons.home),
              title: Row(
             children:<Widget>[
                   Text('Home'),
                ]
              ),  
              
            ),
      body:  new Container(
        padding: new EdgeInsets.all(32.0),
        child: new Center(
          child: new Column(
            children: <Widget>[
              new Card(
                
                child: new Container(
                  height: 150.0,
                  padding: new EdgeInsets.all(32.0),
                  child: new Column(
                    children: <Widget>[
                      
                      new Text(_controller.currentmonthname,
                      style: TextStyle(
        color: Colors.blue,
      ),),
                      new Text('How are you?')
                    ],
                  ),
                ),
              ),
              new Card(
                child: new Container(
                  height: 150.0,
                  padding: new EdgeInsets.all(32.0),
                  child: new Column(
                    children: <Widget>[
                      new Text('Hello World'),
                      new Text('How are you?')
                    ],
                  ),
                ),
              ),
         ],)
       )
      ),
       // 
     floatingActionButton: new FloatingActionButton.extended(
  onPressed: () {
    _controller.navigationPage(context);
    },
  backgroundColor: Colors.lightBlue,
  icon: Icon(Icons.fastfood),
  
  label: Text("Go to Lunch Booking"),
),
     ) );
  }
}
