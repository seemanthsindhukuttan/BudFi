import 'package:budfi/model/user/user_model.dart';
import 'package:budfi/screens/addscreen/widgets/custom_elevated_button.dart';
import 'package:budfi/screens/onboarding/onbording.dart';
import 'package:flutter/material.dart';
import '../../../theme/Light/colors/colors.dart';

class CustomBottomSheet extends StatefulWidget {
  const CustomBottomSheet({Key? key}) : super(key: key);

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  final usernamecontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
              child: const Text(
                'Edit Username',
                style: TextStyle(
                  fontFamily: 'Prompt',
                  color: BudFiColor.textColorBlack,
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: usernamecontroller,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Username is required';
                    } else if (value.length < 3) {
                      return "Min 3 Characters.";
                    } else {
                      return null;
                    }
                  },
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
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
              child: CustomElevatedButtonWidget(
                buttonText: 'save',
                width: MediaQuery.of(context).size.width * 0.5,
                onpressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await OnBording.userDb.put(
                      'user',
                      UserModel(
                        imagePath: value!.imagePath,
                        username: usernamecontroller.text,
                        amount: value!.amount,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
