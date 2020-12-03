import 'package:flutter/material.dart';
import '../Static/Constant.dart' as cnst;

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_sharp,color: Colors.black,)),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text("Review & Ratings",style: TextStyle(color: Colors.black),),
        centerTitle: true,
      ),
    );
  }
}
