import 'package:acs_lunch/app/data/repository/book_screen/book_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Model {
  
  BuildContext context;
   bool isLoading = false;
  String errorMessage;
  SharedPreferences mySharedPreferences;
 String currentmonthname="";
  String previousmonthname="";
LunchBookingRepository bookRepo=LunchBookingRepository();
bookingList() async{
return await bookRepo.bookingList();
  }


}