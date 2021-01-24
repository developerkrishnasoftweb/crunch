import 'dart:io';

import 'package:crunch/Screens/EditAddress.dart';
import 'package:crunch/Screens/checkout.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../APIS/AppServices.dart';
import '../Static/Constant.dart' as cnst;
import 'Add_Address.dart';

class Address extends StatefulWidget {
  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  bool isLoading = true;
  List<Addresses> _address = List();
  ProgressDialog pr;
  Addresses address;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Please wait..");
    getAddresses();
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
        elevation: 1.0,
        title: Text(
          "Address",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: _address.length > 0
          ? SingleChildScrollView(
              child: Container(
                  width: size.width,
                  height: size.height,
                  padding: EdgeInsets.symmetric(horizontal: 17, vertical: 5.0),
                  child: ListView.builder(
                      itemCount: _address.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, bottom: 10.0, left: 7.0, right: 7.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: size.width * 0.55,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _address[index].contactPerson,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        _address[index].address1 +
                                            ", " +
                                            _address[index].address2 +
                                            "\n" +
                                            _address[index].landmark +
                                            "\n" +
                                            _address[index].city +
                                            " - " +
                                            _address[index].pinCode,
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        _address[index].contactNumber,
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditAddress(
                                                            _address[index],
                                                          )));
                                            }),
                                        IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () {
                                              _deleteAddress(
                                                  _address[index].id);
                                            }),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      })),
            )
          : Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Add_Address()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  getAddresses() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String id = prefs.getString(cnst.Session.id);
        FormData d = FormData.fromMap({
          "api_key": "0imfnc8mVLWwsAawjYr4Rx",
          "customer_id": id,
        });
        setState(() {
          isLoading = true;
          _address = [];
        });
        AppServices.getAddress(d).then((data) async {
          if (data.value == "y") {
            setState(() {
              isLoading = false;
            });
            for (int i = 0; i < data.data.length; i++) {
              setState(() {
                _address.add(Addresses(
                    address1: data.data[i]["address1"],
                    address2: data.data[i]["address2"],
                    city: data.data[i]["city"],
                    customerId: data.data[i]["customer_id"],
                    id: data.data[i]["id"],
                    contactPerson: data.data[i]["contact_person"],
                    contactNumber: data.data[i]["contact_number"],
                    landmark: data.data[i]["landmark"],
                    pinCode: data.data[i]["pincode"]));
              });
            }
            setState(() {
              address = _address[0];
            });
          } else {
            setState(() {
              isLoading = false;
              _address.clear();
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: "Something went wrong.");
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "No Internet Connection.");
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

  _deleteAddress(String id) async {
    try {
      pr.show();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData d = FormData.fromMap({
          "api_key": "0imfnc8mVLWwsAawjYr4Rx",
          "id": id,
        });
        setState(() {
          isLoading = true;
        });
        print("id is " + id);
        AppServices.deleteAddress(d).then((data) async {
          pr.hide();
          if (data.value == "y") {
            _toastMesssage(data.message);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Address()));
          } else {
            _toastMesssage("Something went wrong.");
          }
        }, onError: (e) {
          pr.hide();
          _toastMesssage("Something went wrong.");
        });
      }
    } on SocketException catch (_) {
      pr.hide();
      _toastMesssage("No Internet Connection.");
    }
  }
}
