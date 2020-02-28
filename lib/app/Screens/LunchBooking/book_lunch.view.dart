import 'package:flutter/material.dart';
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
String menuValue ;

  @override
  void initState() {
    //runs second
    super.initState();
    _controller = Controller.controller;
    _controller.fetchmenuitems(context);
  
    _controller.init(); 
  //   print(_controller.isalreadyBooked);
  // if(_controller.isalreadyBooked==true)
  //       {
          
  //        existcard();
  //       }
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

  Widget lunchmenu() {
   return DropdownButton<String>(
     isExpanded: true,
    value:menuValue ,
    icon: Icon(Icons.arrow_drop_down),
    iconSize: 24,
    elevation: 16,
    style: TextStyle(
      color: Colors.black
    ), 
    underline: Container(
      height: 2,
      color: Colors.blue,
    ),
     
    
    items:  _controller.data[40]['possible_values'].map((item) {
      print(item);
          return new DropdownMenuItem(
           child: Center(
             child:
           Container(
             height:50.0,
           child: Padding(
             padding: EdgeInsets.fromLTRB(10, 10,10,10),
        child:Column(
               children: <Widget>[
                 SizedBox(
                     width: 200.0,
                child: Text(item['label']),
               

                 )
               ] ,)
           )) ),
          value: item['value'].toString(),
         
      );
     } )
      .toList(),
      onChanged: (String newValue)  {
      setState(() {
     menuValue  = newValue;
      });
    },
   
  );
  }
  Widget existcard()
  {
    return  _controller.isalreadyBooked
        ?  Card(
        elevation: 10.0,
                child: new Container(
                  width: 300.0,
                  height: 40.0,
                 padding: new EdgeInsets.all(12.0),
                  child: new Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                       new Text("Your lunch is already Booked",
                      style: TextStyle(
        color: Colors.blue,
      ),),
      
      IconButton(
        padding: EdgeInsets.only(bottom:100.0),
        icon: Icon(Icons.cancel,color: Colors.red,),
        
        tooltip: 'cancel your lunch',
        onPressed: () {
          _controller.lunchcancelDialog(context);
        },
      ),
             ],
                  )
                  )
                )
       : Container();
       
  }
  Widget successcard()
  {
    return  _controller.isBooked
        ?  Card(
        elevation: 10.0,
                child: new Container(
                  width: 300.0,
                  height: 40.0,
                 padding: new EdgeInsets.all(12.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                       new Text("Your lunch is Booked",
                      style: TextStyle(
        color: Colors.blue,
      ),),
       IconButton(
        padding: EdgeInsets.only(bottom:100.0),
        icon: Icon(Icons.cancel,color: Colors.red,),
        
        tooltip: 'cancel your lunch',
        onPressed: () {
          _controller.lunchcancelDialog(context);
        },
      ),
             ],
                  ),
                )
       ): existcard()
       ;
              
  }
  Widget cancelButton(BuildContext context){
   return FloatingActionButton.extended(
          
          elevation: 10.0,
  onPressed: () {
   // _controller.onBookingPressed(context);
    },
  backgroundColor: Colors.redAccent,
  icon: Icon(Icons.cancel),
  
  label: Text("Cancel"),
);

  }
  Widget floatingButton(BuildContext context) {
    // globals.context = context;
    
    return _controller.isLoading ? 
new Center(child:  CircularProgressIndicator(
            strokeWidth: 5, backgroundColor: Colors.cyan) )
        
    
        :new FloatingActionButton.extended(
          
          elevation: 10.0,
  onPressed: () {
    _controller.onBookingPressed(context);
    },
  backgroundColor: Colors.lightBlue,
  icon: Icon(Icons.fastfood),
  
  label: Text("Book"),
)
 ;
        }
  @override
  Widget build(BuildContext context) {
  return  Scaffold(
     appBar: AppBar(
        centerTitle: true,
              backgroundColor: Colors.lightBlue,
            elevation: 5.0,
             leading:  Icon(Icons.fastfood),
                title: Row(
                   children:<Widget>[
                   Text('Book your lunch'),
                ]
              ),
            
            ),
body:GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());  
       },
       child:
       SingleChildScrollView(
        child:Column(
    
        children: <Widget>[
          customSizedBox(height: 70.0),
        lunchmenu(),
         customSizedBox(height: 50.0),
        successcard(),
       
        ],
      )),
),
     // 
     floatingActionButton: Align(
          child:floatingButton(context) ,
          alignment: Alignment(1, 0.7)),
       // 
     
  );
  }
}

  
