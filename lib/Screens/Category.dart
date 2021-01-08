import 'package:crunch/Common/AppBottomBar.dart';
import 'package:crunch/Common/classes.dart';
import 'package:flutter/material.dart';
import '../Static/Constant.dart' as cnst;
import 'Menu_List.dart';
import 'setLocation.dart';

class Categorys extends StatefulWidget {
  List productitem,addonitem;
  List<Category> categories;
  Categorys({this.productitem,this.addonitem, this.categories});
  @override
  _CategorysState createState() => _CategorysState();
}

class _CategorysState extends State<Categorys> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "Category",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SetLocation()));
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
     body: widget.categories.length > 0
          ? SingleChildScrollView(
              child: Center(
                child: Container(
                  width: size.width * 0.9,
                  height: size.height * 0.83,
                  child: ListView.builder(
                      itemCount: widget.categories.length,
                      itemBuilder: (context, index) {
                        return buildList(size, widget.categories[index].name);
                      }),
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
      bottomNavigationBar: AppBottomBar(
        currentindex: 2,
      ),
    );
  }

  GestureDetector buildList(size, category) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => Menu_list(
        //   CategoryId: widget.category[index]['categoryid'],
        //   productitem: widget.productitem,
        //   restaurants: [],
        //   addongroup: widget.addonitem,
        // )));
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
                      Colors.pinkAccent.withOpacity(0.4),
                      Colors.pinkAccent.withOpacity(0.4),
                    ],
                    stops: [
                      0.0,
                      1.0
                    ]
                )),
          ),
          Align(
            alignment: Alignment(0.0, 0.03),
            child: Container(
              child: Text(
                category,
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
