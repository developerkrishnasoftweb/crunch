import 'package:crunch/Common/CustomButton.dart';
import 'package:crunch/Common/TextField.dart';
import 'package:crunch/Screens/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../Static/Constant.dart' as cnst;

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController CurrentPassword = TextEditingController();
  TextEditingController NewPassword = TextEditingController();
  TextEditingController ConfirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(
        context: context,
        title: "Change Password",
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0, top: 15.0),
              child: Text(
                "cancel",
                style:
                    TextStyle(fontSize: 20.0, color: cnst.AppColors.blackcolor),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 16.0,
              ),
              CustomTextField(
                textcontroller: CurrentPassword,
                obtext: true,
                hint: "Current Password",
                textColor: cnst.primaryColor,
                texticon: Icon(Icons.lock_outline,
                    color: cnst.primaryColor, size: 25.0),
                borderside: 1.0,
              ),
              SizedBox(
                height: 16.0,
              ),
              CustomTextField(
                textcontroller: NewPassword,
                obtext: true,
                hint: "New Password",
                textColor: cnst.primaryColor,
                texticon: Icon(Icons.lock_outline,
                    color: cnst.primaryColor, size: 25.0),
                borderside: 1.0,
              ),
              SizedBox(
                height: 16.0,
              ),
              CustomTextField(
                textcontroller: ConfirmPassword,
                obtext: true,
                hint: "Confirm Password",
                textColor: cnst.primaryColor,
                texticon: Icon(Icons.lock_outline,
                    color: cnst.primaryColor, size: 25.0),
                borderside: 1.0,
              ),
              SizedBox(
                height: 16.0,
              ),
              CustomButton(
                title: "Update", btncolor: cnst.primaryColor,
                // ontap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>Home()))
              ),
            ],
          ),
        ),
      ),
    );
  }
}
