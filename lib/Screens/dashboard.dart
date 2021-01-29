import 'package:crunch/Screens/Account.dart';
import 'package:crunch/Screens/cart.dart';
import 'package:crunch/Screens/new_home.dart';
import 'package:crunch/Screens/search_screen.dart';
import 'package:crunch/Static/Constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int bottomNavigationCurrentIndex = 0;
  List<Widget> bodyWidgets = [Home(), Search(), Cart(), Account()];
  List<BottomNavigationBarItem> bottomNavItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
    BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
    BottomNavigationBarItem(
        icon: Icon(Icons.shopping_cart_outlined), label: "Cart"),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodyWidgets[bottomNavigationCurrentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavItems,
        currentIndex: bottomNavigationCurrentIndex,
        elevation: 0,
        unselectedItemColor: Colors.grey,
        selectedItemColor: appPrimaryMaterialColor,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 15,
        unselectedFontSize: 15,
        onTap: (index) {
          setState(() {
            bottomNavigationCurrentIndex = index;
          });
        },
      ),
    );
  }
}
