import 'package:flutter/material.dart';
import '../Color/Constant.dart' as cnst;
class AppBottomBar extends StatefulWidget {
  int currentindex;
  AppBottomBar({this.currentindex});
  @override
  _AppBottomBarState createState() => _AppBottomBarState();
}

class _AppBottomBarState extends State<AppBottomBar> {
  int curindex = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: curindex,
      onTap: (index){
        setState(() {
          curindex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: buildIcon(Icons.home),
          title: buildText("Crunch"),
        ),
        BottomNavigationBarItem(
          icon: buildIcon(Icons.search),
          title: buildText("Search"),
        ),
        BottomNavigationBarItem(
            icon: buildIcon(Icons.shopping_cart),
            title:buildText("Cart")
        ),
        BottomNavigationBarItem(
            icon: buildIcon(Icons.person),
            title:buildText("Account")
        )
      ],
    );
  }
  Icon buildIcon(icon){
    return Icon(icon,color: cnst.AppColors.blackcolor,);
  }
  Text buildText(String name){
    return Text(name,style: TextStyle(color: cnst.AppColors.blackcolor,));
  }
}

