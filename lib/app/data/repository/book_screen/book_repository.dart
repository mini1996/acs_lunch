import 'dart:convert';
import 'package:acs_lunch/app/utils/http_helper.dart';
import 'package:acs_lunch/constant/endpoints.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// OfflineHelper offlineHelper = OfflineHelper();
HttpHelper httpHelper = HttpHelper();

class LunchBookingRepository {
  bookLunch(Map data) async {
    return await httpHelper.request(HttpMethods.post,
        endPoint: Endpoints.lunchBookingUrl,
        authenticationRequired: true,
        data: json.encode(data));
  }

  cancelLunch() async {
    SharedPreferences mySharedPreferences;
    mySharedPreferences = await SharedPreferences.getInstance();
    String cancelid = mySharedPreferences.getInt('userid').toString();
    var cancelidUrl = Endpoints.lunchCancellingUrl + cancelid + ".json";
    return await httpHelper.request(HttpMethods.delete,
        endPoint: cancelidUrl, authenticationRequired: true);
  }

  getMenuItems() async {
    return await httpHelper.request(HttpMethods.get,
        endPoint: Endpoints.menuDisplayUrl,
        authenticationRequired: true,
        isAdmin: true);
  }

  lunchBookedMonthWiseEntries() async {
    var dateFormatter = DateFormat("yyyy-MM-dd");
    final currentDate = DateTime.now();
    var prevMonth = new DateTime(currentDate.year, currentDate.month - 1, 1);
    String requestFormat =
        "><${dateFormatter.format(prevMonth)}|${dateFormatter.format(currentDate)}";
    var fetchUrl = Endpoints.checkBookingUrl + requestFormat;
    // print(fetchUrl);
    return await httpHelper.request(HttpMethods.get,
        endPoint: fetchUrl, authenticationRequired: true);
  }

  checkLunchBooked() async {
    var now = new DateTime.now();
    var checkurl =
        Endpoints.checkBookingUrl + new DateFormat("yyyy-MM-dd").format(now);
    return await httpHelper.request(HttpMethods.get,
        endPoint: checkurl, authenticationRequired: true);
  }
}
