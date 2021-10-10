import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trackingtime/common_widgets/custom_raised_button.dart';

class FormSubmitButton extends CustomRaisedButton {
  FormSubmitButton({
    required String text,
    required VoidCallback onPressed,
    required Color color,
  }) : super (
    child: Text(text, style: TextStyle(color: Colors.white, fontSize: 20.0),),
    height: 44.0,
    color: color,
    borderRadius: 4.0,
    onPressed: onPressed,
  );
}