import 'package:flutter/material.dart';
import 'colors/colors.dart';

class BudFiLightTheme {
  static ThemeData budFiLightTheme = ThemeData(
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
    bottomSheetTheme:
        const BottomSheetThemeData(backgroundColor: BudFiColor.backgroundColor),
    hintColor: BudFiColor.textColorGrey,
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
      ),
    ),
    androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
  );
}
