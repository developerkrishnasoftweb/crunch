import 'package:crunch/Common/CustomButton.dart';
import 'package:flutter/material.dart';

import '../Static/Constant.dart' as cnst;
import 'new_home.dart';

class SetLocation extends StatefulWidget {
  @override
  _SetLocationState createState() => _SetLocationState();
}

class _SetLocationState extends State<SetLocation> {
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
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.7), BlendMode.softLight),
              ),
            ),
            child: Container(
              height: size.height,
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 0),
              child: Stack(
                children: [
                  Positioned(
                      top: 50,
                      right: 0,
                      child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          elevation: 5.0,
                          height: size.height * 0.05,
                          minWidth: size.width * 0.15,
                          color: cnst.AppColors.whitecolor.withOpacity(0.3),
                          child: new Text("Skip",
                              style: new TextStyle(
                                  fontSize: 16.0, color: Colors.white)),
                          onPressed: () => Navigator.pop(context))),
                  Align(
                    alignment: Alignment(-0.5, -0.001),
                    child: Container(
                        width: size.width * 0.7,
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(fontSize: 45.0),
                            text: 'Hi John',
                            children: <TextSpan>[
                              TextSpan(text: '\nWelcome to'),
                              TextSpan(
                                  text: '\nCrunch',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        )),
                  ),
                  Align(
                    alignment: Alignment(0.0, 0.5),
                    child: Container(
                        width: size.width * 0.78,
                        child: Text(
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        )),
                  ),
                  Positioned(
                    left: 0,
                    bottom: 25,
                    right: 0,
                    child: CustomButton(
                        title: "TurnOnGPS",
                        btncolor: cnst.appPrimaryMaterialColor,
                        ontap: () => Navigator.pop(context)),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
