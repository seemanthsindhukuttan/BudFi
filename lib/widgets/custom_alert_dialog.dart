import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  String heading;
  String content;
  String firstbuttonName;
  String secondbuttonName;
  VoidCallback onpressedFirstbutton;

  CustomAlertDialog({
    Key? key,
    required this.heading,
    required this.content,
    required this.firstbuttonName,
    required this.secondbuttonName,
    required this.onpressedFirstbutton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 10,
      title: Text(heading),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: onpressedFirstbutton,
          child: Text(
            firstbuttonName,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            secondbuttonName,
          ),
        ),
      ],
    );
  }
}
