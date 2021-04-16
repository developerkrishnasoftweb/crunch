import 'package:crunch/APIS/AppServices.dart';
import 'package:crunch/APIS/tables.dart';
import 'package:crunch/Common/classes.dart';
import 'package:crunch/Screens/widgets/appbar.dart';
import 'package:crunch/Static/Constant.dart';
import 'package:crunch/Static/global.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../main.dart';
import 'checkout.dart';
import 'my_orders.dart';

class PaymentMethods extends StatefulWidget {
  final double couponAmount, grandTotal;
  final String couponCode;
  final Addresses addresses;
  final List<CartData> cartItems;
  final PaymentMode paymentMode;

  const PaymentMethods(
      {Key key,
      this.couponCode = '',
      this.couponAmount = 0.0,
      @required this.grandTotal,
      @required this.addresses,
      @required this.cartItems,
      @required this.paymentMode})
      : super(key: key);

  @override
  _PaymentMethodsState createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  PaymentMethod paymentMethod = PaymentMethod.ONLINE_PAYMENT;
  String description = '';
  List<Map<String, dynamic>> items = [];
  Razorpay _razorpay;
  double sgst = 0, cgst = 0, taxTotal = 0, total = 0, grandTotal = 0.0;

  void openCheckout() async {
    var options = {
      'key': config.razorpayKey,
      'amount': grandTotal.ceil() * 100,
      'name': 'Crunch',
      'description': 'Fresh Foods',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/mytestApp.appspot.com/o/images%2FpZm8daajsIS4LvqBYTiWiuLIgmE2?alt=media&token=3kuli4cd-dc45-7845-b87d-5c4acc7da3c2',
      'prefill': {'contact': userdata.mobile, 'email': userdata.email},
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

  clearCart() async {
    await db.rawQuery("delete from ${SQFLiteTables.tableCart}");
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyOrders()));
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    FormData formData = FormData.fromMap({
      "address_id": widget.addresses?.id ?? '0',
      "customer_id": userdata.id,
      "delivery_charges": config.deliveryCharge ?? "0",
      "packing_charges": config.packingCharge ?? "0",
      "discount_total": "0",
      "description": description,
      "tax_total": taxTotal,
      "total": grandTotal,
      "api_key": "0imfnc8mVLWwsAawjYr4Rx",
      "payment_type": "PPD",
      "payment_id": response.paymentId,
      "items": items,
      "coupon_applied": widget.couponCode,
      "coupon_amount": widget.couponAmount,
      "order_type": widget.paymentMode == PaymentMode.HOME_DELIVERY ? "H" : "P"
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
    setState(() {
      sgst = double.parse(config.sgst ?? "0");
      cgst = double.parse(config.cgst ?? "0");
      taxTotal = widget.grandTotal * (sgst + cgst) / 100;
      total = taxTotal + widget.grandTotal;
      grandTotal =
          (((widget.grandTotal + (widget.grandTotal * (cgst + sgst)) / 100) -
                  widget.couponAmount) +
              (double.parse(config.packingCharge ?? "0") +
                  double.parse(config.deliveryCharge ?? "0")));
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context, title: "Payment Methods"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Select Payment Method",
                style: TextStyle(fontSize: 18),
              ),
            ),
            RadioListTile<PaymentMethod>(
                value: PaymentMethod.ONLINE_PAYMENT,
                groupValue: paymentMethod,
                title: Text("Online Payment"),
                onChanged: (method) {
                  setState(() {
                    paymentMethod = method;
                  });
                }),
            RadioListTile<PaymentMethod>(
                value: PaymentMethod.CASH_PAYMENT,
                groupValue: paymentMethod,
                title: Text("Cash Payment"),
                onChanged: (method) {
                  setState(() {
                    paymentMethod = method;
                  });
                }),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Description",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                onChanged: (v) {
                  description = v;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    contentPadding: EdgeInsets.all(10)),
                maxLines: 5,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
          width: double.infinity,
          height: 50,
          child: FlatButton(
            child: Text(
              "ORDER NOW",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: makePayment,
            color: primaryColor,
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  makePayment() async {
    var startTime = config.startTime.split(":");
    var closeTime = config.endTime.split(":");
    DateTime currentDateTime = DateTime.now();
    TimeOfDay currentTime =
        TimeOfDay(hour: currentDateTime.hour, minute: currentDateTime.minute);
    TimeOfDay start = TimeOfDay(
        hour: int.parse(startTime[0]), minute: int.parse(startTime[1]));
    TimeOfDay end = TimeOfDay(
        hour: int.parse(closeTime[0]), minute: int.parse(closeTime[1]));
    if (!(currentTime.hour >= start.hour &&
        currentTime.hour <= end.hour)) {
      Fluttertoast.showToast(msg: "Order is not allowed this time");
      return;
    }
    if (position != null) {
      if (config?.distanceBetween != null &&
          config?.latitude != null &&
          config?.longitude != null) {
        if (config.distanceBetween.isNotEmpty &&
            config.latitude.isNotEmpty &&
            config.longitude.isNotEmpty) {
          if (Geolocator.distanceBetween(
                  position.latitude,
                  position.longitude,
                  double.parse(config.latitude),
                  double.parse(config.longitude)) >
              double.parse(config.distanceBetween)) {
            Fluttertoast.showToast(
                msg:
                    "Sorry for inconvenience, we are delivering in range of ${double.parse(config.distanceBetween) / 1000}KM");
            return;
          }
        } else {
          Fluttertoast.showToast(msg: "Unable to fetch delivering range");
          return;
        }
      } else {
        Fluttertoast.showToast(msg: "Unable to fetch delivering range");
        return;
      }
    } else {
      Fluttertoast.showToast(
          msg: "Unable to get your current location, Please turn on location");
      determinePosition();
      return;
    }
    setState(() {
      items = [];
    });
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
                "${widget.cartItems[i].itemId}^${widget.cartItems[i].itemName}^${widget.cartItems[i].variationId}^${widget.cartItems[i].variationName}^${widget.cartItems[i].total}^${widget.cartItems[i].qty}^^",
            "addon": addOns ?? []
          }
        ];
      });
    }
    if (paymentMethod == PaymentMethod.ONLINE_PAYMENT) {
      openCheckout();
    } else {
      FormData formData = FormData.fromMap({
        "address_id": widget.addresses?.id ?? '0',
        "customer_id": userdata.id,
        "delivery_charges": config.deliveryCharge,
        "packing_charges": config.packingCharge,
        "discount_total": "0",
        "description": description,
        "tax_total": taxTotal,
        "total": grandTotal,
        "api_key": "0imfnc8mVLWwsAawjYr4Rx",
        "payment_type": "COD",
        "payment_id": "",
        "items": items,
        "coupon_applied": widget.couponCode,
        "coupon_amount": widget.couponAmount,
        "order_type":
            widget.paymentMode == PaymentMode.HOME_DELIVERY ? "H" : "P"
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
}

enum PaymentMethod { ONLINE_PAYMENT, CASH_PAYMENT }
