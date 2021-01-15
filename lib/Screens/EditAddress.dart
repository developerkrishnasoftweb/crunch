import 'dart:io';

import 'package:crunch/APIS/AppServices.dart';
import 'package:crunch/APIS/Constants.dart';
import 'package:crunch/Common/CustomButton.dart';
import 'package:crunch/Common/TextField.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Static/Constant.dart' as cnst;
import 'Address.dart';

class EditAddress extends StatefulWidget {
  var _addressdata;
  EditAddress(this._addressdata);
  @override
  _EditAddressState createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  TextEditingController edtaddress = TextEditingController();
  TextEditingController edtpincode = TextEditingController();
  TextEditingController edtcity = TextEditingController();
  TextEditingController edtstate = TextEditingController();
  TextEditingController edtcountry = TextEditingController();
  ProgressDialog pr;
  String addressid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Please wait..");
    _setData();
  }

  _setData() {
    addressid = widget._addressdata['id'];
    edtaddress.text = widget._addressdata['address'];
    edtpincode.text = widget._addressdata['pincode'];
    edtcity.text = widget._addressdata['city'];
    edtstate.text = widget._addressdata['state'];
    edtcountry.text = widget._addressdata['country'];
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
                textcontroller: edtaddress,
                obtext: false,
                hint: "Address",
                textColor: cnst.appPrimaryMaterialColor,
                borderside: 1.0,
              ),
              SizedBox(
                height: 16.0,
              ),
              CustomTextField(
                textcontroller: edtpincode,
                obtext: false,
                hint: "Pincode",
                textColor: cnst.appPrimaryMaterialColor,
                borderside: 1.0,
              ),
              SizedBox(
                height: 16.0,
              ),
              CustomTextField(
                textcontroller: edtcity,
                obtext: false,
                hint: "City",
                textColor: cnst.appPrimaryMaterialColor,
                borderside: 1.0,
              ),
              SizedBox(
                height: 16.0,
              ),
              CustomTextField(
                textcontroller: edtstate,
                obtext: false,
                hint: "State",
                textColor: cnst.appPrimaryMaterialColor,
                borderside: 1.0,
              ),
              SizedBox(
                height: 16.0,
              ),
              CustomTextField(
                textcontroller: edtcountry,
                obtext: false,
                hint: "Country",
                textColor: cnst.appPrimaryMaterialColor,
                borderside: 1.0,
              ),
              SizedBox(
                height: 16.0,
              ),
              CustomButton(
                title: "Update Address",
                btncolor: cnst.appPrimaryMaterialColor,
                ontap: () {
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
    if (edtaddress.text == "") {
      _toastMesssage("Please enter your Address");
    } else if (edtpincode.text == "") {
      _toastMesssage("please Enter your Postal Code");
    } else if (edtpincode.text.length != 6) {
      _toastMesssage("please Postal Code must be 6 digit");
    } else if (edtcity.text == "") {
      _toastMesssage("please Enter your City");
    } else if (edtstate.text == "") {
      _toastMesssage("please Enter your State");
    } else if (edtcountry.text == "") {
      _toastMesssage("please Enter your Country");
    } else {
      _updateAddress();
    }
  }

  _updateAddress() async {
    try {
      pr.show();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String id = prefs.getString(cnst.Session.id);
        print("address id :" +
            addressid +
            " " +
            id +
            " " +
            edtcountry.text +
            " " +
            edtpincode.text +
            " " +
            edtcity.text +
            " " +
            edtstate.text +
            " " +
            edtcountry.text);
        FormData d = FormData.fromMap({
          "api_key": API_Key,
          "address": edtaddress.text,
          "pincode": edtpincode.text,
          "city": edtcity.text,
          "state": edtstate.text,
          "country": edtcountry.text,
          "customer_id": id,
          "id": addressid,
        });

        AppServices.AddAddress(d).then((data) async {
          pr.hide();
          if (data.value == "y") {
            print(data.data);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("addId", data.data[0]["id"]);
            print("id: ${prefs.getString(cnst.Session.id)} ");
            _toastMesssage(data.message);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Address()),
                (route) => false);
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
