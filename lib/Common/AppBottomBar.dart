import 'package:crunch/Screens/Account.dart';
import 'package:crunch/Screens/Home.dart';
import 'package:crunch/Screens/Menu_List.dart';
import 'package:crunch/Screens/Rating.dart';
import 'package:flutter/material.dart';
import '../Static/Constant.dart' as cnst;
class AppBottomBar extends StatefulWidget {
  int currentindex;
  AppBottomBar({this.currentindex});
  @override
  _AppBottomBarState createState() => _AppBottomBarState();
}

class _AppBottomBarState extends State<AppBottomBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentindex,
      selectedItemColor: cnst.appPrimaryMaterialColor,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      onTap: (index){
        switch(index){
          case 0:
            Navigator.push(context, MaterialPageRoute(builder: (_) => Home()));
            break;
          case 1:
            Navigator.push(context, MaterialPageRoute(builder: (_) => Menu_list()));
            break;
          case 2:
            Navigator.push(context, MaterialPageRoute(builder: (_) => Rating()));
            break;
          case 3:
            Navigator.push(context, MaterialPageRoute(builder: (_) => Account()));
            break;
        }
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
    return Icon(icon);
  }
  Text buildText(String name){
    return Text(name);
  }
}

