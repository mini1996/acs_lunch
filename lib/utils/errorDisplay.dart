import 'package:acs_lunch/constant/strings.dart';
import 'package:flutter/material.dart';


class ErrorDisplay extends StatelessWidget {
  Function callback = null;
  ErrorDisplay({Key key, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(Strings.errorMessage),
            SizedBox(
              height: 10,
            ),
            callback != null
                ? IconButton(
                    icon: Icon(
                      Icons.refresh,
                      size: 30,
                    ),
                    onPressed: () {
                      callback();
                    },
                  )
                : Container()
          ],
        ),
      )),
    );
  }
}
