import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
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
  StreamSubscription iosSubscription;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print("onMessage  $message");
    }, onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch  $message");
    }, onResume: (Map<String, dynamic> message) async {
      print("onResume  $message");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          accentColor: cnst.appPrimaryMaterialColor,
          primaryColor: cnst.appPrimaryMaterialColor,
          appBarTheme:
              AppBarTheme(iconTheme: IconThemeData(color: Colors.white))),
      initialRoute: "/",
      routes: {
        "/": (context) => Login(),
        // "/SignUp" : (context) => SignUp(),
        // "/ForgotPassword" : (context) => Login(),
        // "/Home" : (context) => Home(),
        // "/MenuList" : (context) => Menu_list(),
        // "/Rating" : (context) => Rating(),
        // "/Category" : (context) => Categorys(),
        // "/SetLocation" : (context) => SetLocation(),
        // "/ChangePassword" : (context) => ChangePassword(),
      },
    );
  }
}
