import 'dart:convert';

import 'package:crunch/APIS/tables.dart';
import 'package:crunch/Common/classes.dart';
import 'package:crunch/Screens/widgets/item_card.dart';
import 'package:crunch/Static/Constant.dart';
import 'package:crunch/Static/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../APIS/tables.dart';
import '../Common/classes.dart';

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
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
    );
    _getCategoryData();
  }

  _getCategoryData() async {
    var value = await db.rawQuery(
        "select * from `${SQFLiteTables.tableItems}` where `active` = '1' and `item_categoryid` = ${widget.categoryId}");
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
            itemAttributeId: value[i]["item_attributeid"],
            variation: jsonDecode(value[i]["variation"])));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Items",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      body: ListView.builder(
          itemCount: items.length,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            return itemCard(scaffoldKey: scaffoldKey, context: context, animationController: _controller, itemData: items[index]);
          }),
    );
  }
}
