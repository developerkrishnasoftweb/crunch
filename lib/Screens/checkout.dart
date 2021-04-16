import 'package:crunch/APIS/AppServices.dart';
import 'package:crunch/APIS/tables.dart';
import 'package:crunch/Common/classes.dart';
import 'package:crunch/Screens/my_orders.dart';
import 'package:crunch/Screens/payment_methods.dart';
import 'package:crunch/Static/Constant.dart' as cnst;
import 'package:crunch/Static/global.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'Add_Address.dart';
import 'widgets/appbar.dart';

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
  List<Addresses> addresses = [];
  List<Map<String, dynamic>> items = [];
  PaymentMode _paymentMethod = PaymentMode.SELF_PICKUP;
  Addresses address;

  // static const platform = const MethodChannel("razorpay_flutter");
  double sgst = 0, cgst = 0, taxTotal = 0, total = 0, grandTotal = 0.0;

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
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(title: "Checkout", context: context),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildRow("CART VALUE", widget.grandTotal.toStringAsFixed(2)),
                  buildRow(
                      "PACKING CHARGES", "+ " + config.packingCharge ?? "0"),
                  buildRow(
                      "DELIVERY CHARGES", "+ " + config.deliveryCharge ?? "0"),
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
                    color: cnst.primaryColor,
                  ),
                  buildRow(
                    "Total",
                    "\u20b9${grandTotal.toStringAsFixed(2)}",
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Select Delivery Type",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  RadioListTile<PaymentMode>(
                    title: Text("Self Pickup",
                        style: TextStyle(
                            color: config.selfPickUp != 'y'
                                ? Colors.grey.shade500
                                : null)),
                    value: PaymentMode.SELF_PICKUP,
                    groupValue: _paymentMethod,
                    onChanged: (value) {
                      if (config.selfPickUp == 'y') {
                        setState(() {
                          _paymentMethod = value;
                        });
                      } else {
                        Fluttertoast.showToast(
                            msg: "This option is currently not available");
                      }
                    },
                  ),
                  RadioListTile<PaymentMode>(
                    title: Text("Home Delivery",
                        style: TextStyle(
                            color: config.homeDelivery != 'y'
                                ? Colors.grey.shade500
                                : null)),
                    value: PaymentMode.HOME_DELIVERY,
                    groupValue: _paymentMethod,
                    onChanged: (value) {
                      if (config.homeDelivery == 'y') {
                        setState(() {
                          _paymentMethod = value;
                        });
                      } else {
                        Fluttertoast.showToast(
                            msg: "This option is currently not available");
                      }
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
                      color: cnst.primaryColor,
                      onPressed: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Add_Address()))
                            .then((value) {
                          getAddresses();
                        });
                      },
                    ),
                  ),
                  _paymentMethod != PaymentMode.SELF_PICKUP
                      ? (addresses?.length ?? 0) > 0
                          ? ListView.builder(
                              itemCount: addresses.length,
                              padding: EdgeInsets.only(bottom: 70),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return RadioListTile<Addresses>(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          addresses[index].contactPerson,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          addresses[index].address1 +
                                              ", " +
                                              addresses[index].address2 +
                                              "\n" +
                                              addresses[index].landmark +
                                              "\n" +
                                              addresses[index].city +
                                              " - " +
                                              addresses[index].pinCode,
                                          style: TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          addresses[index].contactNumber,
                                          style: TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    value: addresses[index],
                                    groupValue: address,
                                    onChanged: (value) {
                                      setState(() {
                                        address = value;
                                      });
                                    });
                              })
                          : Center(
                              child: Text("No address available"),
                            )
                      : Center(
                          child: Text("Our Store Address - ${config.address}",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black))),
                ],
              ),
            ),
      floatingActionButton: Container(
          width: size.width,
          height: 50,
          child: FlatButton(
            child: Text(
              "PROCEED",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => PaymentMethods(
                          addresses: address,
                          cartItems: widget.cartItems,
                          grandTotal: widget.grandTotal,
                          couponAmount: widget.couponAmount,
                          couponCode: widget.couponCode,
                          paymentMode: _paymentMethod)));
            },
            color: cnst.primaryColor,
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  getAddresses() async {
    FormData d = FormData.fromMap({
      "api_key": "0imfnc8mVLWwsAawjYr4Rx",
      "customer_id": userdata.id,
    });
    setState(() {
      isLoading = true;
      addresses = [];
    });
    AppServices.getAddress(d).then((data) async {
      if (data.value == "y") {
        setState(() {
          isLoading = false;
        });
        for (int i = 0; i < data.data.length; i++) {
          setState(() {
            addresses.add(Addresses(
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
          address = addresses[0];
        });
      } else {
        setState(() {
          isLoading = false;
          addresses = null;
        });
      }
    });
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

enum PaymentMode { HOME_DELIVERY, SELF_PICKUP }

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
