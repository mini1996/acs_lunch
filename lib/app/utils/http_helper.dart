import 'dart:convert';

import 'package:acs_lunch/constant/endpoints.dart';
import 'package:acs_lunch/constant/preferences.dart';
import 'package:acs_lunch/constant/settings.dart';
import 'package:acs_lunch/constant/strings.dart';
import 'package:acs_lunch/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

import 'db_helper.dart';


enum HttpMethods { get, post, put, delete, authentication }
enum ResponseStatus { success, error, conflict }

class HttpHelper {
  factory HttpHelper() {
    if (_this == null) _this = HttpHelper._();
    return _this;
  }
  final log = getLogger('Http helper');
  static HttpHelper _this;
  SharedPreferences sharedPreferences;
  String authToken;
  
  // FlutterCrashlytics crashlytics = FlutterCrashlytics();

  HttpHelper._();

  getToken() async {
    sharedPreferences = await SharedPreferences.getInstance();
    authToken = sharedPreferences.getString(Preferences.auth_token);
    if (authToken != null) {
      log.v("token $authToken");
      return authToken;
    } else {
      return null;
    }
  }
  getAdminToken() async{
     
    return "YXBpX3VzZXI6QWNzQDIwMTc=";
  }

  provideResponse(
      {success = false,
      data,
      message = "No message present",
      ResponseStatus status}) {
    Map responseModified = {
      "success": success,
      "message": message,
      "data": data,
      "status": status ?? ResponseStatus.error
    };
    log.d("modified response is ${responseModified}");
    return responseModified;
  }

  isNetworkAvailable() async {
    Map connectionStatus;
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      connectionStatus = {"status": true, "connectionType": "mobile"};
      return connectionStatus;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      connectionStatus = {"status": true, "type": "wifi"};
      return connectionStatus;
    } else {
      connectionStatus = {"status": false, "type": null};
      return connectionStatus;
    }
  }

  replaceToken() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var oldRefreshToken =
        sharedPreferences.getString(Preferences.refresh_token);
    log.d("refresh token is $oldRefreshToken");
    if (oldRefreshToken == null) {
      log.d("refresh token failed");
      logout();
      return false;
    }
    var data = {
      "refresh_token": oldRefreshToken,
      "grant_type": "refresh_token"
    };
    var response = await authRequest(
        endPoint: Endpoints.refreshToken, data: json.encode(data));
    log.d("new refresh token response $response");
    if (response['success']) {
      var authToken = response['data']['access_token'];
      var refreshToken = response['data']['refresh_token'];
      sharedPreferences.setString(Preferences.auth_token,
          authToken); //replace the token in shared preferences
      sharedPreferences.setString(Preferences.refresh_token,
          refreshToken); //replace the refresh token in shared preferences
      return true;
    } else {
      log.d("refresh token failed");
      logout();
      var error =
          response['data'] != null ? (response['data']['error'] ?? "") : "";
      if (error == "invalid_grant") {
        logout();
      }
      return false;
    }
  }

  logout() async {
    sharedPreferences.setString(Preferences.auth_token, null);
    await DatabaseHelper.instance.deleteDb;
   // Globals().navigatorKey.currentState.pushReplacementNamed('/loginScreen');
  }

  catchError(error) {
    // crashlytics.log("error has been caught at httpservices:$error ");
    if (error == null ||
        error.message == null ||
        error.message.runtimeType == String ||
        error.message["statuscode"] != 400 ||
        error.message["message"] == null ||
        error.message["message"]["errors"] == null) {
      return provideResponse(
          success: false,
          message: Strings.errorMessage,
          status: ResponseStatus.error);
    } else {
      return provideResponse(
          success: false,
          message: error.message["message"]["errors"]["message"],
          status: ResponseStatus.error);
    }
  }

  request(HttpMethods requestType,
      {baseUrl = Settings.baseUrl,
      endPoint = "",
      data,
      authenticationRequired = false,
      tryCount = 0,isAdmin=false}) async {
    var endPointURL = baseUrl + endPoint;
    log.d("$requestType url is $endPointURL data is $data");
    var networkAvailability = await isNetworkAvailable();

    if (networkAvailability["status"] == true) {
      var token = isAdmin?await getAdminToken():await getToken();
      print("set $token");
      // token = "8c0253b8a5a616a864d01d8e7f91a33285971cf0";
      if (token != null || !authenticationRequired) {
        try {
          var response;
          Map<String, String> header = {"Content-Type": "application/json"};
          if (authenticationRequired) header["Authorization"] = "Basic $token";
          // print("data${data}");
          // print("header${header}");
          switch (requestType) {
            case HttpMethods.get:
              response = await http
                  .get(endPointURL, headers: header)
                  .timeout(Settings.httpRequestTimeout);
              break;
            case HttpMethods.post:
              response = await http
                  .post(endPointURL, body: data, headers: header)
                  .timeout(Settings.httpRequestTimeout);
              break;
            case HttpMethods.put:
              response = await http.put(endPointURL, body: data, headers: header).timeout(Settings.httpRequestTimeout);
              break;
            case HttpMethods.delete:
              response = await http.delete(endPointURL, headers:header).timeout(Settings.httpRequestTimeout);
              break;
            default:
              throw Exception();
          }

          log.d(
              "response is ${response.statusCode} and response body is  ${response.body}");
   log.d("status ${response.statusCode}");
          switch (response.statusCode) {
         
            case 200:
              {
                var extractData;
               if(response.body=="")
                 extractData=null;
                 else
                 extractData = json.decode(response.body);
                return provideResponse(
                    success: true,
                    data: extractData,
                    status: ResponseStatus.success);
              }
              break;
            case 401:
              {
                //TODO: refresh token functionality
                var replaceTokenResponse = await replaceToken();
                if (replaceTokenResponse) {
                  tryCount++;
                  if (tryCount < 3) {
                    return request(requestType,
                        baseUrl: baseUrl,
                        endPoint: endPoint,
                        data: data,
                        authenticationRequired: authenticationRequired,
                        tryCount: tryCount);
                  } else {
                    //TODO: logout
                  }
                } else {
                  // log.d("replace token response is not good");
                  //TODO: logout
                  throw Exception();
                }
              }
              break;
            case 403:
              {
                //TODO: refresh token functionality
                tryCount++;
                if (tryCount < 3) {
                  return request(requestType,
                      baseUrl: baseUrl,
                      endPoint: endPoint,
                      data: data,
                      authenticationRequired: authenticationRequired,
                      tryCount: tryCount);
                } else {
                  //TODO: logout
                }
              }
              break;
            case 409:
              {
                log.d('yes5');
                var extractdata = json.decode(response.body);
                return provideResponse(
                    success: false,
                    data: extractdata,
                    status: ResponseStatus.conflict);
              }
              break;
            case 201:
              {
                log.d('yes4');
                //same as for 200
                var extractdata = json.decode(response.body);
                return provideResponse(
                    success: true,
                    data: extractdata,
                    status: ResponseStatus.success);
              }
              break;
            default:
              {
                   log.d("yes status ${response.statusCode}");
                throw Exception({
                  "statuscode": response.statusCode,
                  "message": json.decode(response.body)
                });
              }
          }
        } catch (e) {
          log.d("yes8");
          return catchError(e);
        }
      } else {
        //token is null
        //TODO:logout
        log.d('yes2');
        return provideResponse(
            success: false,
            message: Strings.errorMessage,
            status: ResponseStatus.error);
      }
    } else {
      log.d('yes3');
      return provideResponse(
          success: false,
          message: Strings.internetNotAvailable,
          status: ResponseStatus.error);
    }
  }

  authRequest({baseUrl = Settings.baseUrl, endPoint = "", data}) async {
    var endPointURL = baseUrl + endPoint;
    print("endPointURL $endPointURL body  ${data.runtimeType}");
    var networkAvailability = await isNetworkAvailable();
    print("network $networkAvailability");
    if (networkAvailability["status"] == true) {
      try {
        final response = await http.post(endPointURL, body: data, headers: {
          // "Accept": "application/json"
          "Content-Type": "application/json",
        }).timeout(Settings.httpRequestTimeout);

        print(
            "$endPoint response is ${response.statusCode} and body ${response.body}");
        switch (response.statusCode) {
          case 200:
            {
              var extractdata = json.decode(response.body);
              return provideResponse(
                  success: true,
                  data: extractdata,
                  status: ResponseStatus.success);
            }
            break;
          case 401:
            {
              var extractdata = json.decode(response.body);
              return provideResponse(
                  success: false,
                  data: extractdata,
                  status: ResponseStatus.error);
            }
            break;
          case 403:
            {
              var extractdata = json.decode(response.body);
              return provideResponse(
                  success: false,
                  data: extractdata,
                  status: ResponseStatus.error);
            }
            break;
          default:
            {
              var extractdata = json.decode(response.body);
              return provideResponse(
                  success: false,
                  data: extractdata,
                  status: ResponseStatus.error);
            }
        }
      } catch (e) {
        print("Some exception occured $e");
        return provideResponse(
            success: false,
            message: e.toString(),
            status: ResponseStatus.error);
      }
    } else {
      //network is not available
      //TODO: offline implementation here
      return provideResponse(
          success: false,
          message: Strings.internetNotAvailable,
          status: ResponseStatus.error);
    }
  }
}
