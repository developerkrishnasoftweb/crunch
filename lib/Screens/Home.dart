import 'dart:convert';
import 'dart:ui';
import 'package:crunch/APIS/AppServices.dart';
import 'package:crunch/Common/AppBottomBar.dart';
import 'package:crunch/Common/Carouel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Static/Constant.dart' as cnst;
import 'setLocation.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

List<String> items = ["burger","french fries","sandwiches","chips","pizza","ice cream"];
List<CarouselItems> carousel = [
  CarouselItems(image: AssetImage("assets/products/img1.jpg")),
  CarouselItems(image: AssetImage("assets/products/img2.jpg")),
  CarouselItems(image: AssetImage("assets/products/img3.jpg")),
];
List<CarouselItems> carousel1 = [
  CarouselItems(image: AssetImage("assets/products/img1.jpg")),
  CarouselItems(image: AssetImage("assets/products/img2.jpg")),
  CarouselItems(image: AssetImage("assets/products/img3.jpg")),
];
class _HomeState extends State<Home> {

  List CategorysItem = List();

  @override
  void initState() {
    // TODO: implement initState
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    print(CategorysItem.length);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text("Crunch",style: TextStyle(color: Colors.black),),
        actions: [
          GestureDetector(
            onTap: (){
              _getData();

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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Carousel(
                items: carousel,
                width: size.width,
                height: size.height * 0.28,
              ),
              SizedBox(height: 10.0,),
              Container(
                width: size.width * 0.95,
                height: size.height * 0.15,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: CategorysItem.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset("assets/products/img1.jpg"),
                      );
                    }),
              ),
              Container(
                width: size.width * 0.95,
                height: size.height * 0.385,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return buildProductItem();
                    }),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomBar(currentindex: 0,),
    );
  }

  Container buildProductItem(){
    return Container(
        child: Row(
          children: <Widget>[
            Image.asset("assets/products/img1.jpg",height: 150,width: 150,),
            Container(child: Text("Burger"),)
          ],
        )
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
      if(data.data == "1") {
        // print(""+data.value[0]['details'].toString());
        // print("helooo "+data.Categories.length.toString());
        setState(() {
          CategorysItem = data.Categories;
        });
      }else {
        print("not working");
      }
    });
  }
}
