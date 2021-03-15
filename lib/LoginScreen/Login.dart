import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crunch/APIS/AppServices.dart';
import 'package:crunch/Common/CustomButton.dart';
import 'package:crunch/Common/TextField.dart';
import 'package:crunch/LoginScreen/SignUp.dart';
import 'package:crunch/Screens/dashboard.dart';
import 'package:crunch/Static/global.dart';
import 'package:crunch/main.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../APIS/tables.dart';
import '../Static/Constant.dart' as cnst;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:math';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController Email = TextEditingController();
  TextEditingController Password = TextEditingController();
  StreamSubscription iosSubscription;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String fcm = "";
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var android = new AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android: android, iOS: ios);
    flutterLocalNotificationsPlugin.initialize(platform);
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      showNotification(message);
      print("onMessage  $message");
    }, onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch  $message");
    }, onResume: (Map<String, dynamic> message) async {
      print("onResume  $message");
    });
    _configureNotification();
  }

  showNotification(Map<String, dynamic> msg) async {
    var android = new AndroidNotificationDetails(
        'channel_id', 'CHANNEL NAME', 'channelDescription');
    var ios = new IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: ios);
    await flutterLocalNotificationsPlugin.show(Random().nextInt(100),
        msg["notification"]["title"], msg["notification"]["body"], platform);
  }

  _configureNotification() async {
    if (Platform.isIOS) {
      iosSubscription =
          _firebaseMessaging.onIosSettingsRegistered.listen((data) async {
        await _getFCMToken();
      });
      _firebaseMessaging
          .requestNotificationPermissions(IosNotificationSettings());
    } else {
      await _getFCMToken();
    }
  }

  _getFCMToken() {
    _firebaseMessaging.getToken().then((String token) {
      setState(() {
        fcm = token;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(children: [
      Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/spalsh.png"),
                  fit: BoxFit.fill,
                  colorFilter: new ColorFilter.mode(
                      Colors.black.withOpacity(0.7), BlendMode.softLight)))),
      Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: size.height * 0.15),
                  width: size.width * 0.6,
                  height: size.height * 0.13,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/White_CrunchTM.png"),
                        fit: BoxFit.fill),
                  ),
                ),
                CustomTextField(
                  hint: "Email",
                  textcontroller: Email,
                  obtext: false,
                  textColor: cnst.AppColors.whitecolor,
                  texticon: Icon(
                    Icons.mail_outline,
                    size: 25.0,
                    color: cnst.AppColors.whitecolor,
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                CustomTextField(
                  hint: "Password",
                  textcontroller: Password,
                  obtext: true,
                  textColor: cnst.AppColors.whitecolor,
                  texticon: Icon(
                    Icons.lock_open,
                    size: 25.0,
                    color: cnst.AppColors.whitecolor,
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                GestureDetector(
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePassword()));
                  },
                  child: Container(
                    width: size.width * 0.85,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: cnst.AppColors.whitecolor,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 80.0,
                ),
                CustomButton(
                    title: "LOGIN",
                    btncolor: cnst.primaryColor,
                    ontap: LoginValidation),
                SizedBox(
                  height: 30.0,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUp()));
                  },
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      "Create New Account",
                      style: TextStyle(
                        color: cnst.AppColors.whitecolor,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            )),
      )
    ]);
  }

  LoginValidation() {
    if (Email.text == "") {
      _toastMesssage("Please enter your Email");
    } else if (Password.text == "") {
      _toastMesssage("please Enter your Password");
    } else {
      loginCustomer();
    }
  }

  loginCustomer() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData data = FormData.fromMap({
          "api_key": API_Key,
          "username": Email.text,
          "password": Password.text,
          "token": fcm,
        });
        await AppServices.CustomerLogin(data).then((data) async {
          if (data.value == "y") {
            await sharedPreferences.setString(
                'userdata', jsonEncode(data.data[0]));
            await getCredentials();
            if (userdata != null) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Dashboard()));
            }
          } else {
            _toastMesssage("Invalid username or password");
          }
        });
      }
    } catch (e) {}
  }

  _toastMesssage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white.withOpacity(0.3),
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
