import 'dart:io';

import 'package:crunch/APIS/AppServices.dart';
import 'package:crunch/APIS/Constants.dart';
import 'package:crunch/Common/CustomButton.dart';
import 'package:crunch/Common/TextField.dart';
import 'package:crunch/Screens/checkout.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Static/Constant.dart' as cnst;
import 'Address.dart';

class EditAddress extends StatefulWidget {
  final Addresses _addressdata;
  EditAddress(this._addressdata);
  @override
  _EditAddressState createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  TextEditingController edtaddress = TextEditingController();
  TextEditingController edtpincode = TextEditingController();
  TextEditingController edtcity = TextEditingController();
  TextEditingController contactPerson = TextEditingController();
  TextEditingController contactNumber = TextEditingController();
  TextEditingController landmark = TextEditingController();
  TextEditingController address2 = TextEditingController();
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
    addressid = widget._addressdata.id;
    edtaddress.text = widget._addressdata.address1;
    edtpincode.text = widget._addressdata.pinCode;
    edtcity.text = widget._addressdata.city;
    address2.text = widget._addressdata.address2;
    contactPerson.text = widget._addressdata.contactPerson;
    contactNumber.text = widget._addressdata.contactNumber;
    landmark.text = widget._addressdata.landmark;
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
                hint: "Name",
                textColor: cnst.appPrimaryMaterialColor,
                borderside: 1.0,
              ),
              SizedBox(
                height: 16.0,
              ),
              CustomTextField(
                textcontroller: contactNumber,
                obtext: false,
                hint: "Number",
                textColor: cnst.appPrimaryMaterialColor,
                borderside: 1.0,
              ),
              SizedBox(
                height: 16.0,
              ),
              CustomTextField(
                textcontroller: edtaddress,
                obtext: false,
                hint: "Address1",
                textColor: cnst.appPrimaryMaterialColor,
                borderside: 1.0,
              ),
              SizedBox(
                height: 16.0,
              ),
              CustomTextField(
                textcontroller: address2,
                obtext: false,
                hint: "Address2",
                textColor: cnst.appPrimaryMaterialColor,
                borderside: 1.0,
              ),
              SizedBox(
                height: 16.0,
              ),
              CustomTextField(
                textcontroller: landmark,
                obtext: false,
                hint: "Landmark",
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
    if (edtaddress.text.isNotEmpty &&
        address2.text.isNotEmpty &&
        edtpincode.text.isNotEmpty &&
        contactNumber.text.isNotEmpty &&
        contactPerson.text.isNotEmpty &&
        landmark.text.isNotEmpty) {
      _updateAddress();
    } else {
      Fluttertoast.showToast(msg: "All fields are required");
    }
  }

  _updateAddress() async {
    try {
      pr.show();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String id = prefs.getString(cnst.Session.id);
        FormData d = FormData.fromMap({
          "api_key": API_Key,
          "address1": edtaddress.text,
          "address2": address2.text,
          "pincode": edtpincode.text,
          "city": edtcity.text,
          "contact_person": contactPerson.text,
          "contact_number": contactNumber.text,
          "landmark": landmark.text,
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
