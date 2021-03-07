import 'dart:convert';

import 'package:crunch/APIS/AppServices.dart';
import 'package:crunch/APIS/tables.dart';
import 'package:crunch/Common/carousel.dart';
import 'package:crunch/Common/classes.dart';
import 'package:crunch/Static/Constant.dart' as cnst;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

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
  List<AddonWithGroup> addOnGroups = [];
  bool isLoading = false;
  String addOnsIds = "", databasePath = "";
  AnimationController _controller;
  double price;
  Database db;

  @override
  void initState() {
    createTables();
    super.initState();
    setDb();
    _controller = AnimationController(
      vsync: this,
    );
  }

  setLoading(bool status) {
    setState(() {
      isLoading = status;
    });
  }

  getBanners() async {
    setLoading(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await AppServices.getSlider().then((value) async {
      if (value.value == "y") {
        await prefs.setString("config", jsonEncode(value.data[0]["config"]));
        for (int i = 0; i < value.data[0]["banners"].length; i++) {
          setState(() {
            banners.add(Banners(
                title: value.data[0]["banners"][i]["title"],
                image: Image_URL + value.data[0]["banners"][i]["image"],
                id: value.data[0]["banners"][i]["id"]));
          });
        }
        if (value.data[0]["config"]["sync_status"] == "y") {
          await SQFLiteTables.insertData(db: db);
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

  createTables() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var isTablesCreated = sharedPreferences.getBool("isTablesCreated") ?? false;
    if (isTablesCreated) {
      getBanners();
    } else {
      await SQFLiteTables.createTables(db: db).then((value) async {
        if (value) {
          setLoading(true);
          await SQFLiteTables.insertData(db: db);
          setData();
          getBanners();
          setLoading(false);
        }
      });
      sharedPreferences.setBool("isTablesCreated", true);
    }
  }

  setData() async {
    setState(() {
      items = [];
      categories = [];
    });
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
              variation: jsonDecode(value[i]["variation"])));
        });
      }
    });
  }

  setDb() async {
    databasePath = await getDatabasesPath();
    db = await openDatabase(databasePath + 'myDb.db',
        version: 1, onCreate: (Database db, int version) async {});
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
        appBar: AppBar(
          backgroundColor: cnst.appPrimaryMaterialColor,
          elevation: 2,
          automaticallyImplyLeading: false,
          title: Text(
            "Home",
            style: TextStyle(color: Colors.white),
          ),
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
                            image: e.image,
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
                                        right: index == 0 ? 0 : 10),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                                ? incDecButton(
                                                    item: items[index])
                                                : addToCartButton(
                                                    onPressed: () async {
                                                    if (items[index]
                                                            .addon
                                                            .length >
                                                        0) {
                                                      setState(() {
                                                        price = 0;
                                                        price = double.parse(
                                                            items[index].price);
                                                      });
                                                      await _getAddOnById(
                                                          itemData:
                                                              items[index]);
                                                      showModalBottomSheet(
                                                          context: context,
                                                          builder: (_) {
                                                            return StatefulBuilder(
                                                                builder: (BuildContext
                                                                        context,
                                                                    StateSetter
                                                                        state) {
                                                              return BottomSheet(
                                                                  onClosing:
                                                                      () {},
                                                                  animationController:
                                                                      _controller,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return Container(
                                                                        width: size
                                                                            .width,
                                                                        color: Colors
                                                                            .white,
                                                                        alignment:
                                                                            Alignment
                                                                                .center,
                                                                        child: addOnItems(
                                                                            item:
                                                                                items[index],
                                                                            state: state));
                                                                  });
                                                            });
                                                          });
                                                    } else {
                                                      setState(() {
                                                        items[index]
                                                            .addedToCart = true;
                                                      });
                                                      _addToCart(
                                                          itemData:
                                                              items[index]);
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
                          valueColor: AlwaysStoppedAnimation(cnst.appPrimaryMaterialColor),
                        )),
                    SizedBox(height: 10),
                    Text("Fetching latest menu from restaurant", style: TextStyle(fontSize: 17), maxLines: 2,)
                  ],
                )));
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

  Widget removeFromCart({@required VoidCallback onPressed}) {
    return SizedBox(
        width: 73,
        height: 33,
        child: FlatButton(
          child: Text(
            "REMOVE",
            style: TextStyle(
                color: Colors.green[500],
                fontWeight: FontWeight.bold,
                fontSize: 10),
          ),
          onPressed: onPressed,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(color: Colors.green[500])),
        ));
  }

  _getAddOnById({ItemData itemData}) async {
    setState(() {
      addOnGroups = [];
      addOnsIds = "";
    });
    for (int i = 0; i < itemData.addon.length; i++) {
      setState(() {
        (i == (itemData.addon.length - 1))
            ? addOnsIds += itemData.addon[i]["addon_group_id"] + ""
            : addOnsIds += itemData.addon[i]["addon_group_id"] + ", ";
      });
    }
    var addOns = await SQFLiteTables.where(
        table: Tables.ADD_ON_GROUPS, column: "addongroupid", value: addOnsIds);
    for (int i = 0; i < addOns.length; i++) {
      var addOnsList = jsonDecode(addOns[i]["addongroupitems"]);
      List<AddOnGroup> tempAddOnGroup = [];
      for (int j = 0; j < addOnsList.length; j++) {
        setState(() {
          tempAddOnGroup.add(AddOnGroup(
              active: addOnsList[j]["active"],
              addOnItemId: addOnsList[j]["addonitemid"],
              addOnItemPrice: addOnsList[j]["addonitem_price"],
              addOnName: addOnsList[j]["addonitem_name"],
              attributes: addOnsList[j]["attributes"],
              selected: false));
        });
      }
      addOnGroups.add(AddonWithGroup(addOnGroups: tempAddOnGroup, addOnGroupName: addOns[i]['addongroupname'], addOnGroupId: addOns[i]['addongroupid']));
    }
  }

  Widget addOnItems({ItemData item, StateSetter state}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "ADD ONS",
                style: TextStyle(color: Colors.grey, fontSize: 20),
              )),
        ),
        Divider(),
        Expanded(
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Divider(),
                  Container(
                    child: Text(addOnGroups[index].addOnGroupName, style: TextStyle(
                      fontSize: 17,
                      color: cnst.appPrimaryMaterialColor
                    )),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  Divider(indent: 20, endIndent: 20, height: 0, thickness: 1,),
                  for(int i = 0; i < addOnGroups[index].addOnGroups.length; i++)
                    CheckboxListTile(
                        value: addOnGroups[index].addOnGroups[i].selected,
                        onChanged: (value) {
                          if (addOnGroups[index].addOnGroups[i].selected) {
                            state(() {
                              addOnGroups[index].addOnGroups[i].selected = false;
                              price = price -
                                  double.parse(addOnGroups[index].addOnGroups[i].addOnItemPrice);
                            });
                          } else {
                            state(() {
                              addOnGroups[index].addOnGroups[i].selected = true;
                              price = price +
                                  double.parse(addOnGroups[index].addOnGroups[i].addOnItemPrice);
                            });
                          }
                        },
                        subtitle: Text("\u20b9" + addOnGroups[index].addOnGroups[i].addOnItemPrice),
                        title: Text(addOnGroups[index].addOnGroups[i].addOnName))
                ]
              );
            },
            physics: BouncingScrollPhysics(),
            itemCount: addOnGroups.length,
          ),
        ),
        Divider(
          height: 1,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                "Total payable : \u20b9${price.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              )),
              FlatButton(
                child: Text(
                  "ADD TO CART",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: () => _addToCart(itemData: item),
                color: Colors.green,
              ),
            ],
          ),
        ),
      ],
    );
  }

  _addToCart({@required ItemData itemData}) async {
    double combinedTotal = 0;
    for (int i = 0; i < addOnGroups.length; i++) {
      for(int j = 0; j < addOnGroups[i].addOnGroups.length; j++) {
        if (addOnGroups[i].addOnGroups[j].selected) {
          setState(() {
            combinedTotal += double.parse(addOnGroups[i].addOnGroups[j].addOnItemPrice);
          });
        }
      }
    }
    var id = await db.insert(SQFLiteTables.tableCart, {
      "item_id": "${itemData.id}",
      "item_name": "${itemData.name}",
      "item_price": "${itemData.price}",
      "combined_price": "$combinedTotal",
      "qty": "1"
    });
    for (int i = 0; i < addOnGroups.length; i++) {
      for(int j = 0; j < addOnGroups[i].addOnGroups.length; j++) {
        if (addOnGroups[i].addOnGroups[j].selected) {
          await db.insert(SQFLiteTables.tableCartAddon,
              {"cart_id": "$id", "addon_id": addOnGroups[i].addOnGroups[j].addOnItemId});
        }
      }
    }
    if (itemData.addon.length > 0) Navigator.pop(context);
    Fluttertoast.showToast(msg: "Added to cart");
  }

  _updateCart({ItemData itemData}) async {
    await db.rawQuery(
        "update ${SQFLiteTables.tableCart} set qty = ${itemData.quantity} where item_id = ${itemData.id}");
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
                _updateCart(itemData: item);
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
                  _updateCart(itemData: item);
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

class AddonWithGroup {
  final List<AddOnGroup> addOnGroups;
  final String addOnGroupName, addOnGroupId;

  AddonWithGroup({this.addOnGroups, this.addOnGroupName, this.addOnGroupId});
}