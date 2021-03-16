import 'dart:convert';

import 'package:crunch/APIS/tables.dart';
import 'package:crunch/Common/classes.dart';
import 'package:crunch/Common/item_variations.dart';
import 'package:crunch/Common/items_addons.dart';
import 'package:crunch/Static/Constant.dart';
import 'package:crunch/Static/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../APIS/tables.dart';
import '../Common/classes.dart';
import 'cart.dart';

class CategoryItems extends StatefulWidget {
  final String categoryId;
  CategoryItems({@required this.categoryId});
  @override
  _CategoryItemsState createState() => _CategoryItemsState();
}

class _CategoryItemsState extends State<CategoryItems>
    with SingleTickerProviderStateMixin {
  List<ItemData> items = [];
  bool isLoading = false;
  AnimationController _controller;
  var variation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
    );
    _getCategoryData();
  }

  _getCategoryData() async {
    var value = await SQFLiteTables.where(
        table: Tables.ITEMS,
        column: "item_categoryid",
        value: widget.categoryId);
    for (int i = 0; i < value.length; i++) {
      setState(() {
        items.add(ItemData(
            image: value[i]["item_image_url"],
            name: value[i]["itemname"],
            id: value[i]["itemid"],
            addon: jsonDecode(value[i]["addon"]),
            description: value[i]["itemdescription"],
            inStock: value[i]["in_stock"],
            itemAllowAddOn: value[i]["itemallowaddon"],
            itemCategoryId: value[i]["item_categoryid"],
            itemOrderType: value[i]["item_ordertype"],
            price: value[i]["price"],
            variation: jsonDecode(value[i]["variation"])));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Items",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      body: ListView.builder(
          itemCount: items.length > 10 ? 10 : items.length,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.grey[200], blurRadius: 5)
                  ]),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Image(
                      height: 90,
                      width: 100,
                      image:
                          items[index].image != null && items[index].image != ""
                              ? NetworkImage(items[index].image)
                              : AssetImage("assets/images/CrunchTM.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          items[index].name != null && items[index].name != ""
                              ? items[index].name
                              : "N/A",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          items[index].description != null &&
                                  items[index].description != ""
                              ? items[index].description
                              : "N/A",
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "\u20b9${items[index].price != null && items[index].price != "" ? double.parse(items[index].price).toStringAsFixed(2) : "N/A"}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 21),
                            ),
                            items[index].addedToCart
                                ? incDecButton(item: items[index])
                                : addToCartButton(onPressed: () async {
                                    if (items[index].addon.length > 0) {
                                      showItemAddons(context: context, animationController: _controller, itemData: items[index]);
                                    } else {
                                      if(items[index].variation.length == 0) {
                                        setState(() {
                                          items[index].addedToCart = true;
                                        });
                                        if(await addToCart(itemData: items[index]) != null) {
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: Text(
                                              "Added to cart",
                                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                            ),
                                            backgroundColor: primaryColor,
                                            action: SnackBarAction(
                                              label: "GO TO CART",
                                              textColor: Colors.white,
                                              onPressed: () =>
                                                  Navigator.push(context, MaterialPageRoute(builder: (_) => Cart())),
                                            ),
                                          ));
                                        }
                                      } else {
                                        itemVariation(itemData: items[index], context: context);
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
            );
          }),
    );
  }

  Widget incDecButton({@required ItemData item}) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.green[400]),
            borderRadius: BorderRadius.circular(5)),
        width: 73,
        height: 30,
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  item.quantity = item.quantity + 1;
                });
                updateCart(itemData: item);
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
                  setState(() {
                    item.quantity = item.quantity - 1;
                  });
                  updateCart(itemData: item);
                } else if (item.quantity == 1) {
                  var status = await db.delete(SQFLiteTables.tableCart,
                      where: 'item_id = ?', whereArgs: [item.id]);
                  if (status == 1) {
                    setState(() {
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
}
