import 'dart:io';

import 'package:crunch/APIS/AppServices.dart';
import 'package:crunch/APIS/tables.dart';
import 'package:crunch/Static/global.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 16.0,
              width: size.width,
            ),
            CustomTextField(
              textcontroller: contactPerson,
              obtext: false,
              hint: "Name *",
              textColor: cnst.primaryColor.withOpacity(0.5),
              borderside: 1.0,
            ),
            SizedBox(
              height: 16.0,
            ),
            CustomTextField(
              textcontroller: contactNumber,
              obtext: false,
              hint: "Number *",
              textColor: cnst.primaryColor.withOpacity(0.5),
              borderside: 1.0,
            ),
            SizedBox(
              height: 16.0,
            ),
            CustomTextField(
              textcontroller: address1,
              obtext: false,
              hint: "Address 1 *",
              textColor: cnst.primaryColor.withOpacity(0.5),
              borderside: 1.0,
            ),
            SizedBox(
              height: 16.0,
            ),
            CustomTextField(
              textcontroller: address2,
              obtext: false,
              hint: "Address 2 *",
              textColor: cnst.primaryColor.withOpacity(0.5),
              borderside: 1.0,
            ),
            SizedBox(
              height: 16.0,
            ),
            CustomTextField(
              textcontroller: landmark,
              obtext: false,
              hint: "Landmark *",
              textColor: cnst.primaryColor.withOpacity(0.5),
              borderside: 1.0,
            ),
            SizedBox(
              height: 16.0,
            ),
            CustomTextField(
              textcontroller: pincode,
              obtext: false,
              hint: "Pincode *",
              textColor: cnst.primaryColor.withOpacity(0.5),
              borderside: 1.0,
            ),
            SizedBox(
              height: 16.0,
            ),
            CustomTextField(
              textcontroller: city,
              obtext: false,
              hint: "City *",
              textColor: cnst.primaryColor.withOpacity(0.5),
              borderside: 1.0,
            ),
            SizedBox(
              height: 16.0,
            ),
            CustomButton(
              title: "Add Address",
              btncolor: cnst.primaryColor,
              ontap: () {
                FocusScope.of(context).unfocus();
                Validation();
              },
            ),
          ],
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
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData d = FormData.fromMap({
          "api_key": API_Key,
          "address1": address1.text,
          "address2": address2.text,
          "pincode": pincode.text,
          "city": city.text,
          "contact_person": contactPerson.text,
          "contact_number": contactNumber.text,
          "landmark": landmark.text,
          "customer_id": userdata.id,
        });
        AppServices.AddAddress(d).then((data) async {
          if (data.value == "y") {
            _toastMesssage(data.message);
            Navigator.pop(context);
          }
        }, onError: (e) {
          _toastMesssage("Something went wrong.");
        });
      }
    } catch (e) {
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
