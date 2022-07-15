import 'dart:io';
import 'package:budfi/model/transaction/transaction_model.dart';
import 'package:budfi/model/user/user_model.dart';
import 'package:budfi/screens/onboarding/onbording.dart';
import 'package:budfi/theme/colors/colors.dart';
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
        scaffoldBackgroundColor: BudFiColor.backgroundColor,
        primarySwatch: BudFiColor.budFiprimarySwatch,
        drawerTheme:
            const DrawerThemeData(backgroundColor: BudFiColor.backgroundColor),
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: BudFiColor.appBarColor,
          iconTheme: IconThemeData(
            color: BudFiColor.textColorGrey,
          ),
          titleTextStyle: const TextStyle(
            color: BudFiColor.textColorBlack,
          ),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor: BudFiColor.backgroundColor),
        hintColor: BudFiColor.textColorGrey,
        textTheme: TextTheme(
          headline1: const TextStyle(
            fontFamily: 'Prompt',
            color: BudFiColor.textColorBlack,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          headline2: const TextStyle(
            fontFamily: 'Prompt',
            color: BudFiColor.textColorBlack,
            fontWeight: FontWeight.w600,
            fontSize: 25,
          ),
          headline3: const TextStyle(
            fontFamily: 'Prompt',
            color: BudFiColor.textColorBlack,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
          headline4: TextStyle(
            fontFamily: 'VariableFont',
            color: BudFiColor.textColorGrey,
            fontWeight: FontWeight.w400,
            fontSize: 36,
          ),
          headline5: const TextStyle(
            fontFamily: 'Prompt',
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: BudFiColor.textColorWhite,
          ),
          headline6: const TextStyle(
            fontFamily: 'Prompt',
            fontWeight: FontWeight.w800,
            fontSize: 30,
            color: BudFiColor.textColorWhite,
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
          statusBarColor: BudFiColor.backgroundColor,
          systemNavigationBarColor: BudFiColor.backgroundColor,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: boolkey == false ? const OnBording() : const HomeScreen(),
      ),
    );
  }
}
