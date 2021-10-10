import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<dynamic> showAlertDialog (
  BuildContext context, {
      required String title,
      required String content,
      required String activeDefaultText,
      required String? cancelActiveText,
  }) {
  if (!Platform.isIOS) {
     return showDialog(
         barrierDismissible: false,
         context: context,
         builder: (context) => AlertDialog(
           title: Text(title),
           content: Text(content),
           actions: <Widget>[
             if (cancelActiveText != null)
               FlatButton(
                 onPressed: () => Navigator.of(context).pop(false),
                 child: Text(cancelActiveText),
               ),
             FlatButton(
                 onPressed: () => Navigator.of(context).pop(true),
                 child: Text(activeDefaultText)
             )
           ],
         )
     );
  }
  return showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            if (cancelActiveText != null)
              CupertinoDialogAction(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(cancelActiveText),
              ),
            CupertinoDialogAction(
              child: Text(activeDefaultText),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            )
          ],
        );
      }
  );
}