import 'package:crunch/LoginScreen/Login.dart';
import 'package:crunch/Screens/my_orders.dart';
import 'package:crunch/Screens/widgets/appbar.dart';
import 'package:crunch/Static/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Static/Constant.dart' as cnst;
import 'Address.dart';
import 'ChangePassword.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  bool visibleMood = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        automaticallyImplyLeading: false,
        title: "Account",
        context: context
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text(
                userdata?.name ?? "N/A",
                style: TextStyle(fontSize: 20.0),
              ),
              subtitle: Text(
                userdata?.email ?? "N/A",
                style: TextStyle(fontSize: 13.0),
              ),
              trailing: Text("Edit"),
              contentPadding: EdgeInsets.symmetric(horizontal: 25.0),
            ),
            ExpansionTile(
              title: Text("My Account"),
              subtitle: Text("Address, Change Password, Inquiry, Other"),
              children: [
                ListTile(
                  title: Text("Mange Address"),
                  leading: Icon(Icons.home),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Address()));
                  },
                ),
                ListTile(
                  title: Text("Change Password"),
                  leading: Icon(Icons.lock),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangePassword()));
                  },
                ),
                ListTile(
                  title: Text("Inquiry"),
                  leading: Icon(Icons.mail),
                  trailing: Icon(Icons.arrow_forward),
                ),
                ListTile(
                  title: Text("Offers"),
                  leading: Icon(Icons.local_offer),
                  trailing: Icon(Icons.arrow_forward),
                ),
              ],
            ),
            ListTile(
              title: Text(
                "Help",
                style: TextStyle(),
              ),
              subtitle: Text(
                "FAQ & Links",
                style: TextStyle(fontSize: 13.0),
              ),
              trailing: GestureDetector(
                  onTap: () {
                    setState(() {
                      // visiblemood = !visiblemood;
                    });
                  },
                  child: visibleMood == true
                      ? Icon(Icons.arrow_upward)
                      : Icon(Icons.arrow_forward)),
            ),
            ListTile(
              title: Text(
                "My Order",
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyOrders())),
            ),
            ListTile(
                title: Text(
                  "Contact Support",
                ),
                trailing: Icon(Icons.arrow_forward),
                onTap: () async {
                  if (await canLaunch('tel:${config.contact}'))
                    await launch('tel:${config.contact}');
                }),
            ListTile(
              title: Text("Logout"),
              trailing: Icon(Icons.power_settings_new),
              onTap: () async {
                await sharedPreferences.clear();
                userdata = null;
                if (sharedPreferences.getString('userdata') == null) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                      (route) => false);
                }
              },
            )
          ],
        ),
      ),
    );
  }

  ListTile buildMenuItem(String title, subtitle) {
    return ListTile(
      onTap: () {
        setState(() {
          visibleMood = !visibleMood;
        });
      },
      contentPadding: EdgeInsets.fromLTRB(12.0, 5.0, 12.0, 5.0),
      title: Text(
        title,
        style: TextStyle(),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 13.0),
      ),
      trailing: visibleMood == true
          ? Icon(Icons.arrow_upward)
          : Icon(Icons.arrow_forward),
    );
  }
}
