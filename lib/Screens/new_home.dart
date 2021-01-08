import 'package:crunch/APIS/Constants.dart';
import 'package:crunch/Common/Carouel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List category = [], item = [];
  List<Banners> banners = [];
  bool isLoading = false;
  @override
  void initState() {
    getCategories();
    super.initState();
  }

  getCategories() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var isTablesCreated = sharedPreferences.getBool("isTablesCreated");
    if(isTablesCreated != null && isTablesCreated) {
      setData();
    } else {
      setState(() {
        isLoading = true;
      });
      String databasePath = await getDatabasesPath();
      Database db = await openDatabase(databasePath + 'myDb.db',
          version: 1, onCreate: (Database db, int version) async {});
      await SQFLiteTables.createTables(db: db).then((value) async {
        if (value) {
          await SQFLiteTables.insertData(db: db).then((value) {
            sharedPreferences.setBool("isTablesCreated", true);
            setData();
          });
        }
      });
    }
  }

  setData() {
    SQFLiteTables.getData(table: Tables.CATEGORY).then((value) {
      setState(() {
        category = value;
      });
    });
    SQFLiteTables.getData(table: Tables.ITEMS).then((value) {
      setState(() {
        item = value;
      });
    });
    setState(() {
      isLoading = false;
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
                        items: [
                          NetworkImage(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOFqWNId4CW6zQUhh6A7nGk50hxrxzriqZXg&usqp=CAU"),
                          NetworkImage(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRhTQMR-McEvkynUp8-NtlHqX2EYxizH3g2wQ&usqp=CAU"),
                          NetworkImage(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTux4YnVzgr6yNWhc8yMO4euXJb6Fg01oIjEA&usqp=CAU")
                        ].map((e) {
                          return CarouselItems(
                            image: e,
                          );
                        }).toList(),
                        width: size.width * 0.9,
                        borderRadius: BorderRadius.circular(7),
                        height: size.height * 0.3,
                      ),
                    ),
                    category.length > 0
                        ? Align(
                            child: FlatButton(
                              onPressed: () {},
                              child: Text(
                                "SEE ALL",
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ),
                            alignment: Alignment.centerRight,
                          )
                        : SizedBox(),
                    category.length > 0
                        ? Container(
                            height: 35,
                            child: ListView.separated(
                                itemBuilder: (BuildContext context, int index) {
                                  return FlatButton(
                                    onPressed: () {},
                                    child: Text(category[index]["categoryname"]
                                        .toString()),
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
                          itemCount: item.length > 10 ? 10 : item.length,
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
                                        image: item[index]["item_image_url"] !=
                                                    null &&
                                                item[index]["item_image_url"] !=
                                                    ""
                                            ? NetworkImage(item[index]
                                                    ["item_image_url"]
                                                .toString())
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
                                            item[index]["itemname"] != null &&
                                                    item[index]["itemname"] !=
                                                        ""
                                                ? item[index]["itemname"]
                                                : "N/A",
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            item[index]["itemdescription"] !=
                                                        null &&
                                                    item[index][
                                                            "itemdescription"] !=
                                                        ""
                                                ? item[index]["itemdescription"]
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
                                                "\u20b9${item[index]["price"] != null && item[index]["price"] != "" ? item[index]["price"] : "N/A"}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 21),
                                              ),
                                              incDecButton(),
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

  Widget addButton() {
    return SizedBox(
        width: 73,
        height: 33,
        child: FlatButton(
          child: Text(
            "ADD",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
          ),
          onPressed: () {},
          color: Colors.green[500],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
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

class ItemData {
  final String name,
      description,
      id,
      itemCategoryId,
      itemOrderType,
      itemAllowAddOn,
      inStock,
      image;
  final List variation, addon;
  ItemData(
      {this.id,
      this.name,
      this.image,
      this.addon,
      this.description,
      this.inStock,
      this.itemAllowAddOn,
      this.itemCategoryId,
      this.itemOrderType,
      this.variation});
}
class Banners {
  final String id, title, image, status;
  Banners({this.image, this.id, this.status, this.title});
}