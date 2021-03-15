import 'dart:io';

import 'package:crunch/Screens/EditAddress.dart';
import 'package:crunch/Screens/checkout.dart';
import 'package:crunch/Static/global.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  Addresses address;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAddresses();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: cnst.primaryColor,
        elevation: 1.0,
        title: Text(
          "Address",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
      ),
      body: _address.length != 0
          ? ListView.builder(
              itemCount: _address.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _address[index].contactPerson,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
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
                              maxLines: 3,
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              _address[index].contactNumber,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                        IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditAddress(
                                            _address[index],
                                          )));
                            }),
                        IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deleteAddress(_address[index]);
                            }),
                      ],
                    ),
                  ),
                );
              })
          : Center(child: Text("No address available")),
      floatingActionButton: FloatingActionButton(
        onPressed: isLoading
            ? null
            : () {
                Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Add_Address()))
                    .then((value) {
                  getAddresses();
                });
              },
        child: isLoading
            ? SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                  strokeWidth: 1.5,
                ),
              )
            : Icon(Icons.add),
      ),
    );
  }

  getAddresses() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData d = FormData.fromMap({
          "api_key": "0imfnc8mVLWwsAawjYr4Rx",
          "customer_id": userdata.id,
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

  toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black.withOpacity(0.3),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  _deleteAddress(Addresses addresses) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData d = FormData.fromMap({
          "api_key": "0imfnc8mVLWwsAawjYr4Rx",
          "id": addresses.id,
        });
        setState(() {
          isLoading = true;
        });
        AppServices.deleteAddress(d).then((data) async {
          if (data.value == "y") {
            toastMessage(data.message);
            _address.remove(addresses);
            setState(() {
              isLoading = false;
            });
          } else {
            toastMessage("Something went wrong.");
            setState(() {
              isLoading = false;
            });
          }
        });
      }
    } on SocketException catch (_) {
      toastMessage("No Internet Connection");
      setState(() {
        isLoading = false;
      });
    }
  }
}
