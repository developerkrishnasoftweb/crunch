import 'package:crunch/Common/CustomButton.dart';
import 'package:crunch/Common/TextField.dart';
import 'package:crunch/LoginScreen/SignUp.dart';
import 'package:crunch/Screens/ChangePassword.dart';
import 'package:crunch/Screens/Home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Static/Constant.dart' as cnst;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController Email = TextEditingController();
  TextEditingController Password = TextEditingController();

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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePassword()));
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
                  ontap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>Home()))
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
}
