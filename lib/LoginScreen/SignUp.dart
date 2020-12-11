import 'dart:async';
import 'dart:io';
import 'package:crunch/APIS/AppServices.dart';
import 'package:crunch/Common/CustomButton.dart';
import 'package:crunch/Screens/Home.dart';
import 'package:dio/dio.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../APIS/Constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Common/TextField.dart';
import 'package:flutter/material.dart';
import '../Static/Constant.dart' as cnst;
import 'Login.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  File _profileImage;
  var _image;
  TextEditingController Name = TextEditingController();
  TextEditingController Email = TextEditingController();
  TextEditingController Password = TextEditingController();
  TextEditingController ConfirmPassword = TextEditingController();
  TextEditingController Mobile = TextEditingController();
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
  }

  void _ImagePopup(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.camera_alt),
                    title: new Text('Camera'),
                    onTap: () async {
                      _image = await ImagePicker.pickImage(
                        source: ImageSource.camera,
                      );
                      Navigator.pop(context);
                      setState(() {
                        _profileImage = _image;
                      });
                    }),
                new ListTile(
                    leading: new Icon(Icons.photo),
                    title: new Text('Gallery'),
                    onTap: () async {
                      _image = await ImagePicker.pickImage(
                        source: ImageSource.gallery,
                      );
                      Navigator.pop(context);
                      setState(() {
                        _profileImage = _image;
                      });
                    }),
              ],
            ),
          );
        });
  }

  String gender = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
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
                      margin: EdgeInsets.only(top: 20.0),
                      width: 180,
                      height: 180,
                      child: Stack(
                        children: [
                          Container(
                            height: 170,
                            width: 170,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: cnst.AppColors.whitecolor.withOpacity(0.3),
                            ),
                            child: _profileImage == null
                                    ?Icon(Icons.person_outline_rounded,size: 50.0,color: cnst.AppColors.whitecolor,)
                                    :CircleAvatar(backgroundImage: FileImage(_profileImage),radius: 150.0,)
                          ),
                          Positioned(
                            bottom: -10,
                            right: -13,
                            child: GestureDetector(
                              onTap: () => _ImagePopup(context),
                              child: Container(
                                margin: EdgeInsets.all(25.0),
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: cnst.appPrimaryMaterialColor)),
                                child: Container(
                                  margin: EdgeInsets.all(3.0),
                                  width: 15,
                                  height: 15,
                                  decoration: BoxDecoration(
                                    color: cnst.appPrimaryMaterialColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.arrow_upward,color: cnst.AppColors.whitecolor,)
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 25.0,),
                    CustomTextField(hint: "Name",obtext: false,textcontroller: Name,textColor: cnst.AppColors.whitecolor,
                      texticon: Icon(Icons.person_outline_rounded,color: cnst.AppColors.whitecolor,size: 25.0),),
                    SizedBox(height: 13.0,),
                    CustomTextField(hint: "Email",obtext: false,textcontroller: Email,textColor: cnst.AppColors.whitecolor,
                      texticon: Icon(Icons.mail_outline_rounded,color: cnst.AppColors.whitecolor,size: 25.0),),
                    SizedBox(height: 13.0,),
                    buildRadioButton(size),
                    SizedBox(height: 13.0,),
                    CustomTextField(hint: "Mobile",obtext: false,textcontroller: Mobile,textColor: cnst.AppColors.whitecolor,
                      texticon: Icon(Icons.phone,color: cnst.AppColors.whitecolor,size: 25.0),),
                    SizedBox(height: 13.0,),
                    CustomTextField(hint: "Password",obtext: true,textcontroller: Password,textColor: cnst.AppColors.whitecolor,
                      texticon: Icon(Icons.lock_outline_rounded,color: cnst.AppColors.whitecolor,size: 25.0),),
                    SizedBox(height: 13.0,),
                    CustomTextField(hint: "Confirm Password",obtext: true,textcontroller: ConfirmPassword,textColor: cnst.AppColors.whitecolor,
                      texticon: Icon(Icons.lock_outline_rounded,color: cnst.AppColors.whitecolor,size: 25.0),),
                    SizedBox(height: 50.0,),
                    CustomButton(
                      title: "Sign UP",
                      btncolor: cnst.appPrimaryMaterialColor,
                      ontap: () {
                        userValidation();
                      },
                    ),
                    SizedBox(height: 30.0,),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                      },
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          "Already have an account? Login",
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
      ),
    );
  }

  userValidation() {
    if (Name.text == "") {
      _toastMesssage("Please enter your Name");
    } else if (Email.text == "") {
      _toastMesssage("please Enter your Email");
    } else if (gender == "") {
      _toastMesssage("please select your gender");
    } else if (Mobile.text == "") {
      _toastMesssage("please Enter your Mobile Number");
    } else if (Mobile.text.length != 10) {
      _toastMesssage("please enter Mobile Number 10 Digit");
    } else if (Password.text == "") {
      _toastMesssage("please Enter your password");
    } else if (ConfirmPassword.text == "") {
      _toastMesssage("please Enter your Confirm password");
    } else if (_profileImage == null) {
      _toastMesssage("please Select Image");
    } else if (Password.text != ConfirmPassword.text) {
      _toastMesssage("Your Password and Confirm Password not match");
    } else {
      userSignUp();
    }
  }

  userSignUp() async {
    try{
      pr.show();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        String filename = _image.path.split("/").last;
        String filePath = _image.path;
        print(Name.text+ " " +Email.text + " "+Mobile.text + " "+Password.text+" "+gender+ " "+fcm+ " "+filename);
        FormData d = FormData.fromMap({
          "api_key" : API_Key,
          "name": Name.text,
          "email" : Email.text,
          "mobile" : Mobile.text,
          "password" : Password.text,
          "gender" : gender,
          "token" : fcm,
          "image": await MultipartFile.fromFile(filePath, filename: filename),
        });

        AppServices.CustomerSignUp(d).then((data) async {
          pr.hide();
          if(data.value == "y") {
            print(data.data);
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
                "id: ${prefs.getString(cnst.Session.id)} gender:${prefs
                    .getString(cnst.Session.gender)}");
            Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(builder: (context) => Home()), (
                route) => false);
          } else {
            _toastMesssage(data.message);
          }
        },onError: (e) {
          pr.hide();
          _toastMesssage("Something went wrong.");
        });
      }
    }catch(e){
      pr.hide();
      _toastMesssage("No Internet Connection.");
    }
  }

  _toastMesssage(String message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black.withOpacity(0.3),
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  Container buildRadioButton(size,){
    return  Container(
      width: size.width *0.85,
      height: size.height * 0.07,
      decoration: BoxDecoration(
          color: cnst.AppColors.whitecolor.withOpacity(0.3),
          border: Border.all(color: cnst.AppColors.whitecolor.withOpacity(0.2), width: 1),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Row(
          children: [
            Container(
              width: size.width * 0.4,
              child: RadioListTile(
                groupValue: gender,
                title: Text('Male',style: TextStyle(color: cnst.AppColors.whitecolor,fontSize: 18.0),),
                value: 'Male',
                onChanged: (val) {
                  setState(() {
                    gender = val;
                  });
                },
              ),
            ),
            Container(
              width: size.width * 0.4,
              child: RadioListTile(
                groupValue: gender,
                title: Text('Female',style: TextStyle(color: cnst.AppColors.whitecolor,fontSize: 18.0),),
                value: 'Female',
                onChanged: (val) {
                  setState(() {
                    gender = val;
                  });
                },
              ),
            )
          ],
        )
      ),
    );
  }

}
