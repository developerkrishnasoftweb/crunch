import 'package:crunch/APIS/tables.dart';
import 'package:crunch/Common/classes.dart';
import 'package:crunch/Common/item_variations.dart';
import 'package:crunch/Common/items_addons.dart';
import 'package:crunch/Static/global.dart';
import 'package:crunch/models/variation_model.dart';
import 'package:flutter/material.dart';

Widget itemCard (BuildContext context, ItemData itemData, AnimationController animationController) {
  return StatefulBuilder(
    builder: (_, state) => Container(
      padding: EdgeInsets.symmetric(
          horizontal: 15, vertical: 10),
      margin: EdgeInsets.symmetric(
          vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey[200], blurRadius: 5)
          ]),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: Image(
              height: 90,
              width: 100,
              image: itemData.image != null &&
                  itemData.image != ""
                  ? NetworkImage(itemData.image)
                  : AssetImage(
                  "assets/images/CrunchTM.png"),
              fit: BoxFit.fill,
            ),
          ),
          Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      itemData.name != null &&
                          itemData.name != ""
                          ? itemData.name
                          : "N/A",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      itemData.description != null &&
                          itemData.description != ""
                          ? itemData.description
                          : "N/A",
                      style: TextStyle(
                          fontSize: 13, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\u20b9${itemData.price != null && itemData.price != "" ? double.parse(itemData.price).toStringAsFixed(2) : "N/A"}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 21),
                        ),
                        itemData.addedToCart
                            ? incDecButton(item: itemData, state: state)
                            : addToCartButton(
                            onPressed: () async {
                              if (itemData
                                  .addon
                                  .length >
                                  0) {
                                showItemAddons(itemData: itemData, animationController: animationController, context: context);
                              } else {
                                if(itemData.variation.length == 0) {
                                  state(() {
                                    itemData.addedToCart = true;
                                  });
                                  await SQFLiteTables.addToCart(itemData: itemData);
                                } else {
                                  itemVariation(context: context, itemData: itemData);
                                }
                              }
                            })
                      ],
                    )
                  ],
                ),
              )),
        ],
      ),
    ),
  );
}

Widget incDecButton({@required ItemData item, StateSetter state}) {
  return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.green[400]),
          borderRadius: BorderRadius.circular(5)),
      width: 73,
      height: 30,
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              state(() {
                item.quantity = item.quantity + 1;
              });
              await SQFLiteTables.updateCart(itemData: item);
            },
            child: Icon(
              Icons.add,
              size: 23,
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              color: Colors.green[400],
              child: Text("${item.quantity}"),
            ),
          ),
          GestureDetector(
            onTap: () async {
              if (item.quantity != 1) {
                state(() {
                  item.quantity = item.quantity - 1;
                });
                await SQFLiteTables.updateCart(itemData: item);
              } else if (item.quantity == 1) {
                var status = await db.delete(SQFLiteTables.tableCart,
                    where: 'item_id = ?', whereArgs: [item.id]);
                if (status == 1) {
                  state(() {
                    item.addedToCart = false;
                  });
                }
              }
            },
            child: Icon(
              Icons.remove,
              size: 23,
            ),
          )
        ],
      ));
}

Widget addToCartButton({@required VoidCallback onPressed}) {
  return SizedBox(
      width: 73,
      height: 33,
      child: FlatButton(
        child: Text(
          "ADD",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
        ),
        onPressed: onPressed,
        color: Colors.green[500],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ));
}
