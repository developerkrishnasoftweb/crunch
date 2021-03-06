import 'dart:async';

import 'package:crunch/APIS/AppServices.dart';
import 'package:crunch/Screens/widgets/appbar.dart';
import 'package:crunch/Static/Constant.dart';
import 'package:crunch/Static/global.dart';
import 'package:crunch/models/orders_details_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TrackOrder extends StatefulWidget {
  final OrderDetails orderDetails;

  TrackOrder({@required this.orderDetails});

  @override
  _TrackOrderState createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  int statusCode = 1;
  bool isLoading = false;
  int deliveryTime = 0;
  DateTime created;
  Duration diff = Duration();
  Timer timer;

  setLoading(bool status) {
    if(this.mounted) {
      setState(() {
        isLoading = status;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      trackOrder();
    });
  }

  trackOrder() async {
    setLoading(true);
    await AppServices.trackOrder(FormData.fromMap({
      "api_key": "0imfnc8mVLWwsAawjYr4Rx",
      "order_id": widget.orderDetails.id
    })).then((value) {
      if (value.value == "true") {
        if (getStatusCode(value.data[0]["orders"]["detail"]["order_status"]) ==
            null) {
          Fluttertoast.showToast(
              msg: "Unfortunately, your order has been cancelled");
          Navigator.pop(context);
        }
        if(this.mounted) {
          setState(() {
            statusCode =
                getStatusCode(value.data[0]["orders"]["detail"]["order_status"]);
          });
        }
        setLoading(false);
      } else {
        if(this.mounted) {
          setState(() {
            statusCode = null;
          });
        }
        setLoading(false);
      }
    });
    if(this.mounted) {
      setState(() {
        deliveryTime = double.parse(config.deliveryTime != null
            ? config.deliveryTime.toString()
            : "0")
            .round();
        created = DateTime.parse(widget.orderDetails.created)
            .add(Duration(minutes: deliveryTime));
      });
    }
    getDiff();
  }

  int getStatusCode(String value) {
    switch (value.toLowerCase()) {
      case "pending":
        return 1;
        break;
      case "accepted":
        return 2;
        break;
      case "at_store":
        return 3;
        break;
      case "out_of_delivery":
        return 4;
        break;
      case "delivered":
        return 5;
        break;
      default:
        return null;
        break;
    }
  }

  getDiff() async {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if(this.mounted) {
        setState(() {
          diff = created.difference(DateTime.now());
        });
      }
      if (diff.isNegative) {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        context: context,
        title: "Track Order",
        actions: [
          IconButton(
              icon: isLoading
                  ? SizedBox(
                      height: 17,
                      width: 17,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                        strokeWidth: 2,
                      ),
                    )
                  : Icon(Icons.refresh_outlined),
              onPressed: trackOrder)
        ],
      ),
      body: statusCode == null
          ? Center(
              child: Text("Tracking details not found"),
            )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "#Order Id : " + widget.orderDetails.id,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Order Status",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  buildIconStatus(
                      title: "Order accepted",
                      status: statusCode > 1 ? true : false),
                  SizedBox(
                    height: 10,
                  ),
                  buildIconStatus(
                      title: "Driver at store",
                      status: statusCode > 2 ? true : false),
                  SizedBox(
                    height: 10,
                  ),
                  buildIconStatus(
                      title: "Order on the way",
                      status: statusCode > 3 ? true : false),
                  SizedBox(
                    height: 10,
                  ),
                  buildIconStatus(
                      title: "Order received",
                      status: statusCode > 4 ? true : false),
                      Expanded(
                          child: Center(
                            child: created != null ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 150,
                                  width: 150,
                                  alignment: Alignment.center,
                                  child: Text(
                                    diff.isNegative
                                        ? "00 mins : 00 sec"
                                        : diff.inMinutes.toString() +
                                            " mins : " +
                                            (diff.inSeconds % 60).toString() +
                                            " sec",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(150),
                                    border: Border.all(
                                        color: primaryColor, width: 2),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                    diff.isNegative
                                        ? "Expect your delivery any time"
                                        : "Estimated delivery time",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor)),
                              ],
                            ) : Text("Please wait, we are getting done everything for you", style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: primaryColor
                            ), textAlign: TextAlign.center),
                          ),
                        )
                ],
              ),
            ),
    );
  }

  Widget buildIconStatus({bool status: false, String title}) {
    return Row(
      children: [
        status
            ? Icon(
                Icons.check_circle_outline,
                size: 30,
                color: Colors.green,
              )
            : AnimatedContainer(
                duration: Duration(milliseconds: 500),
                height: status ? 0 : 30,
                width: status ? 0 : 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.transparent,
                ),
                child: Container(
                  height: status ? 0 : 10,
                  width: status ? 0 : 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: primaryColor,
                  ),
                ),
              ),
        SizedBox(
          width: 10,
        ),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: status ? Colors.green : primaryColor,
          ),
        )
      ],
    );
  }
}
