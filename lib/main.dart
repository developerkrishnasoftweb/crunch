import 'dart:async';

import 'package:crunch/APIS/Constants.dart';
import 'package:crunch/LoginScreen/SignUp.dart';
import 'package:crunch/Screens/Category.dart';
import 'package:crunch/Screens/ChangePassword.dart';
import 'package:crunch/Screens/Menu_List.dart';
import 'package:crunch/Screens/Rating.dart';
import 'package:crunch/Screens/setLocation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'LoginScreen/Login.dart';
import 'Screens/Home.dart';
import 'Screens/new_home.dart';
import 'Static/Constant.dart' as cnst;

void main() {
  runApp(MyApp());
  SQFLiteTables();
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
    // TODO: implement initState
    super.initState();
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async{
          print("onMessage  $message");
        },
        onLaunch: (Map<String, dynamic> message) async{
          print("onLaunch  $message");
        },
        onResume: (Map<String, dynamic> message) async{
          print("onResume  $message");
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          accentColor: cnst.appPrimaryMaterialColor,
          primaryColor: cnst.appPrimaryMaterialColor
      ),
      initialRoute: "/",
      routes: {
        "/" : (context) => Home(),
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
