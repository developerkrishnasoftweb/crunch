import 'dart:convert';

import 'package:crunch/Common/item_variations.dart';
import 'package:crunch/Common/items_addons.dart';
import 'package:crunch/Screens/widgets/item_card.dart';
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
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
    return Scaffold(
      key: scaffoldKey,
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
                          return itemCard(scaffoldKey: scaffoldKey, context: context, animationController: _controller, itemData: items[index]);
                        }),
          )
        ],
      ),
    );
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
              itemAttributeId: value[i]["item_attributeid"],
              variation: jsonDecode(value[i]["variation"])));
        });
      }
      setLoading(false);
    }
  }
}
