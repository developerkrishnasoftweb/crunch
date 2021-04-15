import 'package:flutter/material.dart';

const Map<int, Color> primaryColorSwatch = {
  50: Color.fromRGBO(242, 126, 1, .1),
  100: Color.fromRGBO(242, 126, 1, .2),
  200: Color.fromRGBO(242, 126, 1, .3),
  300: Color.fromRGBO(242, 126, 1, .4),
  400: Color.fromRGBO(242, 126, 1, .5),
  500: Color.fromRGBO(242, 126, 1, .6),
  600: Color.fromRGBO(242, 126, 1, .7),
  700: Color.fromRGBO(242, 126, 1, .8),
  800: Color.fromRGBO(242, 126, 1, .9),
  900: Color.fromRGBO(242, 126, 1, 1),
};

class AppColors {
  static Color whitecolor = Color(0xFFFFFFFF);
  static Color blackcolor = Color(0xFF000000);
  static Color greencolor = Color(0xFF56b72a);
}

const MaterialColor primaryColor =
MaterialColor(0xFFf27e01, primaryColorSwatch);

class Session {
  static const String id = "id";
  static const String name = "name";
  static const String mobile = "mobile";
  static const String email = "email";
  static const String password = "password";
  static const String image = "image";
  static const String status = "status";
  static const String gender = "gender";
}
