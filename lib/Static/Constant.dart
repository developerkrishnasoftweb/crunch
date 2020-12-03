import 'package:flutter/material.dart';

Map<int, Color> appPrimaryColors = {
  50: Color.fromRGBO(86, 99, 255, .1),
  100: Color.fromRGBO(86, 99, 255, .2),
  200: Color.fromRGBO(86, 99, 255, .3),
  300: Color.fromRGBO(86, 99, 255, .4),
  400: Color.fromRGBO(86, 99, 255, .5),
  500: Color.fromRGBO(86, 99, 255, .6),
  600: Color.fromRGBO(86, 99, 255, .7),
  700: Color.fromRGBO(86, 99, 255, .8),
  800: Color.fromRGBO(86, 99, 255, .9),
  900: Color.fromRGBO(86, 99, 255, 1),
};

class AppColors {
  static Color whitecolor = Color(0xFFFFFFFF);
  static Color blackcolor = Color(0xFF000000);
  static Color greencolor = Color(0xFF56b72a);
}

MaterialColor appPrimaryMaterialColor =
MaterialColor(0xFF5663ff, appPrimaryColors);

class Session {
  static const String id = "id";
  static const String firstname = "firstname";
  static const String lastname = "lastname";
  static const String shopname = "shopname";
  static const String dob = "dob";
  static const String city = "city";
  static const String phone = "phone";
  static const String email = "email";
  static const String password = "password";
  static const String logo = "logo";
  static const String status = "status";
}
