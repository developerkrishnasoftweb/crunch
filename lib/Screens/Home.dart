import 'dart:ui';

import 'package:crunch/LoginScreen/Login.dart';
import 'package:crunch/Screens/Menu_List.dart';
import 'package:crunch/Screens/Rating.dart';
import 'package:crunch/Screens/setLocation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Color/Constant.dart' as cnst;
import 'Account.dart';

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
        leading: Icon(Icons.menu,color: Colors.black,),
        title: Text("Crunch",style: TextStyle(color: Colors.black),),
        actions: [
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Account()));
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                Icons.person,
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
                  return buildList(size,index);
                }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => SetLocation()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  GestureDetector buildList(size,index) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => Menu_list()));
      },
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.1,
        margin: EdgeInsets.fromLTRB(5.0, 8.0, 5.0, 8.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
        child: Stack(children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.transparent,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  'assets/images/spalsh.png',
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                gradient: LinearGradient(
                    begin: FractionalOffset.topLeft,
                    end: FractionalOffset.bottomLeft,
                    colors: [
                      Colors.red.withOpacity(0.4),
                      Colors.pinkAccent.withOpacity(0.4),
                    ],
                    stops: [
                      0.0,
                      1.0
                    ])),
          ),
          Align(
            alignment: Alignment(0.0, 0.03),
            child: Container(
              child: Text(
                items[index],
                style: TextStyle(fontSize: 27.0, color: Colors.white),
              ),
            ),
          ),
          Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: EdgeInsets.only(right: 15.0),
                height: 40,
                width: 5,
                color: Colors.white,
              ))
        ]),
      ),
    );
  }
}
