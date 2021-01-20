import 'dart:io';

import 'package:crunch/APIS/AppServices.dart';
import 'package:crunch/Static/Constant.dart' as cnst;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Checkout extends StatefulWidget {
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

  @override
  void initState() {
    super.initState();
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
      'amount': 2000,
      'name': 'Krishna Softweb',
      'description': 'Fine T-Shirt',
      'image' : 'https://firebasestorage.googleapis.com/v0/b/mytestApp.appspot.com/o/images%2FpZm8daajsIS4LvqBYTiWiuLIgmE2?alt=media&token=3kuli4cd-dc45-7845-b87d-5c4acc7da3c2',
      'prefill': {'contact': '8758431417', 'email': 'gaurav@razorpay.com'},
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

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName);
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Select Address",
              style: TextStyle(fontSize: 18),
            ),
          ),
          Expanded(
              child: _address.length > 0
                  ? ListView.builder(
                      itemCount: _address.length,
                      itemBuilder: (context, index) {
                        return RadioListTile<Addresses>(
                            title: Text(_address[index].address + ", " +
                                _address[index].city +
                                ", " +
                                _address[index].state +
                                ", " +
                                _address[index].state +
                                ", " +
                                _address[index].country +
                                " - " +
                                _address[index].pinCode),
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
      floatingActionButton: address != null ? Container(
          width: size.width * 0.9,
          height: 50,
          child: FlatButton(
            child: Text("Make Payment", style: TextStyle(color: Colors.white),),
            onPressed: _makePayment,
            color: cnst.appPrimaryMaterialColor,
          )) : null,
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
        });
        AppServices.getAddress(d).then((data) async {
          if (data.value == "y") {
            setState(() {
              isLoading = false;
            });
            for (int i = 0; i < data.data.length; i++) {
              setState(() {
                _address.add(Addresses(
                    address: data.data[i]["address"],
                    city: data.data[i]["city"],
                    country: data.data[i]["country"],
                    customerId: data.data[i]["customer_id"],
                    id: data.data[i]["id"],
                    pinCode: data.data[i]["pincode"],
                    state: data.data[i]["state"]));
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
  _makePayment () async {
    if(_paymentMethod == PAYMENTMETHOD.RAZORPAY) {
      openCheckout();
    }
  }
}

enum PAYMENTMETHOD { CASHONDELIVERY, RAZORPAY }

class Addresses {
  final String id, customerId, address, pinCode, city, state, country;
  Addresses(
      {this.customerId,
      this.address,
      this.city,
      this.country,
      this.id,
      this.pinCode,
      this.state});
}
