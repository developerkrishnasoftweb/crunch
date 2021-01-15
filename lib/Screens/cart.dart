import 'package:crunch/APIS/Constants.dart';
import 'package:crunch/Common/classes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<CartData> cartItems = [];
  @override
  void initState() {
    getCartData();
    super.initState();
  }

  getCartData() async {
    var cartData = await SQFLiteTables.getData(table: Tables.CART);
    for (int i = 0; i < cartData.length; i++) {
      setState(() {
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
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Cart",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        body: cartItems.length > 0
            ? ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  double total = (double.parse(cartItems[index].itemPrice) *
                          double.parse(cartItems[index].qty)) +
                      double.parse(cartItems[index].combinedPrice);
                  return ExpansionTile(
                    title: Text(
                      "${cartItems[index].itemName}",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Grand total : $total",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
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
                    ],
                  );
                },
                itemCount: cartItems.length,
              )
            : Center(
                child: Text("Your cart is empty."),
              ));
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
