import 'dart:io';

import 'package:crunch/APIS/AppServices.dart';
import 'package:crunch/APIS/Constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Common/CustomButton.dart';
import '../Common/TextField.dart';
import '../Static/Constant.dart' as cnst;

class Add_Address extends StatefulWidget {
  @override
  _Add_AddressState createState() => _Add_AddressState();
}

class _Add_AddressState extends State<Add_Address> {
  TextEditingController address1 = TextEditingController();
  TextEditingController address2 = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController contactPerson = TextEditingController();
  TextEditingController contactNumber = TextEditingController();
  TextEditingController landmark = TextEditingController();
  ProgressDialog pr;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Please wait..");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          "Add New Address",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
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
                textcontroller: contactPerson,
                obtext: false,
                hint: "Name *",
                textColor: cnst.appPrimaryMaterialColor.withOpacity(0.5),
                borderside: 1.0,
              ),
              SizedBox(
                height: 16.0,
              ),
              CustomTextField(
                textcontroller: contactNumber,
                obtext: false,
                hint: "Number *",
                textColor: cnst.appPrimaryMaterialColor.withOpacity(0.5),
                borderside: 1.0,
              ),
              SizedBox(
                height: 16.0,
              ),
              CustomTextField(
                textcontroller: address1,
                obtext: false,
                hint: "Address 1 *",
                textColor: cnst.appPrimaryMaterialColor.withOpacity(0.5),
                borderside: 1.0,
              ),
              SizedBox(
                height: 16.0,
              ),
              CustomTextField(
                textcontroller: address2,
                obtext: false,
                hint: "Address 2 *",
                textColor: cnst.appPrimaryMaterialColor.withOpacity(0.5),
                borderside: 1.0,
              ),
              SizedBox(
                height: 16.0,
              ),
              CustomTextField(
                textcontroller: landmark,
                obtext: false,
                hint: "Landmark *",
                textColor: cnst.appPrimaryMaterialColor.withOpacity(0.5),
                borderside: 1.0,
              ),
              SizedBox(
                height: 16.0,
              ),
              CustomTextField(
                textcontroller: pincode,
                obtext: false,
                hint: "Pincode *",
                textColor: cnst.appPrimaryMaterialColor.withOpacity(0.5),
                borderside: 1.0,
              ),
              SizedBox(
                height: 16.0,
              ),
              CustomTextField(
                textcontroller: city,
                obtext: false,
                hint: "City *",
                textColor: cnst.appPrimaryMaterialColor.withOpacity(0.5),
                borderside: 1.0,
              ),
              SizedBox(
                height: 16.0,
              ),
              CustomButton(
                title: "Add Address",
                btncolor: cnst.appPrimaryMaterialColor,
                ontap: () {
                  FocusScope.of(context).unfocus();
                  Validation();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Validation() {
    if (address1.text.isNotEmpty &&
        address2.text.isNotEmpty &&
        landmark.text.isNotEmpty &&
        contactPerson.text.isNotEmpty &&
        contactNumber.text.isNotEmpty &&
        pincode.text.isNotEmpty &&
        city.text.isNotEmpty) {
      _addAddress();
    } else {
      Fluttertoast.showToast(msg: "All fields are require");
    }
  }

  _addAddress() async {
    try {
      pr.show();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String id = prefs.getString(cnst.Session.id);
        FormData d = FormData.fromMap({
          "api_key": API_Key,
          "address1": address1.text,
          "address2": address2.text,
          "pincode": pincode.text,
          "city": city.text,
          "contact_person": contactPerson.text,
          "contact_number": contactNumber.text,
          "landmark": landmark.text,
          "customer_id": id,
        });
        AppServices.AddAddress(d).then((data) async {
          pr.hide();
          if (data.value == "y") {
            print(data.data);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("addId", data.data[0]["id"]);
            print("id: ${prefs.getString(cnst.Session.id)} ");
            _toastMesssage(data.message);
            Navigator.pop(context);
          }
        }, onError: (e) {
          pr.hide();
          _toastMesssage("Something went wrong.");
        });
      }
    } catch (e) {
      pr.hide();
      _toastMesssage("No Internet Connection.");
    }
  }

  _toastMesssage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black.withOpacity(0.3),
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
