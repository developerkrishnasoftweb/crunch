import 'package:crunch/APIS/Constants.dart';
import 'package:crunch/Common/classes.dart';
import 'package:crunch/Static/Constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'checkout.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<CartData> cartItems = [];
  double grandTotal = 0;
  List items = [];
  @override
  void initState() {
    getCartData();
    super.initState();
  }

  getCartData() async {
    setState(() {
      cartItems.clear();
    });
    var cartData = await SQFLiteTables.getData(table: Tables.CART);
    for (int i = 0; i < cartData.length; i++) {
      setState(() {
        grandTotal += (double.parse(cartData[i]["item_price"]) *
                double.parse(cartData[i]["qty"])) +
            double.parse(cartData[i]["combined_price"]);
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
            ? Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: ListView.builder(
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
                        buildTitledRow(title: "Qty", val: cartItems[index].qty),
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
              )
            : Center(
                child: Text("Your cart is empty."),
              ),
        floatingActionButton: cartItems.length > 0
            ? Container(
                height: 50,
                width: size.width * 0.9,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(blurRadius: 5, color: Colors.grey[300])
                    ]),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      "Grand Total : $grandTotal",
                      style: TextStyle(
                          color: appPrimaryMaterialColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    )),
                    Expanded(
                        child: FlatButton(
                      child: Text(
                        "CHECKOUT",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      color: appPrimaryMaterialColor,
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => Checkout(
                                    grandTotal: grandTotal,
                                    cartItems: cartItems,
                                  ))).then((value) {
                                    getCartData();
                      }),
                      padding: EdgeInsets.symmetric(vertical: 13),
                    )),
                  ],
                ),
              )
            : null);
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
