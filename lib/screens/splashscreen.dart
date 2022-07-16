import 'dart:async';

import 'package:budfi/api/local_auth_api.dart';
import 'package:budfi/screens/home/home_screen.dart';
import 'package:budfi/widgets/customSizedBox.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../main.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);
  final ValueNotifier<dynamic> _changeState = ValueNotifier(null);
  ValueNotifier<int> second = ValueNotifier(60);
  Timer? time;

  @override
  Widget build(BuildContext context) {
    auth(context);

    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: _changeState,
          builder: (BuildContext context, dynamic updateValue, Widget? _) {
            return ValueListenableBuilder(
              valueListenable: second,
              builder: (BuildContext context, int timer, Widget? _) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset('assets/images/appicon.png'),
                    ),
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        splashRadius: 1,
                        onPressed: () {
                          updateValue == false
                              ? auth(context)
                              : timer <= 0
                                  ? auth(context)
                                  : null;
                        },
                        icon: FaIcon(FontAwesomeIcons.fingerprint,
                            size: 50,
                            color:
                                updateValue == false || updateValue == "LOCKED"
                                    ? Colors.red
                                    : updateValue == true
                                        ? Colors.green
                                        : Colors.white),
                      ),
                    )),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        updateValue == false || updateValue == "LOCKED"
                            ? "Fingerprint not recognized"
                            : "Fingerprint recognized",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color:
                                updateValue == false || updateValue == "LOCKED"
                                    ? Colors.red
                                    : updateValue == true
                                        ? Colors.green
                                        : Colors.white,
                            fontSize: 18),
                      ),
                    ),
                    updateValue == 'LOCKED'
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: timer > 0
                                ? Text(
                                    ' Retry after $timer sec',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.red,
                                    ),
                                  )
                                : CustomSizedBox(),
                          )
                        : CustomSizedBox(),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<dynamic> auth(BuildContext context) async {
    bool lock = prefs!.getBool('auth') ?? false;
    //final auth = "LOCKED";
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
    if (auth == 'LOCKED') {
      if (second.value > 0) {
        time = Timer.periodic(
          const Duration(seconds: 1),
          (_) {
            second.value--;
          },
        );
      }
      if (second.value < 0) {
        time!.cancel();
        print(second.value);
      }
    }
  }
}
