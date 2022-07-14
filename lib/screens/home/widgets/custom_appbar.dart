import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../model/user/user_model.dart';
import '../../onboarding/onbording.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return AppBar(
      toolbarHeight: deviceHeight / 15,
      leading: ValueListenableBuilder(
        valueListenable: OnBording.userDb.listenable(),
        builder: (BuildContext context, Box<UserModel> newuser, Widget? _) {
          final userdp = newuser.get('user')?.imagePath;

          return CircleAvatar(
            backgroundImage: userdp != null
                ? FileImage(File(userdp))
                : const AssetImage('assets/images/user.png') as ImageProvider,
          );
        },
      ),
      elevation: 0,
      actions: [
        Builder(
          builder: (BuildContext context) {
            return IconButton(
              splashRadius: 25,
              color: Theme.of(context).hintColor,
              icon: const Icon(
                Icons.settings,
              ),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            );
          },
        ),
      ],
    );
  }
}
