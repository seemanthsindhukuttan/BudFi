import 'dart:io';
import 'package:budfi/model/transaction/transaction_model.dart';
import 'package:budfi/model/user/user_model.dart';
import 'package:budfi/screens/onboarding/onbording.dart';
import 'package:budfi/screens/splashscreen.dart';
import 'package:budfi/theme/Light/colors/colors.dart';
import 'package:budfi/theme/Light/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api/local_auth_api.dart';
import 'model/category/category_model.dart';
import 'screens/home/home_screen.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Directory appDocDir = await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocDir.path);
  if (!Hive.isAdapterRegistered(UserModelAdapter().typeId)) {
    Hive.registerAdapter<UserModel>(UserModelAdapter());
  }

  if (!Hive.isAdapterRegistered(categorytypeAdapter().typeId)) {
    Hive.registerAdapter<categorytype>(categorytypeAdapter());
  }
  if (!Hive.isAdapterRegistered(TransactionModelAdapter().typeId)) {
    Hive.registerAdapter<TransactionModel>(TransactionModelAdapter());
  }
  if (!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)) {
    Hive.registerAdapter<CategoryModel>(CategoryModelAdapter());
  }

  await Hive.openBox<UserModel>('user_db');
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  prefs = await SharedPreferences.getInstance();
  final boolKey = prefs!.getBool('HOME') ?? false;

  runApp(MyApp(boolkey: boolKey));
}

SharedPreferences? prefs;

class MyApp extends StatelessWidget {
  final bool? boolkey;

  const MyApp({Key? key, this.boolkey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool lock = prefs!.getBool('auth') ?? false;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BudFi',
      theme: BudFiLightTheme.budFiLightTheme,
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: BudFiColor.backgroundColor,
          systemNavigationBarColor: BudFiColor.backgroundColor,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: boolkey == false
            ? const OnBording()
            : lock == false
                ? const HomeScreen()
                : SplashScreen(),
      ),
    );
  }
}
