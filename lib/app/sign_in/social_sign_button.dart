import 'package:trackingtime/common_widgets/custom_raised_button.dart';
import 'package:flutter/material.dart';
class SocialSignButton extends CustomRaisedButton {
  SocialSignButton({
    required String text,
    required Color textColor,
    required Color color,
    required VoidCallback onPressed,
    required String pathImage
  }) : super(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Image.asset(pathImage),
        Text(text, style: TextStyle(fontSize: 15.0, color: textColor),),
        Opacity(
          opacity: 0.0,
          child: Image.asset(pathImage),
        )
      ],
    ),
    borderRadius: 4.0,
    height: 50.0,
    color: color,
    onPressed: onPressed,
  );
}