import 'package:crunch/APIS/AppServices.dart';
import 'package:crunch/Screens/track_order.dart';
import 'package:crunch/Static/Constant.dart' as cnst;
import 'package:crunch/Static/global.dart';
import 'package:crunch/models/orders_details_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  bool isLoading = false, isDeleting = false;
  List<OrderDetails> orderDetails = [];
  Razorpay _razorpay;

  setLoading(bool status) {
    setState(() {
      isLoading = status;
    });
  }

  setDelete(bool status) {
    setState(() {
      isDeleting = status;
    });
  }

  @override
  void initState() {
    super.initState();
    getOrders();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    FormData formData = FormData.fromMap({
      "address_id": "",
      "customer_id": userdata.id,
      "delivery_charges": config.deliveryCharge ?? "0",
      "packing_charges": config.packingCharge ?? "0",
      "discount_total": "0",
      "description": "",
      "tax_total": "",
      "total": "",
      "api_key": "0imfnc8mVLWwsAawjYr4Rx",
      "payment_type": "PPD",
      "payment_id": response.paymentId,
      "items": "",
      "coupon_applied": "",
      "coupon_amount": "",
      "order_type": ""
    });
    AppServices.saveOrder(formData).then((value) {
      if (value.value == "true") {
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

  getOrders() async {
    orderDetails.clear();
    setLoading(true);
    FormData formData = FormData.fromMap({
      "api_key": "0imfnc8mVLWwsAawjYr4Rx",
      "customer_id": userdata.id,
    });
    await AppServices.orders(formData).then((value) {
      if (value.value == "true") {
        final orders = value.data[0]['orders'];
        for (int i = 0; i < orders.length; i++) {
          setState(() {
            orderDetails.add(OrderDetails.fromJson(orders[i]));
          });
        }
        setLoading(false);
      } else {
        setState(() {
          orderDetails = null;
        });
        setLoading(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Your Orders",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: cnst.primaryColor,
          elevation: 1,
        ),
        body: isLoading
            ? Center(
                child: orderDetails != null
                    ? CircularProgressIndicator()
                    : Text("No orders found"),
              )
            : ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20),
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Items",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        for (int i = 0;
                            i < orderDetails[index].details.length;
                            i++) ...[
                          Text(
                            "${orderDetails[index].details[i].quantity} x ${orderDetails[index].details[i].name}",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          )
                        ],
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "ORDERED ON",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${orderDetails[index].created != null ? DateFormat("MMM d, y").format(DateTime.parse(orderDetails[index].created)) : "N/A"} at ${orderDetails[index].created != null ? orderDetails[index].created.split(" ").last : "N/A"}",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "GST",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "+ \u20b9${orderDetails[index].taxTotal}",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "TOTAL",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "\u20b9${orderDetails[index].total}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              orderDetails[index].orderStatus.toLowerCase() !=
                                          "cancelled" &&
                                      orderDetails[index]
                                              .orderStatus
                                              .toLowerCase() !=
                                          "delivered" &&
                                      orderDetails[index]
                                              .paymentType
                                              .toLowerCase() !=
                                          "ppd"
                                  ? TextButton(
                                      onPressed: openCheckout,
                                      child: Text("PAY NOW", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)))
                                  : SizedBox()
                            ]),
                        Divider(
                          thickness: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${orderDetails[index].orderStatus.toUpperCase()}",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: orderDetails[index]
                                              .orderStatus
                                              .toLowerCase() ==
                                          "cancelled"
                                      ? Colors.red
                                      : orderDetails[index]
                                                  .orderStatus
                                                  .toLowerCase() ==
                                              "delivered"
                                          ? Colors.green
                                          : cnst.primaryColor[700],
                                  fontWeight: FontWeight.bold),
                            ),
                            orderDetails[index].orderStatus.toLowerCase() !=
                                        "cancelled" &&
                                    orderDetails[index]
                                            .orderStatus
                                            .toLowerCase() !=
                                        "delivered"
                                ? Row(
                                    children: [
                                      orderDetails[index]
                                                  .orderStatus
                                                  .toLowerCase() ==
                                              "pending"
                                          ? FlatButton(
                                              onPressed: isDeleting
                                                  ? null
                                                  : () => _cancelOrder(
                                                      orderDetails[index]),
                                              child: isDeleting
                                                  ? SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 1,
                                                      ))
                                                  : Text(
                                                      "CANCEL",
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ))
                                          : SizedBox(),
                                      FlatButton(
                                          onPressed: () {
                                            Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            TrackOrder(
                                                                orderDetails:
                                                                    orderDetails[
                                                                        index])))
                                                .then((value) {
                                              getOrders();
                                            });
                                          },
                                          child: Text(
                                            "TRACK",
                                            style: TextStyle(
                                                color: cnst.primaryColor,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ],
                                  )
                                : SizedBox(
                                    height: 30,
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ));
                },
                physics: BouncingScrollPhysics(),
                itemCount: orderDetails.length,
              ));
  }

  _cancelOrder(OrderDetails order) async {
    setDelete(true);
    FormData formData = FormData.fromMap({
      "api_key": "0imfnc8mVLWwsAawjYr4Rx",
      "order_id": order.id,
    });
    await AppServices.cancelOrder(formData).then((value) {
      if (value.value == "true") {
        getOrders();
        Fluttertoast.showToast(msg: value.message);
        setDelete(false);
      } else {
        Fluttertoast.showToast(msg: value.message);
        setDelete(false);
      }
    });
  }

  void openCheckout() async {
    var options = {
      'key': config.razorpayKey,
      'amount': 0,
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
}
