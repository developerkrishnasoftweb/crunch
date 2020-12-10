import 'dart:async';
import 'dart:io';
import 'package:crunch/Screens/Home.dart';
import 'package:dio/dio.dart';
import 'package:crunch/Common/CustomButton.dart';
import 'package:crunch/Common/TextField.dart';
import 'package:crunch/LoginScreen/SignUp.dart';
import 'package:crunch/Screens/ChangePassword.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../APIS/Constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../APIS/AppServices.dart';
import '../Static/Constant.dart' as cnst;

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
  ProgressDialog pr;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Please wait..");
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
    _configureNotification();
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
      print("fcm: ${token}");
    });
    getLocal();
  }

  getLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString(cnst.Session.id);

    if (id != null) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Home()), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/spalsh.png"),
                fit: BoxFit.fill,
              colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.softLight),
            ),
          ),
          child: Container(
            height: size.height,
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 100.0, 0, 0),
                  width: size.width *0.6,
                  height: size.height * 0.13,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/White_CrunchTM.png"),
                        fit: BoxFit.fill
                    ),
                  ),
                ),
                SizedBox(height: 150.0,),
                CustomTextField(hint: "Email",textcontroller: Email,obtext: false,textColor: cnst.AppColors.whitecolor,
                        texticon: Icon(Icons.mail_outline_rounded,size: 25.0,color: cnst.AppColors.whitecolor,),),
                SizedBox(height: 16.0,),
                CustomTextField(hint: "Password",textcontroller: Password,obtext: true,textColor: cnst.AppColors.whitecolor,
                  texticon: Icon(Icons.lock_open_rounded,size: 25.0,color: cnst.AppColors.whitecolor,),),
                SizedBox(height: 16.0,),
                GestureDetector(
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePassword()));
                  },
                  child: Container(
                    width: size.width *0.85,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: cnst.AppColors.whitecolor,
                          fontSize: 15,),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 100.0,),
                CustomButton(
                  title: "LOGIN", btncolor: cnst.appPrimaryMaterialColor,
                  ontap: () {
                    LoginValidation();
                  }
                ),
                SizedBox(height: 50.0,),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
                  },
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      "Create New Account",
                      style: TextStyle(
                        color: cnst.AppColors.whitecolor,
                        fontSize: 15,),
                    ),
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }


  LoginValidation() {
    if (Email.text == "") {
      _toastMesssage("Please enter your Email");
    } else if (Password.text == "") {
      _toastMesssage("please Enter your Password");
    } else {
      LoginCustomer();
    }
  }

  LoginCustomer() async {

    try{
      pr.show();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        print(Email.text + "  "+Password.text+ " "+fcm+ " ");

        FormData d = FormData.fromMap({
          "api_key" : API_Key,
          "username" : Email.text,
          "password" : Password.text,
          "token" : fcm,
        });

        AppServices.CustomerLogin(d).then((data) async {
          pr.hide();
          if(data.value == "y"){
            print("VAlue "+data.data[0]['name']);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString(cnst.Session.id, data.data[0]["id"]);
            prefs.setString(cnst.Session.name, data.data[0]["name"]);
            prefs.setString(cnst.Session.mobile, data.data[0]["mobile"]);
            prefs.setString(cnst.Session.email, data.data[0]["email"]);
            prefs.setString(cnst.Session.password, data.data[0]["password"]);
            prefs.setString(cnst.Session.image, data.data[0]["image"]);
            prefs.setString(cnst.Session.status, data.data[0]["status"]);
            prefs.setString(cnst.Session.gender, data.data[0]["gender"]);
            print(
                "id: ${prefs.getString(cnst.Session.id)} gender:${prefs.getString(cnst.Session.gender)}");
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Home()), (route) => false);
          }
          else {
            _toastMesssage("Invalid username or password");
          }
        }, onError: (e) {
          pr.hide();
          print("Something went wrong.");
        });
      }
    }catch(e){
      print(e);
      pr.hide();
      print("No Internet Connection");
    }
  }

  _toastMesssage(String message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white.withOpacity(0.3),
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

}
