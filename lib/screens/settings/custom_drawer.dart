import 'dart:io';
import 'package:budfi/api/local_auth_api.dart';
import 'package:budfi/db/category/category_db.dart';
import 'package:budfi/db/transaction/transaction_db.dart';
import 'package:budfi/screens/category/category_screen.dart';
import 'package:budfi/screens/onboarding/onbording.dart';
import 'package:budfi/screens/settings/widgets/custom_bottom_sheet.dart';
import 'package:budfi/screens/settings/widgets/custom_circle_avatar.dart';
import 'package:budfi/widgets/customSizedBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../main.dart';
import '../../model/user/user_model.dart';
import '../../theme/Light/colors/colors.dart';
import '../../widgets/custom_alert_dialog.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    final Uri _url = Uri.parse('https://seemanthsindhukuttan.github.io/');

    ValueNotifier<bool?> _buttonState =
        ValueNotifier(prefs!.getBool('auth') ?? false);
    return Drawer(
      width: MediaQuery.of(context).size.shortestSide,
      child: Padding(
        padding: EdgeInsets.only(left: deviceWidth / 40),
        child: Scaffold(
          appBar: AppBar(
            // actions: const [SizedBox()],
            leading: IconButton(
              splashRadius: 20,
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Theme.of(context).hintColor,
              ),
            ),
            title: Text(
              'Settings',
              style: TextStyle(
                fontFamily: 'Prompt',
                color: BudFiColor.textColorBlack,
                fontWeight: FontWeight.w600,
                fontSize: 25,
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: OnBording.userDb.listenable(),
                        builder: (BuildContext context, Box<UserModel> newuser,
                            Widget? _) {
                          final userdp = newuser.get('user')!.imagePath;

                          return CustomCircleAvatar(
                            backgroundImage: userdp != null
                                ? FileImage(File(userdp))
                                : const AssetImage('assets/images/user.png')
                                    as ImageProvider,
                            onpressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextButton.icon(
                                          onPressed: () async {
                                            var galleryStatus =
                                                await Permission.storage.status;

                                            if (!galleryStatus.isGranted) {
                                              await Permission.storage
                                                  .request();
                                            }
                                            if (await Permission
                                                .storage.isGranted) {
                                              await pickImg(
                                                  source: ImageSource.gallery);
                                            } else {
                                              return;
                                            }

                                            Navigator.pop(context);
                                          },
                                          icon: const Icon(Icons.photo),
                                          label: const Text('GALLERY'),
                                        ),
                                        TextButton.icon(
                                          onPressed: () async {
                                            var cameraStatus =
                                                await Permission.camera.status;

                                            if (!cameraStatus.isGranted) {
                                              await Permission.camera.request();
                                            }
                                            if (await Permission
                                                .camera.isGranted) {
                                              await pickImg(
                                                  source: ImageSource.camera);
                                            } else {
                                              return;
                                            }
                                            Navigator.pop(context);
                                          },
                                          icon: const Icon(Icons.camera_alt),
                                          label: const Text('CAMERA'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: deviceHeight / 40),
                      child: ValueListenableBuilder(
                        valueListenable: OnBording.userDb.listenable(),
                        builder: (BuildContext context, Box<UserModel> value,
                            Widget? _) {
                          final username = value.get('user');
                          return Text(
                            username!.username,
                            style: const TextStyle(
                              fontFamily: 'Prompt',
                              color: BudFiColor.textColorBlack,
                              fontWeight: FontWeight.w600,
                              fontSize: 25,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Center(
                    child: TextButton(
                      child: Text(
                        'Tap to Change Username',
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          context: context,
                          builder: (BuildContext context) {
                            return const CustomBottomSheet();
                          },
                        );
                      },
                    ),
                  ),
                  CustomSizedBox(
                    height: deviceHeight / 50,
                  ),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: null,
                        icon: const Icon(
                          Icons.lock,
                          color: Colors.black,
                        ),
                        label: const Text(
                          'Enable lock',
                          style: TextStyle(
                            fontFamily: 'Prompt',
                            color: BudFiColor.textColorBlack,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: _buttonState,
                        builder: (BuildContext context, bool? currentState,
                            Widget? child) {
                          return Switch(
                            value: currentState!,
                            onChanged: (value) async {
                              _buttonState.value = value;
                              prefs?.setBool('auth', value);

                              if (prefs!.getBool('auth') == true) {
                                await LocalAuthApi.authentication();
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CategoryScreen(),
                          ));
                    },
                    icon: const Icon(
                      Icons.category_outlined,
                      color: Colors.black,
                    ),
                    label: const Text(
                      'Edit categories',
                      style: TextStyle(
                        fontFamily: 'Prompt',
                        color: BudFiColor.textColorBlack,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomAlertDialog(
                            heading: 'Clear data message',
                            content:
                                'Are you sure ? Do you want to Clear all the Data?',
                            firstbuttonName: 'YES',
                            secondbuttonName: 'NO',
                            onpressedFirstbutton: () async {
                              await TransactionDb.instance
                                  .clearAllTransactions();
                              await CategoryDB.instance.clearAllCategories();
                              await CategoryDB.instance.autoAdding();

                              Navigator.pop(context);

                              //print(autoadd);
                            },
                          );
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.clear_rounded,
                      color: Colors.black,
                    ),
                    label: const Text(
                      'Clear all data',
                      style: TextStyle(
                        fontFamily: 'Prompt',
                        color: BudFiColor.textColorBlack,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.share,
                      color: Colors.black,
                    ),
                    label: const Text(
                      'Share with friends',
                      style: TextStyle(
                        fontFamily: 'Prompt',
                        color: BudFiColor.textColorBlack,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.star,
                      color: Colors.black,
                    ),
                    label: const Text(
                      'Rate this app',
                      style: TextStyle(
                        fontFamily: 'Prompt',
                        color: BudFiColor.textColorBlack,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      if (!await launchUrl(_url,
                          mode: LaunchMode.inAppWebView)) {
                        throw 'Could not launch $_url';
                      }
                    },
                    icon: const Icon(
                      Icons.feedback,
                      color: Colors.black,
                    ),
                    label: const Text(
                      'Feedback',
                      style: TextStyle(
                        fontFamily: 'Prompt',
                        color: BudFiColor.textColorBlack,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.info,
                      color: Colors.black,
                    ),
                    label: const Text(
                      'About',
                      style: TextStyle(
                        fontFamily: 'Prompt',
                        color: BudFiColor.textColorBlack,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: deviceWidth / 2.5,
                        vertical: deviceHeight / 80),
                    child: Text(
                      'version 1.0.0',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pickImg({required ImageSource source}) async {
    try {
      XFile? imgXfile = await ImagePicker().pickImage(source: source);
      if (imgXfile == null) {
        return;
      } else {
        String imagepath = imgXfile.path;
        final user = OnBording.userDb.get('user');
        OnBording.userDb.put(
          'user',
          UserModel(
              imagePath: imagepath,
              username: user!.username,
              amount: user.amount),
        );
      }
    } on PlatformException catch (e) {
      Text('Failed to pick image$e');
    }
  }
}
