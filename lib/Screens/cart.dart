import 'dart:ui';

import 'package:crunch/APIS/AppServices.dart';
import 'package:crunch/APIS/tables.dart';
import 'package:crunch/Common/classes.dart';
import 'package:crunch/Screens/widgets/appbar.dart';
import 'package:crunch/Static/Constant.dart';
import 'package:crunch/Static/global.dart';
import 'package:crunch/models/cart_addon_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'checkout.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<CartData> cartItems = [];
  double grandTotal = 0.0, couponAmount = 0.0;
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
      grandTotal = 0.0;
    });
    var cartData = await SQFLiteTables.getData(table: Tables.CART);
    cartData.forEach((item) async {
      List<CartAddOn> cartAdds = [];
      double combinedPrice = 0, total = 0;

      var cartAddOn = await SQFLiteTables.where(
          value: item["id"].toString(),
          table: Tables.CART_ADDON,
          column: 'cart_id');
      for (int i = 0; i < cartAddOn.length; i++) {
        var addOnList = await SQFLiteTables.where(
            table: Tables.ADDONS,
            value: cartAddOn[i]['addon_id'],
            column: 'addon_item_id');
        cartAdds.add(CartAddOn.fromJson(addOnList[0]));
        combinedPrice += double.parse(addOnList[0]['price']);
      }

      setState(() {
        grandTotal +=
            (double.parse(item["item_price"]) * double.parse(item["qty"])) +
                combinedPrice;
        total =
            ((double.parse(item["item_price"]) * double.parse(item["qty"])) +
                combinedPrice);
        cartItems.add(CartData(
            itemPrice: item["item_price"].toString(),
            itemName: item["item_name"].toString(),
            itemId: item["item_id"].toString(),
            qty: item["qty"].toString(),
            cartId: item["id"].toString(),
            variationId: item["variation_id"].toString(),
            variationName: item["variation_name"].toString(),
            combinedPrice: combinedPrice.toString(),
            cartAddOns: cartAdds,
            total: total.toString()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: appBar(
            title: "Cart", context: context, automaticallyImplyLeading: false),
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
                            "Grand total : \u20b9${total.toStringAsFixed(2)}",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        initiallyExpanded: true,
                        childrenPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        children: [
                          buildTitledRow(
                              title: "Price",
                              val:
                                  '\u20b9${double.parse(cartItems[index].itemPrice).toStringAsFixed(2)}'),
                          buildTitledRow(
                              title: "Qty", val: cartItems[index].qty),
                          buildTitledRow(
                              title: "Add on price",
                              val:
                                  "\u20b9${double.parse(cartItems[index].combinedPrice).toStringAsFixed(2)}"),
                          Divider(),
                          buildTitledRow(
                              title: "Total",
                              val: '\u20b9${total.toStringAsFixed(2)}'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () =>
                                    removeCartQuantity(items: cartItems[index]),
                                color: primaryColor,
                                splashRadius: 20,
                              ),
                              Text(
                                "${cartItems[index].qty}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                              ),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () =>
                                    addCartQuantity(items: cartItems[index]),
                                color: primaryColor,
                                splashRadius: 20,
                              ),
                            ],
                          ),
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
                            height: 150,
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
                                          onPressed:
                                              !isApplied ? _apply : _cancel,
                                          child: Text(
                                            !isApplied ? "APPLY" : "CANCEL",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          color: !isApplied
                                              ? primaryColor
                                              : Colors.red,
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: GestureDetector(
                                    onTap: !isApplied ? _coupons : null,
                                    child: Text(
                                      !isApplied
                                          ? "VIEW COUPONS"
                                          : "Coupon value : $couponAmount",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: !isApplied
                                              ? primaryColor[600]
                                              : Colors.green),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: FlatButton(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "CART VALUE : \u20b9${double.parse((grandTotal - couponAmount).toString()).toStringAsFixed(2)}",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14),
                                                maxLines: 1,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                "CHECKOUT",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14),
                                                maxLines: 1,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      color: primaryColor,
                                      onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => Checkout(
                                                    grandTotal: grandTotal,
                                                    cartItems: cartItems,
                                                    couponAmount: couponAmount,
                                                    couponCode: couponCode.text,
                                                  ))).then((value) {
                                        getCartData();
                                      }),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 20),
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

  _apply() async {
    await AppServices.checkCoupon(
            amount: grandTotal.toString(), couponCode: couponCode.text)
        .then((value) {
      if (value.value == "true") {
        setState(() {
          isApplied = true;
          couponAmount = double.parse(value.data[0]["amount"]);
        });
        Fluttertoast.showToast(msg: value.message);
      } else {
        Fluttertoast.showToast(msg: value.message);
      }
    });
  }

  _cancel() async {
    setState(() {
      isApplied = false;
      couponCode.clear();
      couponAmount = 0.0;
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
    if (coupons.length > 0) {
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
                        subtitle: coupons[index].description != null
                            ? Text(coupons[index].description)
                            : null,
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
  }

  addCartQuantity({CartData items}) async {
    int qty = int.parse(items.qty);
    double itemPrice = double.parse(items.itemPrice);
    int status = await db.update(SQFLiteTables.tableCart, {'qty': ++qty},
        where: 'id = ?', whereArgs: [items.cartId]);
    if (status == 1) {
      setState(() {
        grandTotal = grandTotal + itemPrice;
        items.qty = qty.toString();
      });
    }
  }

  removeCartQuantity({CartData items}) async {
    int qty = int.parse(items.qty);
    double combinedPrice = double.parse(items.combinedPrice),
        itemPrice = double.parse(items.itemPrice);
    int status;
    if (qty == 1) {
      status = await db.delete(SQFLiteTables.tableCart,
          where: 'id = ?', whereArgs: [items.cartId]);
      if (status == 1) {
        setState(() {
          grandTotal = grandTotal - (combinedPrice + (itemPrice * qty));
          cartItems.remove(items);
        });
      }
    } else {
      status = await db.update(SQFLiteTables.tableCart, {'qty': --qty},
          where: 'id = ?', whereArgs: [items.cartId]);
      if (status == 1) {
        setState(() {
          grandTotal = grandTotal - itemPrice;
          items.qty = qty.toString();
        });
      }
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
