import 'package:crunch/Common/CustomButton.dart';
import 'package:crunch/Common/TextField.dart';
import 'package:crunch/Screens/Home.dart';
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
      appBar: AppBar(
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_sharp,color: Colors.black,)),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text("Change Password",style: TextStyle(color: Colors.black),),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(right:10.0,top: 15.0),
              child: Text("cancel",style: TextStyle(fontSize: 20.0,color: cnst.AppColors.blackcolor),),
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
              SizedBox(height: 16.0,),
              CustomTextField(textcontroller: CurrentPassword,obtext: true,hint: "Current Password", textColor: cnst.appPrimaryMaterialColor,
                  texticon: Icon(Icons.lock_outline_rounded,color: cnst.appPrimaryMaterialColor,size: 25.0),borderside: 1.0,
              ),
              SizedBox(height: 16.0,),
              CustomTextField(textcontroller: NewPassword,obtext: true,hint: "New Password", textColor: cnst.appPrimaryMaterialColor,
                texticon: Icon(Icons.lock_outline_rounded,color: cnst.appPrimaryMaterialColor,size: 25.0),borderside: 1.0,),
              SizedBox(height: 16.0,),
              CustomTextField(textcontroller: ConfirmPassword,obtext: true,hint: "Confirm Password", textColor: cnst.appPrimaryMaterialColor,
                texticon: Icon(Icons.lock_outline_rounded,color: cnst.appPrimaryMaterialColor,size: 25.0),borderside: 1.0,),
              SizedBox(height: 16.0,),
              CustomButton(
                title: "Update",btncolor: cnst.appPrimaryMaterialColor,
                // ontap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>Home()))
              ),
            ],
          ),
        ),
      ),
    );
  }
}
