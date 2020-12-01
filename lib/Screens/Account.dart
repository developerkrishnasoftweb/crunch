import 'package:crunch/Common/AppBottomBar.dart';
import 'package:flutter/material.dart';
import '../Color/Constant.dart' as cnst;
class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Container(
          width: size.width,
          decoration: BoxDecoration(
            border: Border(
                top: BorderSide(width: 2.0,color: cnst.AppColors.blackcolor,)
            )
          ),
          child: Column(
            children: [
              Container(
                color: cnst.AppColors.whitecolor,
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                child: ,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomBar(currentindex: 3,),
    );
  }
}

