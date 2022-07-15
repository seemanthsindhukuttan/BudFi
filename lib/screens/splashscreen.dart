import 'package:budfi/api/local_auth_api.dart';
import 'package:budfi/screens/home/home_screen.dart';
import 'package:budfi/widgets/customSizedBox.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);
  ValueNotifier<bool?> _changeState = ValueNotifier(null);
  @override
  Widget build(BuildContext context) {
    auth(context);

    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: _changeState,
          builder: (BuildContext context, bool? updateValue, Widget? _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset('assets/images/appicon.png'),
                ),
                Center(
                  child: IconButton(
                    alignment: Alignment.center,
                    splashRadius: 1,
                    onPressed: () async {
                      auth(context);
                    },
                    icon: Icon(Icons.fingerprint,
                        size: 50,
                        color: updateValue == false
                            ? Colors.red
                            : updateValue == true
                                ? Colors.green
                                : Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    updateValue == false
                        ? "Fingerprint not recognized"
                        : "Fingerprint recognized",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: updateValue == false
                            ? Colors.red
                            : updateValue == true
                                ? Colors.green
                                : Colors.white,
                        fontSize: 18),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  auth(BuildContext context) async {
    bool lock = prefs!.getBool('auth') ?? false;
    final auth = await LocalAuthApi.authentication();
    _changeState.value = auth;
    if (lock != false) {
      if (auth == true) {
        await Future.delayed(const Duration(milliseconds: 300));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      }
    }
  }
}
