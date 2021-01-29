import 'package:crunch/LoginScreen/Login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  String name, mobile, email;

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
      appBar: AppBar(
        backgroundColor: cnst.appPrimaryMaterialColor,
        elevation: 2,
        automaticallyImplyLeading: false,
        title: Text(
          "Account",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text(
                name ?? "N/A",
                style: TextStyle(fontSize: 20.0),
              ),
              subtitle: Text(
                mobile != null && email != null
                    ? mobile + " - " + email
                    : "N/A",
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
                  child: visiblemood == true
                      ? Icon(Icons.arrow_upward)
                      : Icon(Icons.arrow_forward)),
            ),
            ListTile(
              title: Text(
                "MyOrder",
              ),
              trailing: Icon(Icons.arrow_forward),
            ),
            ListTile(
              title: Text("Logout"),
              trailing: Icon(Icons.power_settings_new),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear().then((value) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                      (route) => false);
                });
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
          visiblemood = !visiblemood;
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
      trailing: visiblemood == true
          ? Icon(Icons.arrow_upward)
          : Icon(Icons.arrow_forward),
    );
  }

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString(cnst.Session.name);
      mobile = prefs.getString(cnst.Session.mobile);
      email = prefs.getString(cnst.Session.email);
    });
    return;
  }
}
