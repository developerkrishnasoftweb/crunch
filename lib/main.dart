import 'package:flutter/material.dart';
import 'LoginScreen/Login.dart';
import 'Static/Constant.dart' as cnst;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
      theme: ThemeData(
          accentColor: cnst.appPrimaryMaterialColor,
          primaryColor: cnst.appPrimaryMaterialColor
      ),
    );
  }
}
