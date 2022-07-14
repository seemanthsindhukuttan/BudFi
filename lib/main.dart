import 'dart:io';
import 'package:budfi/model/transaction/transaction_model.dart';
import 'package:budfi/model/user/user_model.dart';
import 'package:budfi/screens/onboarding/onbording.dart';
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
  bool? lock = prefs!.getBool('auth');
  lock == true ? await LocalAuthApi.authentication() : null;

  runApp(MyApp(boolkey: boolKey));
}

SharedPreferences? prefs;

class MyApp extends StatelessWidget {
  final bool? boolkey;

  const MyApp({Key? key, this.boolkey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BudFi',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: const MaterialColor(0xFF7C4DFF, {
          50: Color(0xFF7C4DFF),
          100: Color(0xFF7C4DFF),
          200: Color(0xFF7C4DFF),
          300: Color(0xFF7C4DFF),
          400: Color(0xFF7C4DFF),
          500: Color(0xFF7C4DFF),
          600: Color(0xFF7C4DFF),
          700: Color(0xFF7C4DFF),
          800: Color(0xFF7C4DFF),
          900: Color(0xFF7C4DFF),
        }),
        drawerTheme: const DrawerThemeData(backgroundColor: Colors.white),
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Theme.of(context).hintColor,
          ),
          titleTextStyle: const TextStyle(
            color: Colors.black,
          ),
        ),
        bottomSheetTheme:
            const BottomSheetThemeData(backgroundColor: Colors.white),
        hintColor: Colors.grey.shade500,
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontFamily: 'Prompt',
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          headline2: TextStyle(
            fontFamily: 'Prompt',
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 25,
          ),
          headline3: TextStyle(
            fontFamily: 'Prompt',
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.transparent),
          ),
        ),
        androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
      ),
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          systemNavigationBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: boolkey == false ? const OnBording() : const HomeScreen(),
      ),
    );
  }
}
