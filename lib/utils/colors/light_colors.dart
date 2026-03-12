import 'package:flutter/material.dart';

// Primary Colors

const lightGradientGreen = Color(0xFF00A650);
const darkGradientGreen = Color(0xFF007036);
const lightGreenBg = Color(0xFFABE5C5);


const accent = Color(0xFFE99517);

const lightGradientOrange = Color(0xFFFFB443);
const darkGradientOrange = Color(0xFFA86B12);

const lightGradientRed = Color(0xFFEE1C25);
const darkGradientRed = Color(0xFF770E13);


var primaryGradient = LinearGradient(colors: [
  primarySoft,
  primary,
]);


const primaryDarkest= Color(0xFF0F1842);

var primarySoft = const Color(0xFF3B5898).withOpacity(0.79);
const primary = Color(0xFF3B5898);
const primaryDark = Color(0xFF596BB1);
var primaryLight = const Color(0xFF3B5898).withOpacity(0.05);
const primaryLighter = Color(0xFFF0F5FF);
const backgroundLight = Color(0xFFF5F6FC);

const backgroundSurface = Color(0xFFEAECF8);


const activityIconBg = Color(0xFFD6DFFF);
const greyIcon = Color(0xFF414345);
const imgBgColor = Color(0xFFE6FFF1);
const isCycleColor = Color(0xFF00A650);
const bColorDarker = Color(0xFFF6F8FF);
const bColor = Color(0xFFF6F8FF);
const textInputBg = Color(0xFFF6F8FF);
const bgColor = Color(0xFFFFFFFF);
const whiteColor = Color(0xFFFFFFFF);
//  Accent Colors
const aColor = Color(0xFFFFB61A);
const aColorLight = Color(0xFFFBCE3D);
const aColorDarker = Color(0xFFFFE48E);
const aColorLighter = Color(0xFFFFF4CF);



const blueGrey = Color(0xFF808A94);
const blueGreyBg = Color(0xFFEAECF8);



const eColor = Color(0xFFEE1C25);
const eColorLight = Color(0xFFFFB2B6);

// Text and Icons
const black = Color(0xFF000000);
const dark = Color(0xFF414345);
const muted = Color(0xFF808A94);

const bottomBarU = Color(0xFF707070);
const tColorLight = Color(0xFF949596);
const tColorLighter = Color(0xFFEEEEEE);
const iColor = Color(0xFF787878);
const aTColor = Color(0xFF4D4B4C);

const dividerColor = Colors.black12;

// Error Colors
const redColor = Color(0xFFEE1C25);
const redBg = Color(0xFFFFDEDF);

ThemeData lightTheme() {
  return ThemeData.light().copyWith(
    unselectedWidgetColor:activityIconBg,



    primaryColor: primary,
    brightness: Brightness.light,
    indicatorColor: primary,
    highlightColor: bColor,
    focusColor: primary,
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primary,
    ),
    scaffoldBackgroundColor: bgColor,
    iconTheme: const IconThemeData(color: iColor),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 10,
      unselectedLabelStyle: TextStyle(
          color: Colors.grey[600], fontFamily: 'Poppins', fontSize: 12.0),
      selectedItemColor: aColor,
      unselectedItemColor: bottomBarU,
      showUnselectedLabels: true,
    ),


    bottomSheetTheme: const BottomSheetThemeData(
      surfaceTintColor: Colors.white,
    ),

    dialogTheme: const DialogThemeData(
      surfaceTintColor: Colors.white,

    ),

    inputDecorationTheme: const InputDecorationTheme(
      errorStyle: TextStyle(color: redColor),
      errorBorder: InputBorder.none,
    ),
    dividerColor: Colors.transparent,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: primary,
      selectionColor: activityIconBg,
      selectionHandleColor: primary,
    ),
  );
}

