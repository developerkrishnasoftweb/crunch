import 'dart:convert';

import 'package:crunch/APIS/Constants.dart';
import 'package:crunch/Common/classes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryItems extends StatefulWidget {
  final String categoryId;
  CategoryItems({@required this.categoryId});
  @override
  _CategoryItemsState createState() => _CategoryItemsState();
}

class _CategoryItemsState extends State<CategoryItems>
    with SingleTickerProviderStateMixin {
  List<ItemData> items = [];

  List<AddOnGroup> addOnGroups = [];
  bool isLoading = false;
  String addOnGroupName = "";
  AnimationController _controller;
  double price;
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Items",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
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
                              "\u20b9${items[index].price != null && items[index].price != "" ? items[index].price : "N/A"}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 21),
                            ),
                            items[index].addedToCart
                                ? incDecButton()
                                : addToCartButton(onPressed: () async {
                                    if (items[index].addon.length > 0) {
                                      setState(() {
                                        price = 0;
                                        price =
                                            double.parse(items[index].price);
                                      });
                                      await _getAddOnById(
                                          addOnId: items[index].addon[0]
                                              ["addon_group_id"]);
                                      Scaffold.of(context)
                                          .showBottomSheet((context) {
                                        return BottomSheet(
                                            onClosing: () {},
                                            elevation: 4,
                                            animationController: _controller,
                                            builder: (BuildContext context) {
                                              return Container(
                                                  height: size.height * 0.4,
                                                  width: size.width,
                                                  color: Colors.white,
                                                  alignment: Alignment.center,
                                                  child: addOnItems(
                                                      item: items[index]));
                                            });
                                      });
                                    } else {
                                      setState(() {
                                        items[index].addedToCart = true;
                                      });
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

  _getAddOnById({String addOnId}) async {
    setState(() {
      addOnGroups = [];
      addOnGroupName = "";
    });
    var addOns = await SQFLiteTables.where(
        table: Tables.ADD_ON_GROUPS, column: "addongroupid", value: addOnId);
    setState(() {
      addOnGroupName = addOns[0]["addongroupname"];
    });
    var addOnsList = jsonDecode(addOns[0]["addongroupitems"]);
    for (int i = 0; i < addOnsList.length; i++) {
      setState(() {
        addOnGroups.add(AddOnGroup(
            active: addOnsList[i]["active"],
            addOnItemId: addOnsList[i]["addonitemid"],
            addOnItemPrice: addOnsList[i]["addonitem_price"],
            addOnName: addOnsList[i]["addonitem_name"],
            attributes: addOnsList[i]["attributes"],
            selected: false));
      });
    }
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

  Widget addOnItems({ItemData item}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                addOnGroupName ?? "N/A",
                style: TextStyle(color: Colors.grey, fontSize: 20),
              )),
        ),
        Divider(),
        Expanded(
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return CheckboxListTile(
                  value: addOnGroups[index].selected,
                  onChanged: (value) {
                    if (addOnGroups[index].selected) {
                      setState(() {
                        addOnGroups[index].selected = false;
                        price = price -
                            double.parse(addOnGroups[index].addOnItemPrice);
                      });
                    } else {
                      setState(() {
                        addOnGroups[index].selected = true;
                        price = price +
                            double.parse(addOnGroups[index].addOnItemPrice);
                      });
                    }
                  },
                  subtitle: Text("\u20b9" + addOnGroups[index].addOnItemPrice),
                  title: Text(addOnGroups[index].addOnName));
            },
            physics: BouncingScrollPhysics(),
            itemCount: addOnGroups.length,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                "Total payable : \u20b9$price",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              )),
              FlatButton(
                child: Text(
                  "ADD TO CART",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: _addToCart,
                color: Colors.green,
              ),
            ],
          ),
        ),
      ],
    );
  }

  _addToCart() async {
    for (int i = 0; i < addOnGroups.length; i++) {
      if (addOnGroups[i].selected) {
        print(addOnGroups[i].addOnName);
      }
    }
  }

  Widget incDecButton() {
    int qty = 1;
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
                  qty = qty++;
                });
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
                child: Text("$qty"),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (qty != 1) {
                  setState(() {
                    qty--;
                  });
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
