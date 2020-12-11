import 'package:crunch/Common/AppBottomBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:crunch/LoginScreen/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Static/Constant.dart' as cnst;
import 'Address.dart';
import 'ChangePassword.dart';
class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  bool visiblemood = false;
  String name,mobile,email;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: size.width,
                decoration: BoxDecoration(
                    color: cnst.AppColors.whitecolor,
                  border: Border(
                      top: BorderSide(width: 2.0,color: cnst.AppColors.blackcolor,)
                  )
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(name,style: TextStyle(fontSize: 20.0),),
                      subtitle: Text(mobile+"-"+email,style: TextStyle(fontSize: 13.0),),
                      trailing: Text("Edit"),
                      contentPadding: EdgeInsets.symmetric(horizontal: 25.0),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(width: 2.0,color: cnst.AppColors.blackcolor,)
                            )
                        ),
                        child: Column(
                          children: [
                            buildMenuItem("MyAccount","Address, Change password, Inquiry, Other "),
                            Visibility(
                              maintainSize: false,
                              maintainAnimation: true,
                              maintainState: true,
                              visible: visiblemood,
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text("Mange Address"),
                                    leading: Icon(Icons.home),
                                    trailing: Icon(Icons.arrow_forward_rounded),
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Address()));
                                    },
                                  ),
                                  ListTile(
                                    title: Text("Change Password"),
                                    leading: Icon(Icons.lock),
                                    trailing: Icon(Icons.arrow_forward_rounded),
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePassword()));
                                    },
                                  ),
                                  ListTile(
                                    title: Text("Inquiry"),
                                    leading: Icon(Icons.mail),
                                    trailing: Icon(Icons.arrow_forward_rounded),
                                  ),
                                  ListTile(
                                    title: Text("Offers"),
                                    leading: Icon(Icons.local_offer_outlined),
                                    trailing: Icon(Icons.arrow_forward_rounded),
                                  ),
                                ],
                              ),
                            ),
                            Divider(thickness: 2,),
                            ListTile(
                              contentPadding: EdgeInsets.fromLTRB(12.0,5.0,12.0,5.0),
                              title: Text("Help",style: TextStyle(),),
                              subtitle: Text("FAQ & Links",style: TextStyle(fontSize: 13.0),),
                              trailing: GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      // visiblemood = !visiblemood;
                                    });
                                  },
                                  child: visiblemood == true ?Icon(Icons.arrow_upward_rounded):Icon(Icons.arrow_forward_rounded)
                              ),
                            ),
                            Divider(thickness: 2,),
                            ListTile(
                              contentPadding: EdgeInsets.fromLTRB(12.0,5.0,12.0,5.0),
                              title: Text("MyOrder",style: TextStyle(),),
                              // subtitle: Text("FAQ & Links",style: TextStyle(fontSize: 13.0),),
                              trailing: GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      // visiblemood = !visiblemood;
                                    });
                                  },
                                  child: visiblemood == true ?Icon(Icons.arrow_upward_rounded):Icon(Icons.arrow_forward_rounded)
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 25.0),
                width: size.width,
                decoration: BoxDecoration(
                    color: cnst.AppColors.whitecolor,
                ),
                child: GestureDetector(
                  onTap: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.clear();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 25.0),
                    title: Text("Logout"),
                    trailing: Icon(Icons.power_settings_new),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomBar(currentindex: 3,),
    );
  }

  ListTile buildMenuItem(String title,subtitle){
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(12.0,5.0,12.0,5.0),
      title: Text(title,style: TextStyle(),),
      subtitle: Text(subtitle,style: TextStyle(fontSize: 13.0),),
      trailing: GestureDetector(
          onTap: (){
            setState(() {
              visiblemood = !visiblemood;
            });
          },
          child: visiblemood == true ?Icon(Icons.arrow_upward_rounded):Icon(Icons.arrow_forward_rounded)
      ),
    );
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString(cnst.Session.name);
      mobile = prefs.getString(cnst.Session.mobile);
      email = prefs.getString(cnst.Session.email);
    });
  }
}

