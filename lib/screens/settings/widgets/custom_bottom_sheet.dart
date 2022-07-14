import 'package:budfi/model/user/user_model.dart';
import 'package:budfi/screens/addscreen/widgets/custom_elevated_button.dart';
import 'package:budfi/screens/onboarding/onbording.dart';
import 'package:flutter/material.dart';

class CustomBottomSheet extends StatefulWidget {
  const CustomBottomSheet({Key? key}) : super(key: key);

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  final usernamecontroller = TextEditingController();
  final value = OnBording.userDb.get('user');
  @override
  void initState() {
    if (value != null) {
      usernamecontroller.text = value!.username;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: SizedBox(
        height: deviceHeight / 1.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: deviceHeight / 100),
              child: Divider(
                color: Theme.of(context).hintColor,
                thickness: 2,
                indent: MediaQuery.of(context).size.longestSide / 5,
                endIndent: MediaQuery.of(context).size.longestSide / 5,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: deviceWidth / 20),
              child: Text(
                'Edit Username',
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              child: TextFormField(
                controller: usernamecontroller,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
              child: CustomElevatedButtonWidget(
                buttonText: 'save',
                width: MediaQuery.of(context).size.width * 0.5,
                onpressed: () async {
                  await OnBording.userDb.put(
                    'user',
                    UserModel(
                      imagePath: value!.imagePath,
                      username: usernamecontroller.text,
                      amount: value!.amount,
                    ),
                  );
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
