import 'package:flutter/material.dart';

class DialogHelper {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static advancedAlertDialog(context,
      {title = "",
      message = "",
      yesButtonTitle = "OK",
      yesButtonAction,
      noButtonTitle = "",
      noButtonAction}) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              noButtonTitle != null
                  ? FlatButton(
                      child: Text(noButtonTitle,
                          style: TextStyle(
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme
                                .primary,
                          )),
                      onPressed: () {
                        noButtonAction();
                      })
                  : null,
              yesButtonTitle != null
                  ? FlatButton(
                      child: Text(yesButtonTitle,
                          style: TextStyle(
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme
                                .primary,
                          )),
                      onPressed: () {
                        yesButtonAction();
                      })
                  : null,
            ],
          ),
        );
      },
    );
  }

  static displayDialogWithTextField(BuildContext context,
      {label,
      hint,
      String initialValue = "",
      yesButtonTitle = "Submit",
      String validationMessage,
      Function onSubmitCallback}) async {
    return showDialog(
        context: context,
        builder: (context) {
          String result;
          return AlertDialog(
            title: Text(label ?? ""),
            content: Form(
              key: formKey,
              child: TextFormField(
                  initialValue: initialValue,
                  decoration: InputDecoration(hintText: hint ?? ""),
                  validator: (text) {
                    print("text${text}");
                    var value = text.trim();
                    print("value${value}");
                    if (validationMessage != null && value.isEmpty) {
                      return validationMessage;
                    }
                  },
                  onSaved: (text) {
                    result = text.trim();
                  }),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Save'),
                onPressed: () async {
                  if (formKey.currentState.validate()) {
                    formKey.currentState.save();
                    await onSubmitCallback(result);
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          );
        });
  }
}
