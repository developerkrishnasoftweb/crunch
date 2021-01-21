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
import 'Address.dart';

class Add_Address extends StatefulWidget {
  final bool isFromCheckout;
  Add_Address({this.isFromCheckout : false});
  @override
  _Add_AddressState createState() => _Add_AddressState();
}

class _Add_AddressState extends State<Add_Address> {
  TextEditingController address = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController country = TextEditingController();
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
                textcontroller: address,
                obtext: false,
                hint: "Address",
                textColor: cnst.appPrimaryMaterialColor.withOpacity(0.5),
                borderside: 1.0,
              ),
              SizedBox(
                height: 16.0,
              ),
              CustomTextField(
                textcontroller: pincode,
                obtext: false,
                hint: "Pincode",
                textColor: cnst.appPrimaryMaterialColor.withOpacity(0.5),
                borderside: 1.0,
              ),
              SizedBox(
                height: 16.0,
              ),
              CustomTextField(
                textcontroller: city,
                obtext: false,
                hint: "City",
                textColor: cnst.appPrimaryMaterialColor.withOpacity(0.5),
                borderside: 1.0,
              ),
              SizedBox(
                height: 16.0,
              ),
              CustomTextField(
                textcontroller: state,
                obtext: false,
                hint: "State",
                textColor: cnst.appPrimaryMaterialColor.withOpacity(0.5),
                borderside: 1.0,
              ),
              SizedBox(
                height: 16.0,
              ),
              CustomTextField(
                textcontroller: country,
                obtext: false,
                hint: "Country",
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
    if (address.text == "") {
      _toastMesssage("Please enter your Address");
    } else if (pincode.text == "") {
      _toastMesssage("please Enter your Postal Code");
    } else if (pincode.text.length != 6) {
      _toastMesssage("please Postal Code must be 6 digit");
    } else if (city.text == "") {
      _toastMesssage("please Enter your City");
    } else if (state.text == "") {
      _toastMesssage("please Enter your State");
    } else if (country.text == "") {
      _toastMesssage("please Enter your Country");
    } else {
      _addAddress();
    }
  }

  _addAddress() async {
    try {
      pr.show();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String id = prefs.getString(cnst.Session.id);
        print(id +
            " " +
            address.text +
            " " +
            pincode.text +
            " " +
            city.text +
            " " +
            state.text +
            " " +
            country.text);
        FormData d = FormData.fromMap({
          "api_key": API_Key,
          "address": address.text,
          "pincode": pincode.text,
          "city": city.text,
          "state": state.text,
          "country": country.text,
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
            if(widget.isFromCheckout) {
              Navigator.pop(context);
            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Address()),
                      (route) => false);
            }
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
