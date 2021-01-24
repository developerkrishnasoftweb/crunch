import 'dart:io';

import 'package:crunch/APIS/AppServices.dart';
import 'package:crunch/APIS/Constants.dart';
import 'package:crunch/Static/Constant.dart' as cnst;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'Add_Address.dart';
import 'new_home.dart';

class Checkout extends StatefulWidget {
  final double grandTotal;
  Checkout({this.grandTotal});
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  bool isLoading = false;
  List<Addresses> _address = [];
  PAYMENTMETHOD _paymentMethod = PAYMENTMETHOD.CASHONDELIVERY;
  Addresses address;
  // static const platform = const MethodChannel("razorpay_flutter");
  Razorpay _razorpay;
  String mobile = "", email = "";

  @override
  void initState() {
    super.initState();
    getUserData();
    getAddresses();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_tCWge1Ntpmfg1d',
      'amount': widget.grandTotal * 100,
      'name': 'Crunch',
      'description': 'Fresh Foods',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/mytestApp.appspot.com/o/images%2FpZm8daajsIS4LvqBYTiWiuLIgmE2?alt=media&token=3kuli4cd-dc45-7845-b87d-5c4acc7da3c2',
      'prefill': {'contact': mobile, 'email': email},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    String databasePath = await getDatabasesPath();
    Database db = await openDatabase(databasePath + 'myDb.db',
        version: 1, onCreate: (Database db, int version) async {});
    await db.rawQuery("delete from ${SQFLiteTables.tableCart}");
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => Home()), (route) => false);
    Fluttertoast.showToast(msg: "SUCCESS: " + response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "EXTERNAL_WALLET: " + response.walletName);
  }

  void getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      mobile = sharedPreferences.getString(cnst.Session.mobile);
      email = sharedPreferences.getString(cnst.Session.email);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Checkout",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: cnst.appPrimaryMaterialColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Select Payment Mode",
              style: TextStyle(fontSize: 18),
            ),
          ),
          RadioListTile<PAYMENTMETHOD>(
            title: Text("Cash on delivery"),
            value: PAYMENTMETHOD.CASHONDELIVERY,
            groupValue: _paymentMethod,
            onChanged: (value) {
              setState(() {
                _paymentMethod = value;
              });
            },
          ),
          RadioListTile<PAYMENTMETHOD>(
            title: Text("Razor pay"),
            value: PAYMENTMETHOD.RAZORPAY,
            groupValue: _paymentMethod,
            onChanged: (value) {
              setState(() {
                _paymentMethod = value;
              });
            },
          ),
          ListTile(
            title: Text(
              "Select Address",
              style: TextStyle(fontSize: 18),
            ),
            trailing: IconButton(
              icon: Icon(Icons.add),
              splashRadius: 25,
              color: cnst.appPrimaryMaterialColor,
              onPressed: () {
                Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Add_Address()))
                    .then((value) {
                  getAddresses();
                });
              },
            ),
          ),
          Expanded(
              child: _address.length > 0
                  ? ListView.builder(
                      itemCount: _address.length,
                      padding: EdgeInsets.only(bottom: 70),
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return RadioListTile<Addresses>(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _address[index].contactPerson,
                                  style: TextStyle(fontWeight: FontWeight.bold),
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
                            value: _address[index],
                            groupValue: address,
                            onChanged: (value) {
                              setState(() {
                                address = value;
                              });
                            });
                      })
                  : Center(
                      child: CircularProgressIndicator(),
                    )),
        ],
      ),
      floatingActionButton: address != null
          ? Container(
              width: size.width * 0.9,
              height: 50,
              child: FlatButton(
                child: Text(
                  "Make Payment",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: _makePayment,
                color: cnst.appPrimaryMaterialColor,
              ))
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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

  _makePayment() async {
    if (_paymentMethod == PAYMENTMETHOD.RAZORPAY) {
      openCheckout();
    } else {}
  }
}

enum PAYMENTMETHOD { CASHONDELIVERY, RAZORPAY }

class Addresses {
  final String id,
      customerId,
      address1,
      address2,
      contactPerson,
      contactNumber,
      landmark,
      pinCode,
      city;
  Addresses(
      {this.customerId,
      this.city,
      this.id,
      this.address1,
      this.address2,
      this.contactNumber,
      this.contactPerson,
      this.landmark,
      this.pinCode});
}
