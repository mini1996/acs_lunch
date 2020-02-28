import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'logger.dart';


class Loader {
  static final log = getLogger('Loader');
  static Widget loader(context) {
    return SpinKitCircle(
      color: Theme.of(context).primaryColor,
      size: 50.0,
    );
  }

  static ProgressDialog pr;
  static showFullScreenLoader(context, {isDismissible = true, message}) async {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal,
        isDismissible: isDismissible,
        showLogs: true);
    pr.style(
      message: message,
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: loader(context),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
    pr.show();
  }

  static hideFullScreenLoader() async {
    await pr.hide();
  }

  static isFullScreenLoading() {
    return pr.isShowing();
  }

  static openLoadingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return loader(context);
      },
    );
  }
}

enum LoaderStatus { loading, loaded, empty, error }
