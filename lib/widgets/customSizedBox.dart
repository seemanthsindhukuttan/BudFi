import 'package:flutter/material.dart';

class CustomSizedBox extends StatelessWidget {
  double? width;
  double? height;
  Widget? child;
  CustomSizedBox({Key? key, this.width, this.child, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: child,
    );
  }
}
