import 'package:acs_lunch/app/data/repository/book_screen/book_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Model {
  // Model(LunchBookingRepository lunchBookingRepository);
  BuildContext context;
   bool isLoading = false;
   bool isBooked=false;
   bool isalreadyBooked=false;
   bool isCancelled=false;
  String errorMessage;
  SharedPreferences mySharedPreferences;
  int userID;
LunchBookingRepository bookRepo=LunchBookingRepository();
checkbooked() async{
return await bookRepo.checkUser();
  }

booking() async {
    return await bookRepo.bookLunch();
  }
  cancelbooked() async{
    return await bookRepo.cancelLunch();
  }
menuitems() async{
   return await bookRepo.getmenuitems();
}

}
