import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:crunch/APIS/AppServices.dart';
import 'package:crunch/APIS/Constants.dart';
import 'package:crunch/Common/AppBottomBar.dart';
import 'package:crunch/Common/Carouel.dart';
import 'package:crunch/Screens/Menu_List.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import '../Static/Constant.dart' as cnst;
import 'Category.dart';
import 'setLocation.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

List<String> items = [
  "burger",
  "french fries",
  "sandwiches",
  "chips",
  "pizza",
  "ice cream"
];
// List<CarouselItems> carousel = [
//   CarouselItems(image: AssetImage("assets/products/img1.jpg"),),
//   CarouselItems(image: AssetImage("assets/products/img2.jpg")),
//   CarouselItems(image: AssetImage("assets/products/img3.jpg")),
// ];
List<CarouselItems> carousel1 = [
  CarouselItems(image: AssetImage("assets/products/img1.jpg")),
  CarouselItems(image: AssetImage("assets/products/img2.jpg")),
  CarouselItems(image: AssetImage("assets/products/img3.jpg")),
];

class _HomeState extends State<Home> {
  List CategorysItem = List();
  List ProductItem = List();
  List Restaurants = List();
  bool isLoading = true;
  List _slider = List();
  List Addonitem = List();
  final _random = Random();
  List<CarouselItems> carousel;

  @override
  void initState() {
    // TODO: implement initState
    _getData();
    // getSliderData();
  }
  String _replaceChar(String char) {
    return char.replaceAll(r"'", r"''");
  }
  _setData() async {
    String tablesList,
        tableRestaurants = "restaurants",
        tableOrderType = "ordertype",
        tableCategory = "category",
        tableItems = "items",
        tableVariations = "variations",
        tableAddOnGroups = "addongroups",
        tableAttributes = "attributes",
        tableDiscounts = "discounts",
        tableTaxes = "taxes";
    var databasesPath = await getDatabasesPath();
    var db = await openDatabase(databasesPath + 'myDb.db',
        version: 1, onCreate: (Database db, int version) async {});
    db.execute("drop table if exists $tableRestaurants");
    db.execute("drop table if exists $tableOrderType");
    db.execute("drop table if exists $tableCategory");
    db.execute("drop table if exists $tableItems");
    db.execute("drop table if exists $tableVariations");
    db.execute("drop table if exists $tableAddOnGroups");
    db.execute("drop table if exists $tableAttributes");
    db.execute("drop table if exists $tableDiscounts");
    db.execute("drop table if exists $tableTaxes");
    db.execute(
        "create table if not exists `$tableRestaurants` (`restaurantid` varchar(10), `menusharingcode` varchar(20), `restaurantname` varchar(50), `address` text, `contact` varchar(20), `lat` varchar(20), `lang` varchar(20), `landmark` varchar(50), `city` varchar(20), `state` varchar(30), `minimumorderamount` varchar(5), `minimumdeliverytime` varchar(30), `deliverycharge` varchar(5), `packaging_charge` varchar(15), `packaging_charge_type` varchar(20))");
    db.execute(
        "create table if not exists `$tableOrderType` (`ordertypeid` varchar(3), `ordertype` varchar(15))");
    db.execute(
        "create table if not exists `$tableCategory` (`categoryid` varchar(6), `active` varchar(3), `categoryrank` varchar(2), `parent_category_id` varchar(2), `categoryname` varchar(30), `categorytimings` varchar(50), `category_image_url` text)");
    db.execute(
        "create table if not exists `$tableItems` (`itemid` varchar(100),`itemallowvariation` varchar(100),`itemrank` varchar(100),`item_categoryid` varchar(100),`item_ordertype` varchar(100),`item_packingcharges` varchar(100),`itemallowaddon` varchar(100),`itemaddonbasedon` varchar(100),`item_favorite` varchar(100),`ignore_taxes` varchar(100),`ignore_discounts` varchar(100),`in_stock` varchar(100),`variation` text, `addon` text, `itemname` varchar(100), `itemdescription` varchar(200), `price` varchar(4), `image` varchar(100), item_tax varchar(50), preparationtime varchar(5))");
    db.execute(
        "create table if not exists `$tableVariations` (`variationid` varchar(100),`name` varchar(100),`groupname` varchar(100),`status` varchar(1))");
    db.execute(
        "create table if not exists `$tableAddOnGroups`(`addongroupid` varchar(100),`addongroup_rank` varchar(100),`active` varchar(1), `addongroupitems` text, `addongroupname` varchar(50))");
    db.execute(
        "create table if not exists `$tableAttributes` (`attributeid` varchar(100),`attribute` varchar(100),`active` varchar(1))");
    db.execute(
        "create table if not exists `$tableDiscounts` (`discountid` varchar(100),`discountname` varchar(100),`discounttype` varchar(100),`discount` varchar(100),`discountordertype` varchar(100),`discountapplicableon` varchar(100),`discountdays` varchar(100),`active` varchar(100),`discountontotal` varchar(100),`discountstarts` varchar(100),`discountends` varchar(100),`discounttimefrom` varchar(100),`discounttimeto` varchar(100),`discountminamount` varchar(100),`discountmaxamount` varchar(100),`discounthascoupon` varchar(100),`discountcategoryitemids` varchar(100),`discountmaxlimit` varchar(100))");
    db.execute(
        "create table if not exists `$tableTaxes` (`taxid` varchar(100),`taxname` varchar(100),`tax` varchar(100),`taxtype` varchar(100),`tax_ordertype` varchar(100),`active` varchar(1),`tax_coreortotal` varchar(100),`tax_taxtype` varchar(100),`rank` varchar(100),`description` varchar(100))");
    // var res = await db.rawQuery("select * from taxes");
    // db.execute("insert into `ordertype` values ('1', 'Delivery')");
    // print(await db.rawQuery("select * from `ordertype`"));
    AppServices.fetchMenu().then((menuList) async {
      if (menuList.response == "1") {
        for (int i = 0; i < menuList.orderTypes.length; i++) {
          db.execute(
              "insert into `$tableOrderType` values ('${menuList.orderTypes[i]["ordertypeid"]}', '${menuList.orderTypes[i]["ordertype"]}')");
        }
        for (int i = 0; i < menuList.restaurants.length; i++) {
          // print(menuList.restaurants[i]["details"]["menusharingcode"]);
          db.execute(
              "insert into `$tableRestaurants` values ('${menuList.restaurants[i]["restaurantid"]}', '${menuList.restaurants[i]["details"]["menusharingcode"]}', '${menuList.restaurants[i]["details"]["restaurantname"]}', '${menuList.restaurants[i]["details"]["address"]}', '${menuList.restaurants[i]["details"]["contact"]}', '${menuList.restaurants[i]["details"]["latitude"]}', '${menuList.restaurants[i]["details"]["longitude"]}', '${menuList.restaurants[i]["details"]["landmark"]}', '${menuList.restaurants[i]["details"]["city"]}', '${menuList.restaurants[i]["details"]["state"]}', '${menuList.restaurants[i]["details"]["minimumorderamount"]}', '${menuList.restaurants[i]["details"]["minimumdeliverytime"]}', '${menuList.restaurants[i]["details"]["deliverycharge"]}', '${menuList.restaurants[i]["details"]["packaging_charge"]}', '${menuList.restaurants[i]["details"]["packaging_charge_type"]}')");
        }
        for (int i = 0; i < menuList.categories.length; i++) {
          db.execute(
              "insert into `$tableCategory` values ('${menuList.categories[i]["categoryid"]}', '${menuList.categories[i]["active"]}', '${menuList.categories[i]["categoryrank"]}', '${menuList.categories[i]["parent_category_id"]}', '${_replaceChar(menuList.categories[i]["categoryname"])}', '${menuList.categories[i]["categorytimings"]}', '${menuList.categories[i]["category_image_url"]}')");
        }
        for (int i = 0; i < menuList.items.length; i++) {
          db.execute("insert into `$tableItems` values ('${menuList.items[i]["itemid"]}', '${menuList.items[i]["itemallowvariation"]}', '${menuList.items[i]["itemrank"]}', '${menuList.items[i]["item_categoryid"]}', '${menuList.items[i]["item_ordertype"]}', '${menuList.items[i]["item_packingcharges"]}', '${menuList.items[i]["itemallowaddon"]}', '${menuList.items[i]["itemaddonbasedon"]}', '${menuList.items[i]["item_favorite"]}', '${menuList.items[i]["ignore_taxes"]}', '${menuList.items[i]["ignore_discounts"]}', '${menuList.items[i]["in_stock"]}', '${jsonEncode(menuList.items[i]["variation"])}', '${jsonEncode(menuList.items[i]["addon"])}', '${menuList.items[i]["itemname"]}', '${menuList.items[i]["itemdescription"]}', '${menuList.items[i]["price"]}', '${menuList.items[i]["item_image_url"]}', '${menuList.items[i]["item_tax"]}', '${menuList.items[i]["minimumpreparationtime"]}')");
        }
        for (int i = 0; i < menuList.variations.length; i++) {
          db.execute("insert into `$tableVariations` values ('${menuList.variations[i]["variationid"]}', '${menuList.variations[i]["name"]}', '${menuList.variations[i]["groupname"]}', '${menuList.variations[i]["status"]}')");
        }
        for (int i = 0; i < menuList.addOnGroups.length; i++) {
          db.execute("insert into `$tableAddOnGroups` values ('${menuList.addOnGroups[i]["addongroupid"]}', '${menuList.addOnGroups[i]["addongroup_rank"]}', '${menuList.addOnGroups[i]["active"]}', '${jsonEncode(menuList.addOnGroups[i]["addongroupitems"])}', '${menuList.addOnGroups[i]["addongroup_name"]}')");
        }
        for (int i = 0; i < menuList.attributes.length; i++) {
          db.execute("insert into `$tableAttributes` values ('${menuList.attributes[i][""]}')");
        }
        var result = await db.rawQuery("select * from `$tableAddOnGroups`");
        print(result.length);
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "Crunch",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.location_on_outlined),
            onPressed: _setData,
            color: Colors.black,
          ),
        ],
      ),
      body: _slider.length > 0
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Carousel(
                    items: carousel,
                    width: size.width,
                    height: size.height * 0.28,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      height: 17.0,
                      child: FlatButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Categorys(
                                        category: CategorysItem,
                                        productitem: ProductItem,
                                        addonitem: Addonitem,
                                      )));
                        },
                        // padding: const EdgeInsets.only(right: 15.0),
                        child: Text("see more"),
                      ),
                    ),
                  ),
                  Container(
                      width: size.width * 0.95,
                      height: size.height * 0.14,
                      child: ListView.builder(
                        itemCount: 8,
                        semanticChildCount: 3,
                        addAutomaticKeepAlives: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => Menu_list(
                                          CategoryId: CategorysItem[index]
                                              ['categoryid'],
                                          productitem: ProductItem,
                                          restaurants: [],
                                          addongroup: Addonitem,
                                        ))),
                            child: Container(
                              margin: EdgeInsets.all(5.0),
                              width: 120,
                              height: 150,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(5.0),
                                  image: DecorationImage(
                                    image: CategorysItem[index]
                                                ['category_image_url'] ==
                                            ""
                                        ? AssetImage("assets/images/cate.png")
                                        : NetworkImage(CategorysItem[index]
                                            ['category_image_url']),
                                  )),
                            ),
                          );
                        },
                      )),
                  Container(
                    width: size.width * 0.95,
                    height: size.height * 0.385,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          return buildProductItem(ProductItem[index]);
                        }),
                  ),
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
      bottomNavigationBar: AppBottomBar(
        currentindex: 0,
      ),
    );
  }

  Container buildProductItem(product) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Stack(
            children: [
              ClipRRect(
                  clipBehavior: Clip.hardEdge,
                  borderRadius: BorderRadius.circular(3),
                  child: product['item_image_url'] != ""
                      ? Image.network(
                          Image_URL + product['item_image_url'],
                          // "assets/products/img1.jpg",
                          height: 85,
                          width: 100,
                          fit: BoxFit.fill,
                        )
                      : Image.asset(
                          // Image_URL+product['item_image_url'],
                          "assets/products/img1.jpg",
                          height: 85,
                          width: 100,
                          fit: BoxFit.fill,
                        )),
              Positioned(
                right: 2.0,
                top: 2.0,
                child: Icon(
                  Icons.check_box_outlined,
                  size: 15,
                  color: cnst.AppColors.greencolor,
                ),
              )
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.45,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  product['itemname'],
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text("\u20B9 " + product['price'],
                    textAlign: TextAlign.right,
                    style:
                        TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future _getData() async {
    var d = {
      "access_token": "04fc7877ce7e5f771328b2a1434cb040ad1b2c0f",
      "app_key": "f14qd3se9a6juzbmoit85c0nrvhykgwp",
      "app_secret": "0ecb9930ec89b68dbc923d3ecedc43f37901cf61",
      "restID": "k13cv5ho",
      "last_updated_on": "",
      "data_type": "json"
    };
    await AppServices.getCategories(d).then((data) {
      if (data.data == "1") {
        // print(""+data.value[0]['details'].toString());
        // print("helooo "+data.Categories.length.toString());
        setState(() {
          CategorysItem = data.Categories;
          ProductItem = data.Items;
          Restaurants = data.Restaurant;
          Addonitem = data.addongroups;
        });
      } else {
        print("not working");
      }
    });
    getSliderData();
  }

  getSliderData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        FormData d = FormData.fromMap({
          "api_key": "0imfnc8mVLWwsAawjYr4Rx",
        });
        setState(() {
          isLoading = true;
        });
        AppServices.getSlider(d).then((data) async {
          if (data.value == "y") {
            print("dl: ${data.data.length}");
            print("d: ${Image_URL + data.data[0]['image']}");
            setState(() {
              isLoading = false;
            });
            for (int i = 0; i < data.data.length; i++) {
              print("work");
              _slider.add(data.data[i]);
              print("add_" + _slider.toString());
            }
            setState(() {
              carousel = [
                CarouselItems(
                    image: NetworkImage(Image_URL + _slider[0]["image"]),
                    title: _slider[0]["title"]),
              ];
            });
          } else {
            setState(() {
              isLoading = false;
              _slider.clear();
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
            _slider.clear();
          });
          showMsg("Something went wrong.");
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
      });
      showMsg("No Internet Connection.");
    }
  }

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Crunch"),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Close",
                style: TextStyle(color: cnst.appPrimaryMaterialColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
