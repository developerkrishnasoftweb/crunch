import 'dart:convert';
import 'package:crunch/Common/AppBottomBar.dart';
import 'package:crunch/Common/CustomButton.dart';
import 'package:crunch/Common/CustomCheckBox.dart';
import 'package:crunch/Common/CustomCounterBtn.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../Static/Constant.dart' as cnst;
import 'Home.dart';

class Menu_list extends StatefulWidget {
  List productitem,restaurants,addongroup;
  String CategoryId;
  Menu_list({this.productitem, this.CategoryId,this.restaurants,this.addongroup});

  @override
  _Menu_listState createState() => _Menu_listState();
}

class Product {
  Product(this.image, this.productName, this.productType, this.price);

  String image;
  String productName;
  String productType;
  String price;
}

class _Menu_listState extends State<Menu_list> {
  void initState() {
    // TODO: implement initState
    _getItemsData();
  }
  bool isLoading = true;
  List _items = [];
  List<int> count = [1, 1, 1];
  bool addproduct = false;
  bool item1 = true,
      item2 = false,
      item3 = false,
      item4 = false,
      item5 = false,
      item6 = false,
      item7 = false,
      item8 = false,
      item9 = false,
      item10 = false,
      item11 = false,
      item12 = false,
      item13 = false,
      item14 = false;
  final List<String> categories = [
    "vegetables",
    "bakery",
    "foodgrain",
  ];
  final List<Product> products = [
    Product("assets/images/spalsh.png", "locale.freshRedOnios", "Pajeroma",
        "\$30.0"),
    Product("assets/images/CrunchTM.png", "locale.freshRedTomatoes",
        "Lecoil Eeva", "\$44.0"),
    Product("assets/images/spalsh.png", "locale.mediumPotatoes", "Pajeroma",
        "\$29.0"),
  ];


  _getItemsData() {
    for (int i = 0; i < widget.productitem.length; i++) {
      if (widget.productitem[i]["item_categoryid"] == widget.CategoryId) {
        setState(() {
          isLoading = false;
        });
        setState(() {
          _items.add(widget.productitem[i]);
        });
      }else{
        setState(() {
          isLoading = false;
        });
      }
    }
    // _getAddonItemsData();
    // if (int.parse(widget.CategoryId) == widget.productitem[])
  }

 _getAddonItemsData(index) {
    for (int i = 0; i < widget.addongroup.length; i++) {
      for (int j = 0 ; j < widget.productitem[index]['addon'].length; j++) {
        if (_items[0]['addon'][j]['addon_group_id'] ==
            widget.addongroup[i]['addongroupid']) {
          setState(() {
            isLoading = false;
          });
          print("check " + widget.addongroup[i]["addongroupitems"].toString());
          setState(() {
            // _items.add(widget.addongroup[i]);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.addongroup.length);
    print(widget.productitem[0]['addon'][0]["addon_group_id"]+" " +
        widget.addongroup[0]['addongroupid'].toString());
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_sharp,
              color: Colors.black,
            )),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: ListTile(
          title: Text(
            "Truck 21 | UK10Aj1075",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Adarsh Balniketan, Century Gate, 12-C, Roorkee ",
            style: TextStyle(color: Colors.black, fontSize: 12.0),
          ),
        ),
      ),
      body:
          isLoading
          ? Center(child: CircularProgressIndicator())
          : _items.length > 0
            ? SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                child: Column(
                  children: [
                    buildCompleteVerticalList(context, _items, "Items"),
                    // buildCompleteVerticalList(context, products, "SouthIndian"),
                  ],
                ),
              ),
            )
          :Center(
            child: Text("No Items Available",
                style: TextStyle(fontSize: 20, color: Colors.black38)),
          ),
      bottomNavigationBar: AppBottomBar(
        currentindex: 1,
      ),
    );
  }

  Column buildCompleteVerticalList(
      BuildContext context, itemsProduct, String heading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(heading,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        buildList(itemsProduct, context),
      ],
    );
  }

  GestureDetector buildList(List products, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // _settingModalBottomSheet(context);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                              clipBehavior: Clip.hardEdge,
                              borderRadius: BorderRadius.circular(3),
                              child: Image.network(
                                products[index]['item_image_url'],
                                height: 85,
                                width: 85,
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
                              products[index]['itemname'],
                              style: TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                                products[index]['itemdescription'],
                              style: TextStyle(fontSize: 13.0),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text("\u20B9 "+ products[index]['price'],
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      products[index]['addon'] != ""
                          ? GestureDetector(
                              onTap: () {
                                // print(products[index]['addon'][0]['addon_group_id']);
                                // print("add on "+widget.addongroup[0]["addongroupid"]);
                                // for(int i = 0; i < widget.addongroup.length; i++ )
                                //   {
                                //     for (int j = 0 ; j < products[index]['addon'].length; j++){
                                //       if(products[0]['addon'][j]['addon_group_id'] == widget.addongroup[i]['addongroupid']) {
                                //         print("check "+widget.addongroup[i]["addongroupitems"].toString());
                                //       }
                                //     }
                                //   }
                                _getAddonItemsData(index);
                                // setState(() {
                                //   _settingModalBottomSheet(context);
                                // });
                              },
                              child: Container(
                                  width: 78,
                                  height: 27,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3.0),
                                      border: Border.all(width: 1)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "ADD",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Icon(
                                        Icons.add,
                                        size: 15.0,
                                        color: cnst.appPrimaryMaterialColor,
                                      )
                                    ],
                                  )),
                            )
                          : CustomCounterBtn(
                              width: 26.0,
                              height: 27.0,
                              index: 0,
                              addproduct: addproduct,
                              ontap: () {
                                setState(() {
                                  // addproduct = false;
                                });
                              }),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  _settingModalBottomSheet(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
            margin: EdgeInsets.only(bottom: 10),
            child: new Wrap(
              spacing: 01.0,
              children: <Widget>[
                new ListTile(
                    title: new Text("Crunch Fish Shots W Dip"),
                    subtitle: Text("Served with regular size dip"),
                    trailing: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.cancel_outlined)),
                    onTap: () => {}),
                Divider(
                  thickness: 1,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Column(
                    children: [
                      ListTile(
                          title: new Text("Extra Dip"),
                          subtitle: Text("You can Choose up to 5 options"),
                          onTap: () => {}),
                      CustomCheckBox(
                        title: "Mexican Mayo Dip",
                        price: "49",
                        cvalue: item1,
                      ),
                      CustomCheckBox(
                        title: "Mango Jalapeno Dip",
                        price: "49",
                        cvalue: item2,
                      ),
                      CustomCheckBox(
                        title: "Mexican Mayo Dip",
                        price: "49",
                        cvalue: item3,
                      ),
                      CustomCheckBox(
                        title: "Peri Peri Mayo Dip",
                        price: "49",
                        cvalue: item4,
                      ),
                      CustomCheckBox(
                        title: "Brabecue Mayo Dip",
                        price: "49",
                        cvalue: item5,
                      ),
                      CustomCheckBox(
                        title: "Cheesy Mayo Dip",
                        price: "49",
                        cvalue: item6,
                      ),
                      ListTile(
                          title: new Text("Sprinklers"),
                          subtitle: Text("Please select any on option"),
                          onTap: () => {}),
                      CustomCheckBox(
                        title: "Peri-peri Sprinkler",
                        price: "49",
                        cvalue: item6,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10.0),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomCounterBtn(
                              width: 30.0,
                              height: 43.0,
                              index: 0,
                            ),
                            CustomButton(
                                width: MediaQuery.of(context).size.width * 0.65,
                                height: 45,
                                title: "ADD \u20B9308",
                                btncolor: cnst.appPrimaryMaterialColor,
                                ontap: () {
                                  setState(() {
                                    addproduct = true;
                                    Navigator.pop(context);
                                  });
                                }),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
