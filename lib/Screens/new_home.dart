import 'dart:convert';
import 'package:crunch/APIS/AppServices.dart';
import 'package:crunch/APIS/Constants.dart';
import 'package:crunch/Common/Carouel.dart';
import 'package:crunch/Common/classes.dart';
import 'package:crunch/Screens/Category.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // List category = [], item = [];
  List<Banners> banners = [];
  List<ItemData> items = [];
  List<Category> categories = [];
  bool isLoading = false;
  @override
  void initState() {
    createTables();
    super.initState();
  }

  setLoading(bool status) {
    setState(() {
      isLoading = status;
    });
  }

  getBanners() async {
    setLoading(true);
    String databasePath = await getDatabasesPath();
    Database db = await openDatabase(databasePath + 'myDb.db',
        version: 1, onCreate: (Database db, int version) async {});
    AppServices.getSlider().then((value) async {
      if (value.value == "y") {
        for (int i = 0; i < value.data[0]["banners"].length; i++) {
          setState(() {
            banners.add(Banners(
                title: value.data[0]["banners"][i]["title"],
                image: Image_URL + value.data[0]["banners"][i]["image"],
                id: value.data[0]["banners"][i]["id"]));
          });
        }
        if(value.data[0]["config"]["sync_status"] == "y") {
          SQFLiteTables.insertData(db: db);
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
    var isTablesCreated = sharedPreferences.getString("isTablesCreated");
    if (isTablesCreated != null && isTablesCreated.isNotEmpty) {
      String databasePath = await getDatabasesPath();
      Database db = await openDatabase(databasePath + 'myDb.db',
          version: 1, onCreate: (Database db, int version) async {});
      await SQFLiteTables.createTables(db: db).then((value) async {
        if(value) {
          SQFLiteTables.insertData(db: db);
          setData();
        }
      });
    } else {
      getBanners();
    }
  }

  setData() async {
    setState(() {
      items = [];
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
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[50],
          elevation: 0,
          title: Center(
            child: Container(
              width: size.width * 0.9,
              height: 45,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: Colors.grey[300]),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[200],
                      blurRadius: 5,
                    )
                  ]),
              child: TextFormField(
                  decoration: InputDecoration(
                hintText: "Find Items",
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 20, top: 0, bottom: 7),
              )),
            ),
          ),
        ),
        body: !isLoading
            ? SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
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
                        width: size.width * 0.9,
                        borderRadius: BorderRadius.circular(7),
                        height: size.height * 0.3,
                      ),
                    ),
                    categories.length > 0
                        ? Align(
                            child: FlatButton(
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Categorys(categories: categories,))),
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
                            child: ListView.separated(
                                itemBuilder: (BuildContext context, int index) {
                                  return FlatButton(
                                    onPressed: () {},
                                    child: Text(categories[index].name),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                        side: BorderSide(
                                            color: Colors.grey[300])),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return SizedBox(
                                    width: 10,
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
                    Container(
                      height: size.height * 0.47,
                      child: ListView.builder(
                          itemCount: items.length > 10 ? 10 : items.length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {},
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(7),
                                      child: Image(
                                        height: 100,
                                        width: 120,
                                        image: items[index].image !=
                                                    null &&
                                            items[index].image !=
                                                    ""
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
                                                items[index].name !=
                                                        ""
                                                ? items[index].name
                                                : "N/A",
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            items[index].description !=
                                                        null &&
                                                items[index].description !=
                                                        ""
                                                ? items[index].description
                                                : "N/A",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "\u20b9${items[index].price != null && items[index].price != "" ? items[index].price : "N/A"}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 21),
                                              ),
                                              items[index].addedToCart ? incDecButton() : addToCartButton(
                                                  onPressed: (){
                                                    if(items[index].addon.length > 0) {
                                                      Scaffold.of(context).showBottomSheet((context) {
                                                        return BottomSheet(onClosing: (){}, builder: (BuildContext context){
                                                          return Container(
                                                            height: size.height * 0.3,
                                                            width: size.width,
                                                            color: Colors.white,
                                                            alignment: Alignment.center,
                                                            child: Text("Hello"),
                                                          );
                                                        });
                                                      });
                                                    } else {
                                                      setState(() {
                                                        items[index].addedToCart = true;
                                                      });
                                                    }
                                                  }
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                ),
              )
            : Center(
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.grey),
                  ),
                ),
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

  Widget removeFromCart({@required VoidCallback onPressed}) {
    return SizedBox(
        width: 73,
        height: 33,
        child: FlatButton(
          child: Text(
            "REMOVE",
            style: TextStyle(
                color: Colors.green[500], fontWeight: FontWeight.bold, fontSize: 10),
          ),
          onPressed: onPressed,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4), side: BorderSide(color: Colors.green[500])),
        ));
  }

  Widget incDecButton() {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.green[400]),
            borderRadius: BorderRadius.circular(5)),
        width: 73,
        height: 30,
        child: Row(
          children: [
            GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.add,
                size: 23,
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                color: Colors.green[400],
                child: Text("1"),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.remove,
                size: 23,
              ),
            )
          ],
        ));
  }
}
