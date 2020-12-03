import 'package:crunch/Common/CustomButton.dart';
import 'package:crunch/Screens/Home.dart';

import '../Common/TextField.dart';
import 'package:flutter/material.dart';
import '../Static/Constant.dart' as cnst;
import 'Login.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  TextEditingController Name = TextEditingController();
  TextEditingController Email = TextEditingController();
  TextEditingController Password = TextEditingController();
  TextEditingController ConfirmPassword = TextEditingController();


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
                    margin: EdgeInsets.only(top: 20.0),
                    width: 180,
                    height: 180,
                    child: Stack(
                      children: [
                        Container(
                          height: 180,
                          width: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: cnst.AppColors.whitecolor.withOpacity(0.3),
                          ),
                          child: Icon(Icons.person_outline_rounded,size: 50.0,color: cnst.AppColors.whitecolor,),
                        ),
                        Positioned(
                          bottom: -18,
                          right: -15,
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
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 50.0,),
                  CustomTextField(hint: "Name",obtext: false,textcontroller: Name,textColor: cnst.AppColors.whitecolor,
                    texticon: Icon(Icons.person_outline_rounded,color: cnst.AppColors.whitecolor,size: 25.0),),
                  SizedBox(height: 16.0,),
                  CustomTextField(hint: "Email",obtext: false,textcontroller: Email,textColor: cnst.AppColors.whitecolor,
                    texticon: Icon(Icons.mail_outline_rounded,color: cnst.AppColors.whitecolor,size: 25.0),),
                  SizedBox(height: 16.0,),
                  CustomTextField(hint: "Password",obtext: true,textcontroller: Password,textColor: cnst.AppColors.whitecolor,
                    texticon: Icon(Icons.lock_outline_rounded,color: cnst.AppColors.whitecolor,size: 25.0),),
                  SizedBox(height: 16.0,),
                  CustomTextField(hint: "Confirm Password",obtext: true,textcontroller: ConfirmPassword,textColor: cnst.AppColors.whitecolor,
                    texticon: Icon(Icons.lock_outline_rounded,color: cnst.AppColors.whitecolor,size: 25.0),),
                  SizedBox(height: 75.0,),
                  CustomButton(
                    title: "Sign UP",
                    btncolor: cnst.appPrimaryMaterialColor,
                    ontap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>Home()))
                  ),
                  SizedBox(height: 50.0,),
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
    );
  }
}
