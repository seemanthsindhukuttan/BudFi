import 'package:flutter/material.dart';

class FloatingActionButtonWidget extends StatelessWidget {
  VoidCallback onpressed;
  FloatingActionButtonWidget({Key? key, required this.onpressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 5,
      onPressed: onpressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: FractionalOffset.topLeft,
            end: FractionalOffset.bottomRight,
            tileMode: TileMode.mirror,
            colors: [
              Colors.blue,
              Colors.purpleAccent,
            ],
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
