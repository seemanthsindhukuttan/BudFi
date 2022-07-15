import 'package:flutter/material.dart';
import '../../../widgets/customSizedBox.dart';

class CustomOnBordingTile extends StatelessWidget {
  String imgPath;
  String title;
  String firstSubtitle;
  String? secondSubtitle;
  CustomOnBordingTile({
    Key? key,
    required this.imgPath,
    required this.title,
    required this.firstSubtitle,
    this.secondSubtitle = '',
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imgPath,
          fit: BoxFit.contain,
        ),
        CustomSizedBox(
          height: deviceHeight / 40,
        ),
        Text(
          title,
          style: const TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, fontFamily: 'Prompt'),
        ),
        CustomSizedBox(
          height: deviceHeight / 40,
        ),
        Text(
          firstSubtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Prompt'),
        ),
        Text(
          secondSubtitle!,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Prompt'),
        ),
      ],
    );
  }
}
