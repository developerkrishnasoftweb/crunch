import 'dart:convert';

import 'package:crunch/APIS/AppServices.dart';
import 'package:crunch/APIS/tables.dart';
import 'package:crunch/Common/carousel.dart';
import 'package:crunch/Common/classes.dart';
import 'package:crunch/Screens/widgets/appbar.dart';
import 'package:crunch/Screens/widgets/item_card.dart';
import 'package:crunch/Static/Constant.dart';
import 'package:crunch/Static/global.dart';
import 'package:crunch/main.dart';
import 'package:crunch/models/banners_model.dart';
import 'package:crunch/models/config_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'Category.dart';
import 'category_items.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  List<Banners> banners = [];
  List<ItemData> items = [];
  List<Category> categories = [];
  bool isLoading = false;
  AnimationController _controller;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    getBanners();
    _controller = AnimationController(
      vsync: this,
    );
    super.initState();
  }

  setLoading(bool status) {
    setState(() {
      isLoading = status;
    });
  }

  getBanners() async {
    setLoading(true);
    await AppServices.getSlider().then((value) async {
      if (value.value == "y") {
        await sharedPreferences.setString(
            "config", jsonEncode(value.data[0]["config"]));
        await getCredentials();
        for (int i = 0; i < value.data[0]["banners"].length; i++) {
          setState(() {
            banners.add(Banners.fromJson(value.data[0]["banners"][i]));
          });
        }
        if (Config.fromJson(value.data[0]["config"]).syncStatus == "y") {
          await SQFLiteTables.truncate(tables: [
            Tables.RESTAURANTS,
            Tables.ORDER_TYPE,
            Tables.CATEGORY,
            Tables.ITEMS,
            Tables.VARIATIONS,
            Tables.ADD_ON_GROUPS,
            Tables.ATTRIBUTES,
            Tables.DISCOUNTS,
            Tables.TAXES,
            Tables.ADDONS
          ]).then((value) async {
            await SQFLiteTables.insertData();
          });
          setData();
        } else {
          setData();
        }
        setLoading(false);
      } else {
        setLoading(false);
      }
    });
  }

  setData() async {
    items.clear();
    categories.clear();
    await SQFLiteTables.getData(table: Tables.CATEGORY).then((value) {
      for (int i = 0; i < value.length; i++) {
        setState(() {
          categories.add(Category(
              id: value[i]["categoryid"],
              name: value[i]["categoryname"],
              image: value[i]["category_image_url"],
              active: value[i]["active"],
              parentCategoryId: value[i]["parent_category_id"],
              rank: value[i]["categoryrank"],
              timings: value[i]["categorytimings"]));
        });
      }
    });
    await SQFLiteTables.getData(table: Tables.ITEMS).then((value) {
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
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
        appBar: appBar(
          automaticallyImplyLeading: false,
          title: "Home",
          context: context
        ),
        body: !isLoading
            ? Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Carousel(
                        items: banners.map((e) {
                          return CarouselItems(
                            image: Image_URL + e.image,
                          );
                        }).toList(),
                        width: size.width,
                        borderRadius: BorderRadius.circular(7),
                        height: (size.height * 0.25) > 200
                            ? 200
                            : size.height * 0.25,
                      ),
                    ),
                    categories.length > 0
                        ? Align(
                            child: FlatButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Categorys(
                                            categories: categories,
                                          ))),
                              child: Text(
                                "SEE ALL",
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ),
                            alignment: Alignment.centerRight,
                          )
                        : SizedBox(),
                    categories.length > 0
                        ? Container(
                            height: 35,
                            child: ListView.builder(
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    margin: EdgeInsets.only(
                                        left: index == 0 ? 0 : 10),
                                    child: FlatButton(
                                      onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CategoryItems(
                                                    categoryId:
                                                        categories[index].id,
                                                  ))),
                                      child: Text(categories[index].name),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          side: BorderSide(
                                              color: Colors.grey[300])),
                                    ),
                                  );
                                },
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                itemCount: 5),
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: items.length > 10 ? 10 : items.length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            return itemCard(scaffoldKey: scaffoldKey, context: context, animationController: _controller, itemData: items[index]);
                          }),
                    )
                  ],
                ),
              )
            : Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(primaryColor),
                      )),
                  SizedBox(height: 10),
                  Text(
                    "Fetching latest menu from restaurant",
                    style: TextStyle(fontSize: 17),
                    maxLines: 2,
                  )
                ],
              )));
  }
}
