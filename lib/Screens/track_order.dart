import 'dart:async';

import 'package:crunch/APIS/AppServices.dart';
import 'package:crunch/Screens/my_orders.dart';
import 'package:crunch/Static/Constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class TrackOrder extends StatefulWidget {
  final OrderDetails orderDetails;
  TrackOrder({@required this.orderDetails});
  @override
  _TrackOrderState createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  int statusCode = 1;
  @override
  void initState() {
    super.initState();
    trackOrder();
  }
  trackOrder () async {
    AppServices.trackOrder(FormData.fromMap({
      "api_key": "0imfnc8mVLWwsAawjYr4Rx",
      "order_id": widget.orderDetails.id
    })).then((value) {
      setState(() {
        statusCode = getStatusCode(value.data[0]["orders"]["detail"]["order_status"]);
      });
    });
  }

  int getStatusCode (String value) {
    switch(value.toLowerCase()) {
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
        return 1;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Track Order",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: appPrimaryMaterialColor,
        elevation: 1,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "#Order Id : " + widget.orderDetails.id,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
            buildIconStatus(title: "Order accepted", status: statusCode > 1 ? true : false),
            SizedBox(
              height: 10,
            ),
            buildIconStatus(title: "Driver at store", status: statusCode > 2 ? true : false),
            SizedBox(
              height: 10,
            ),
            buildIconStatus(title: "Order on the way", status: statusCode > 3 ? true : false),
            SizedBox(
              height: 10,
            ),
            buildIconStatus(title: "Order received", status: statusCode > 4 ? true : false),
            Expanded(child: ListView.builder(itemBuilder: (_, index) {
              return SizedBox();
            }))
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
                    color: appPrimaryMaterialColor,
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
            fontSize: 20,
            color: status ? Colors.green : appPrimaryMaterialColor,
          ),
        )
      ],
    );
  }
}
