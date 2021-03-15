import 'package:crunch/Common/classes.dart';
import 'package:crunch/Screens/category_items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Static/Constant.dart' as cnst;
import 'setLocation.dart';

class Categorys extends StatefulWidget {
  List<Category> categories;

  Categorys({@required this.categories});

  @override
  _CategorysState createState() => _CategorysState();
}

class _CategorysState extends State<Categorys> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cnst.primaryColor,
        elevation: 0.0,
        title: Text(
          "Category",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.location_on_outlined),
              splashRadius: 25,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SetLocation()));
              })
        ],
      ),
      body: widget.categories.length > 0
          ? ListView.builder(
              itemCount: widget.categories.length,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 10),
              itemBuilder: (context, index) {
                return buildList(widget.categories[index]);
              })
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  GestureDetector buildList(Category category) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryItems(categoryId: category.id)));
      },
      child: Container(
        width: size.width * 0.9,
        height: 70,
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.transparent,
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'assets/images/spalsh.png',
              ),
              colorFilter: ColorFilter.mode(Colors.black12, BlendMode.overlay)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Text(
                  category.name,
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 15.0),
              height: 40,
              width: 5,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
            )
          ],
        ),
      ),
    );
  }
}
