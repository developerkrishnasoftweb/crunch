import 'dart:convert';

import 'package:crunch/APIS/AppServices.dart';
import 'package:crunch/APIS/tables.dart';
import 'package:crunch/Common/classes.dart';
import 'package:crunch/Screens/my_orders.dart';
import 'package:crunch/Static/Constant.dart' as cnst;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'Add_Address.dart';

class Checkout extends StatefulWidget {
  final double grandTotal, couponAmount;
  final List<CartData> cartItems;
  final String couponCode;
  Checkout(
      {@required this.grandTotal,
      @required this.cartItems,
      this.couponAmount: 0.0,
      this.couponCode: ""});
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  bool isLoading = false;
  List<Addresses> _address = [];
  List<Map<String, dynamic>> items = [];
  PAYMENTMETHOD _paymentMethod = PAYMENTMETHOD.CASHONDELIVERY;
  Addresses address;
  // static const platform = const MethodChannel("razorpay_flutter");
  Razorpay _razorpay;
  String mobile = "", email = "";
  double sgst = 0, cgst = 0, taxTotal = 0, total = 0, grandTotal = 0.0;
  var config;
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
      'amount': grandTotal.ceil() * 100,
      'name': 'Crunch',
      'description': 'Fresh Foods',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/mytestApp.appspot.com/o/images%2FpZm8daajsIS4LvqBYTiWiuLIgmE2?alt=media&token=3kuli4cd-dc45-7845-b87d-5c4acc7da3c2',
      'prefill': {'contact': mobile, 'email': email},
      'external': {
        'wallets': ['paytm']
      }
    };
    print(options);
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  clearCart() async {
    String databasePath = await getDatabasesPath();
    Database db = await openDatabase(databasePath + 'myDb.db',
        version: 1, onCreate: (Database db, int version) async {});
    await db.rawQuery("delete from ${SQFLiteTables.tableCart}");
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyOrders()));
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String customerId = prefs.getString(cnst.Session.id);
    FormData formData = FormData.fromMap({
      "address_id": address.id,
      "customer_id": customerId,
      "delivery_charges": config["delivery_charge"],
      "packing_charges": config["packing_charge"],
      "discount_total": "0",
      "description": "",
      "tax_total": taxTotal,
      "total": grandTotal,
      "api_key": "0imfnc8mVLWwsAawjYr4Rx",
      "payment_type": "PPD",
      "payment_id": response.paymentId,
      "items": items,
      "coupon_applied": widget.couponCode,
      "coupon_amount": widget.couponAmount
    });
    AppServices.saveOrder(formData).then((value) {
      if (value.value == "true") {
        clearCart();
        Fluttertoast.showToast(msg: value.message);
      } else {
        Fluttertoast.showToast(msg: value.message);
      }
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "Payment Failed");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "Something went wrong");
  }

  void getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      config = jsonDecode(sharedPreferences.getString("config"));
      mobile = sharedPreferences.getString(cnst.Session.mobile);
      email = sharedPreferences.getString(cnst.Session.email);
      sgst = double.parse(config["sgst"]);
      cgst = double.parse(config["cgst"]);
      taxTotal = widget.grandTotal * (sgst + cgst) / 100;
      total = taxTotal + widget.grandTotal;
      grandTotal =
          (((widget.grandTotal + (widget.grandTotal * (cgst + sgst)) / 100) -
                  widget.couponAmount) +
              (double.parse(config["packing_charge"].toString() ?? "0") +
                  double.parse(config["delivery_charge"].toString() ?? "0")));
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
      body: isLoading ? Center(child: CircularProgressIndicator()) : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildRow("CART VALUE", widget.grandTotal.toStringAsFixed(2)),
          buildRow("PACKING CHARGES", "+ " + config["packing_charge"] ?? "0"),
          buildRow("DELIVERY CHARGES", "+ " + config["delivery_charge"] ?? "0"),
          buildRow("SGST($sgst%)",
              "+${((widget.grandTotal * sgst) / 100).toStringAsFixed(2)}"),
          buildRow("CGST($cgst%)",
              "+${((widget.grandTotal * cgst) / 100).toStringAsFixed(2)}"),
          buildRow("COUPONS", "-" + widget.couponAmount.toString()),
          Divider(
            indent: 8,
            endIndent: 8,
            height: 2,
            thickness: 2,
            color: cnst.appPrimaryMaterialColor,
          ),
          buildRow(
            "Total",
            grandTotal.toStringAsFixed(2),
          ),
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
              child: _address != null
                  ? _address.length > 0
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
                        )
                  : Center(
                      child: Text("No address available"),
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
                onPressed: makePayment,
                color: cnst.appPrimaryMaterialColor,
              ))
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  getAddresses() async {
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
          _address = null;
        });
      }
    });
  }

  makePayment() async {
    setState(() {
      items = [];
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String customerId = prefs.getString(cnst.Session.id);
    String addOnIds = "";
    for (int i = 0; i < widget.cartItems.length; i++) {
      var cartData = await SQFLiteTables.where(
          table: Tables.CART_ADDON,
          column: "cart_id",
          value: widget.cartItems[i].cartId);
      setState(() {
        addOnIds = "";
      });
      for (int i = 0; i < cartData.length; i++) {
        setState(() {
          (i == (cartData.length - 1))
              ? addOnIds += cartData[i]["addon_id"] + ""
              : addOnIds += cartData[i]["addon_id"] + ", ";
        });
      }
      var addOns = await SQFLiteTables.where(
          table: Tables.ADDONS, column: "addon_item_id", value: addOnIds);
      setState(() {
        items += [
          {
            "item":
                "${widget.cartItems[i].itemId}^${widget.cartItems[i].itemName}^${widget.cartItems[i].itemPrice}^${widget.cartItems[i].qty}^desc^",
            "addon": addOns ?? []
          }
        ];
      });
    }
    if (_paymentMethod == PAYMENTMETHOD.RAZORPAY) {
      openCheckout();
    } else {
      FormData formData = FormData.fromMap({
        "address_id": address.id,
        "customer_id": customerId,
        "delivery_charges": config["delivery_charge"],
        "packing_charges": config["packing_charge"],
        "discount_total": "0",
        "description": "",
        "tax_total": taxTotal,
        "total": grandTotal,
        "api_key": "0imfnc8mVLWwsAawjYr4Rx",
        "payment_type": "COD",
        "payment_id": "",
        "items": items,
        "coupon_applied": widget.couponCode,
        "coupon_amount": widget.couponAmount
      });
      AppServices.saveOrder(formData).then((value) {
        if (value.value == "true") {
          clearCart();
          Fluttertoast.showToast(msg: value.message);
        } else {
          Fluttertoast.showToast(msg: value.message);
        }
      });
    }
  }

  Widget buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label ?? "N/A",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Text(
            value ?? "0.0",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
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
