import 'dart:convert';

import 'package:crunch/Common/items_addons.dart';
import 'package:crunch/Static/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../APIS/tables.dart';
import '../Common/classes.dart';
import '../Static/Constant.dart';
import 'cart.dart';
import 'new_home.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with SingleTickerProviderStateMixin {
  List<ItemData> items = [];
  bool isLoading = false, noDataFound = false;
  AnimationController _controller;

  setLoading(bool status) {
    setState(() {
      isLoading = status;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          Container(
            height: 45,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.grey[200], blurRadius: 10)],
                color: Colors.white,
                borderRadius: BorderRadius.circular(4)),
            child: TextField(
              decoration: InputDecoration(
                  hintText: "Search",
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  border: InputBorder.none),
              onChanged: _search,
              onSubmitted: (value) => FocusScope.of(context).unfocus(),
            ),
          ),
          Expanded(
            child: noDataFound
                ? Center(
                    child: Text("No item (s) found :("),
                  )
                : isLoading
                    ? Center(
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(primaryColor),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: items.length,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
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
                                    image: items[index].image != null &&
                                            items[index].image != ""
                                        ? NetworkImage(items[index].image)
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
                                        items[index].name != null &&
                                                items[index].name != ""
                                            ? items[index].name
                                            : "N/A",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        items[index].description != null &&
                                                items[index].description != ""
                                            ? items[index].description
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
                                            "\u20b9${items[index].price != null && items[index].price != "" ? double.parse(items[index].price).toStringAsFixed(2) : "N/A"}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 21),
                                          ),
                                          items[index].addedToCart
                                              ? incDecButton(item: items[index])
                                              : addToCartButton(
                                                  onPressed: () async {
                                                  if (items[index]
                                                          .addon
                                                          .length >
                                                      0) {
                                                    showItemAddons(itemData: items[index], animationController: _controller, context: context);
                                                  } else {
                                                    if(items[index].variation.length == 0) {
                                                      setState(() {
                                                        items[index].addedToCart = true;
                                                      });
                                                      addToCart(itemData: items[index]);
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
          )
        ],
      ),
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

  _search(String keyword) async {
    if (keyword.isNotEmpty) {
      setLoading(true);
      setState(() {
        items = [];
      });
      var value = await db.rawQuery(
          "select * from ${SQFLiteTables.tableItems} where itemname like '$keyword%'");
      if (value.length == 0)
        setState(() {
          noDataFound = true;
        });
      else
        setState(() {
          noDataFound = false;
        });
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
      setLoading(false);
    }
  }
}
