import 'dart:io';
import 'package:budfi/db/category/category_db.dart';
import 'package:budfi/model/user/user_model.dart';
import 'package:budfi/screens/addscreen/widgets/custom_elevated_button.dart';
import 'package:budfi/screens/home/home_screen.dart';
import 'package:budfi/screens/onboarding/widgets/custom_onbording_tile.dart';
import 'package:budfi/screens/settings/widgets/custom_circle_avatar.dart';
import 'package:budfi/widgets/customSizedBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../main.dart';

class OnBording extends StatefulWidget {
  const OnBording({Key? key}) : super(key: key);
  static final userDb = Hive.box<UserModel>('user_db');
  @override
  State<OnBording> createState() => _OnBordingState();
}

class _OnBordingState extends State<OnBording> {
  final _usernameController = TextEditingController();
  final _amountController = TextEditingController();
  final pageController = PageController();
  ValueNotifier<bool> islast = ValueNotifier(false);
  final _userFormKey = GlobalKey<FormState>();
  final _amountFormKey = GlobalKey<FormState>();
  ValueNotifier<String?> imagepath = ValueNotifier(null);

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(bottom: deviceHeight / 30),
        child: SafeArea(
          child: PageView(
            allowImplicitScrolling: true,
            onPageChanged: (value) =>
                value == 4 ? islast.value = true : islast.value = false,
            controller: pageController,
            children: [
              CustomOnBordingTile(
                imgPath: 'assets/images/1.png',
                title: 'All your finance in one place',
                firstSubtitle: 'See the bigger picture by having all your',
                secondSubtitle: 'finance in one place',
              ),
              CustomOnBordingTile(
                imgPath: 'assets/images/2.png',
                title: 'Where your money goes',
                firstSubtitle: 'Track with categories',
              ),
              CustomOnBordingTile(
                imgPath: 'assets/images/3.png',
                title: 'Track your spending',
                firstSubtitle: 'keep track of your Income&Expense manually',
              ),
              CustomOnBordingTile(
                imgPath: 'assets/images/4.png',
                title: 'Save your Money',
                firstSubtitle: 'You Must Value Saving More than Spending',
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: deviceHeight / 200, bottom: deviceHeight / 20),
                        child: ValueListenableBuilder(
                            valueListenable: imagepath,
                            builder: (BuildContext context, String? updateImg,
                                Widget? _) {
                              return CustomCircleAvatar(
                                backgroundImage: updateImg == null
                                    ? const AssetImage('assets/images/user.png')
                                        as ImageProvider
                                    : FileImage(File(updateImg)),
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
                                                    await Permission
                                                        .storage.status;

                                                if (!galleryStatus.isGranted) {
                                                  await Permission.storage
                                                      .request();
                                                }
                                                if (await Permission
                                                    .storage.isGranted) {
                                                  await pickImg(
                                                      source:
                                                          ImageSource.gallery);
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
                                                    await Permission
                                                        .camera.status;

                                                if (!cameraStatus.isGranted) {
                                                  await Permission.camera
                                                      .request();
                                                }
                                                if (await Permission
                                                    .camera.isGranted) {
                                                  await pickImg(
                                                      source:
                                                          ImageSource.camera);
                                                } else {
                                                  return;
                                                }

                                                Navigator.pop(context);
                                              },
                                              icon:
                                                  const Icon(Icons.camera_alt),
                                              label: const Text('CAMERA'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            }),
                      ),
                      //username formField.
                      Form(
                        key: _userFormKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: TextFormField(
                          controller: _usernameController,
                          validator: (value) {
                            if (value!.length < 2) {
                              return 'Username is required & minimum 2 characters';
                            } else {
                              return null;
                            }
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.0),
                              ),
                            ),
                            hintText: 'Username',
                          ),
                        ),
                      ),
                      CustomSizedBox(height: deviceHeight / 30),
                      //amount formField.
                      Form(
                        key: _amountFormKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _amountController,
                          validator: (value) {
                            if (value?.length == 9) {
                              return " Max limit 9,00,00,000 crore";
                            } else {
                              return null;
                            }
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.0),
                              ),
                            ),
                            hintText: 'Amount (optional)',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: ValueListenableBuilder(
        valueListenable: islast,
        builder: (BuildContext context, bool value, Widget? child) {
          return value == true
              ? CustomElevatedButtonWidget(
                  height: deviceHeight / 15,
                  buttonText: 'GET STARTED',
                  width: MediaQuery.of(context).size.longestSide,
                  onpressed: () async {
                    if (_userFormKey.currentState!.validate() &&
                        _amountFormKey.currentState!.validate()) {
                      final _value = UserModel(
                        imagePath: imagepath.value != null
                            ? imagepath.value.toString()
                            : null,
                        username: _usernameController.text,
                        amount: _amountController.text.isEmpty
                            ? 0
                            : double.parse(_amountController.text),
                      );

                      await OnBording.userDb.put('user', _value);
                      await prefs!.setBool('HOME', true);
                      await CategoryDB.instance.autoAdding();

                      await Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ));

                      //print(autoadd);

                    }
                  },
                )
              : SizedBox(
                  height: deviceHeight / 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          pageController.jumpToPage(4);
                        },
                        child: const Text('SKIP'),
                      ),
                      Center(
                        child: SmoothPageIndicator(
                          controller: pageController,
                          count: 5,
                          effect: WormEffect(
                            dotColor: Theme.of(context).hintColor,
                            activeDotColor: Theme.of(context).primaryColor,
                            dotHeight: 7,
                            dotWidth: 7,
                            spacing: 16,
                          ),
                          onDotClicked: (index) {
                            pageController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text('NEXT'),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }

  Future<void> pickImg({required ImageSource source}) async {
    try {
      XFile? imgXfile = await ImagePicker().pickImage(source: source);
      if (imgXfile == null) {
        return;
      } else {
        imagepath.value = imgXfile.path;
      }
    } on PlatformException catch (e) {
      Text('Failed to pick image$e');
    }
  }
}
