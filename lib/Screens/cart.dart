import 'dart:ui';

import 'package:crunch/APIS/AppServices.dart';
import 'package:crunch/APIS/Constants.dart';
import 'package:crunch/Common/classes.dart';
import 'package:crunch/Static/Constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';

import 'checkout.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<CartData> cartItems = [];
  double grandTotal = 0.0, couponAmount = 0.0, total = 0.0;
  List items = [];
  TextEditingController couponCode = TextEditingController();
  bool isApplied = false;

  @override
  void initState() {
    getCartData();
    super.initState();
  }

  getCartData() async {
    setState(() {
      cartItems.clear();
      grandTotal = total = 0.0;
    });
    var cartData = await SQFLiteTables.getData(table: Tables.CART);
    for (int i = 0; i < cartData.length; i++) {
      setState(() {
        grandTotal += (double.parse(cartData[i]["item_price"]) *
                double.parse(cartData[i]["qty"])) +
            double.parse(cartData[i]["combined_price"]);
        total = grandTotal - couponAmount;
        cartItems.add(CartData(
            itemPrice: cartData[i]["item_price"].toString(),
            itemName: cartData[i]["item_name"].toString(),
            itemId: cartData[i]["item_id"].toString(),
            qty: cartData[i]["qty"].toString(),
            cartId: cartData[i]["id"].toString(),
            combinedPrice: cartData[i]["combined_price"].toString()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Cart",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: appPrimaryMaterialColor,
          elevation: 1,
        ),
        body: cartItems.length > 0
            ? Stack(
                children: [
                  ListView.builder(
                    padding: EdgeInsets.only(bottom: 160),
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      double total = (double.parse(cartItems[index].itemPrice) *
                              double.parse(cartItems[index].qty)) +
                          double.parse(cartItems[index].combinedPrice);
                      return ExpansionTile(
                        title: Text(
                          "${cartItems[index].itemName}",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "Grand total : $total",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        initiallyExpanded: true,
                        childrenPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        children: [
                          buildTitledRow(
                              title: "Price", val: cartItems[index].itemPrice),
                          buildTitledRow(
                              title: "Qty", val: cartItems[index].qty),
                          buildTitledRow(
                              title: "Add on price",
                              val: cartItems[index].combinedPrice),
                          Divider(),
                          buildTitledRow(title: "Total", val: total.toString()),
                          Align(
                            alignment: Alignment.centerRight,
                            child: FlatButton(
                              onPressed: () => _removeFromCart(
                                  cartId: cartItems[index].cartId,
                                  items: cartItems[index]),
                              child: Text(
                                "REMOVE",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                    itemCount: cartItems.length,
                  ),
                  cartItems.length > 0
                      ? Positioned(
                          child: Container(
                            width: size.width,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            height: 160,
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        child: TextField(
                                          controller: couponCode,
                                      readOnly: isApplied,
                                      decoration: InputDecoration(
                                          hintText: "Enter Coupon Code",
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(3)),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10)),
                                    )),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    SizedBox(
                                        height: 47,
                                        child: FlatButton(
                                          onPressed: !isApplied ? _apply : _cancel,
                                          child: Text(
                                            !isApplied ? "APPLY" : "CANCEL",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          color: !isApplied ? appPrimaryMaterialColor : Colors.red,
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                !isApplied ? Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: _coupons,
                                    child: Text(
                                      "VIEW COUPONS",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: appPrimaryMaterialColor[600]),
                                    ),
                                  ),
                                ) : SizedBox(),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                      "Grand Total : $grandTotal",
                                      style: TextStyle(
                                              color: appPrimaryMaterialColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14)),
                                        Text(
                                          "Coupon : $couponAmount",
                                          style: TextStyle(
                                              color: appPrimaryMaterialColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14)),
                                            Divider(height: 8, thickness: 1, endIndent: 20, color: appPrimaryMaterialColor,),
                                            Text(
                                                "Total : $total",
                                                style: TextStyle(
                                                    color: appPrimaryMaterialColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14)),
                                          ],
                                        )),
                                    Expanded(
                                        child: FlatButton(
                                      child: Text(
                                        "CHECKOUT",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                      color: appPrimaryMaterialColor,
                                      onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => Checkout(
                                                    grandTotal: total,
                                                    cartItems: cartItems,
                                                couponAmount: couponAmount,
                                                couponCode: couponCode.text,
                                                  ))).then((value) {
                                        getCartData();
                                      }),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 13),
                                    )),
                                  ],
                                )
                              ],
                            ),
                          ),
                          bottom: 0)
                      : SizedBox()
                ],
              )
            : Center(
                child: Text("Your cart is empty."),
              ));
  }
  _apply () async {
    AppServices.checkCoupon(amount: grandTotal.toString(), couponCode: couponCode.text).then((value) {
      if(value.value == "true") {
        setState(() {
          isApplied = true;
          couponAmount = double.parse(value.data[0]["amount"]);
          total = grandTotal - couponAmount;
        });
        Fluttertoast.showToast(msg: value.message);
      } else {
        Fluttertoast.showToast(msg: value.message);
      }
    });
  }
  _cancel () async {
    setState(() {
      isApplied = false;
      couponCode.clear();
      couponAmount = 0.0;
      total = grandTotal;
    });
  }
  _coupons() async {
    List<Coupon> coupons = [];
    await AppServices.getCoupons().then((value) {
      for (int i = 0; i < value.data.length; i++) {
        setState(() {
          coupons.add(Coupon(
              title: value.data[i]["title"],
              id: value.data[i]["id"],
              code: value.data[i]["code"],
              description: value.data[i]["description"],
              end: value.data[i]["end"],
              firstTime: value.data[i]["first_time"],
              limit: value.data[i]["limit"],
              maximum: value.data[i]["maximum"],
              minimum: value.data[i]["minimum"],
              start: value.data[i]["start"],
              type: value.data[i]["type"],
              value: value.data[i]["value"]));
        });
      }
    });
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return DraggableScrollableSheet(
              builder: (context, scrollController) {
                return ListView.builder(
                  controller: scrollController,
                  itemBuilder: (_, index) {
                    return ListTile(
                      title: Text(coupons[index].title,
                          style: TextStyle(color: Colors.black)),
                      onTap: () {
                        state(() {
                          couponCode.text = coupons[index].code;
                        });
                        Navigator.pop(context);
                      },
                      subtitle: coupons[index].description != null ? Text(coupons[index].description) : null,
                    );
                  },
                  itemCount: coupons.length,
                );
              },
              expand: false,
              initialChildSize: 0.4,
              maxChildSize: 1,
              minChildSize: 0.2,
            );
          });
        });
  }

  _removeFromCart({String cartId, CartData items}) async {
    String databasePath = await getDatabasesPath();
    Database db = await openDatabase(databasePath + 'myDb.db',
        version: 1, onCreate: (Database db, int version) async {});
    var status = await db
        .delete(SQFLiteTables.tableCart, where: 'id = ?', whereArgs: [cartId]);
    if (status == 1) {
      setState(() {
        grandTotal = grandTotal -
            (double.parse(items.combinedPrice) +
                (double.parse(items.itemPrice) * double.parse(items.qty)));
        total = grandTotal - couponAmount;
        cartItems.remove(items);
      });
    }
  }

  Widget buildTitledRow({String title, String val}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Text(
            val,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class Coupon {
  final String id,
      title,
      description,
      code,
      type,
      limit,
      value,
      start,
      end,
      minimum,
      maximum,
      firstTime;
  Coupon(
      {this.id,
      this.title,
      this.description,
      this.code,
      this.type,
      this.limit,
      this.value,
      this.start,
      this.end,
      this.minimum,
      this.maximum,
      this.firstTime});
}
