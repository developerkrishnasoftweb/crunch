import 'dart:ui';
import 'package:crunch/Common/AppBottomBar.dart';
import 'package:crunch/Common/Carouel.dart';
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
  @override
  Widget build(BuildContext context) {
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => SetLocation()));
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
              Carousel(
                items: carousel1,
                width: size.width,
                height: size.height * 0.13,
              ),
              Container(
                width: size.width * 0.9,
                // height: size.height * 0.8,
                child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Row(
                          children: [
                            Container(
                                child: Image.asset(
                                  "assets/products/img1.jpg",
                                  width: 200,height: 200,
                                )
                            )
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomBar(currentindex: 0,),
    );
  }
}
