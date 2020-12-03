import 'dart:ui';
import 'package:crunch/Common/AppBottomBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Static/Constant.dart' as cnst;
import 'setLocation.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

List<String> items = ["burger","french fries","sandwiches","chips","pizza","ice cream"];

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
          child: Container(
            width: size.width * 0.9,
            height: size.height * 0.9,
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Text("hello");
                }),
          ),
        ),
      ),
      bottomNavigationBar: AppBottomBar(currentindex: 0,),
    );
  }
}
