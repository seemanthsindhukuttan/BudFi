import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatelessWidget {
  VoidCallback onpressed;
  ImageProvider<Object>? backgroundImage;
  CustomCircleAvatar({Key? key, required this.onpressed, this.backgroundImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          backgroundImage: backgroundImage,
          radius: 100,
        ),
        Positioned(
          right: 0,
          bottom: 10,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: FractionalOffset.topLeft,
                end: FractionalOffset.bottomRight,
                colors: [
                  Colors.blue,
                  Colors.purpleAccent,
                ],
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: IconButton(
              onPressed: onpressed,
              icon: const Icon(
                Icons.camera_alt,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
