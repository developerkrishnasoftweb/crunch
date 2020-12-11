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
  final _random = Random();
  List<CarouselItems> carousel;

  @override
  void initState() {
    // TODO: implement initState
    _getData();
    // getSliderData();
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
          GestureDetector(
            onTap: () {
              getSliderData();
              // _getData();
              // Navigator.push(context, MaterialPageRoute(builder: (context) => SetLocation()));
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                Icons.location_on,
                size: 23,
                color: cnst.AppColors.blackcolor,
              ),
            ),
          )
        ],
      ),
      body:_slider.length > 0
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
                                  builder: (context) =>
                                      Categorys(category: CategorysItem,productitem: ProductItem,)));
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
                                        ))),
                            child: Container(
                              margin: EdgeInsets.all(5.0),
                              width: 120,
                              height: 150,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(5.0),
                                  image: DecorationImage(
                                      image: AssetImage("assets/images/cate.png")
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
                        ?  Image.network(
                          Image_URL+product['item_image_url'],
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
                          )
                ),
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
                    style: TextStyle(
                        fontSize: 14.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("\u20B9 "+ product['price'],
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold)),
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
            print("d: ${Image_URL+data.data[0]['image']}");
            setState(() {
              isLoading = false;
            });
            for (int i = 0; i < data.data.length; i++) {
              print("work");
              _slider.add(data.data[i]);
              print("add_"+_slider.toString());
            }
            setState(() {
              carousel = [
                CarouselItems(image: NetworkImage(Image_URL+_slider[0]["image"]),title: _slider[0]["title"]),
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
