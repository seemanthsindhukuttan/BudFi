import 'package:flutter/material.dart';

class CustomRadioButton extends StatelessWidget {
  void Function(dynamic)? onChanged;
  dynamic value;
  dynamic groupValue;
  String text;
  CustomRadioButton({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio(
          activeColor: Theme.of(context).primaryColor,
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
        Text(
          text,
          style: TextStyle(
            fontFamily: 'Prompt',
            color: Theme.of(context).hintColor,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}
