import 'package:flutter/material.dart';
import 'Add_Address.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import '../APIS/AppServices.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Static/Constant.dart' as cnst;

class Address extends StatefulWidget {
  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  bool isLoading = true;
  List _address = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAddtess();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_sharp,color: Colors.black,)),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text("Address",style: TextStyle(color: Colors.black),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 0),
          child: ListView.builder(
              itemCount: 2,
              itemBuilder: (context,index){
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
                  height: size.height * 0.13,
                  color: Colors.grey,
                );
              }
          )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => Add_Address()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  getAddtess() async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String id = prefs.getString(cnst.Session.id);
        print("cust is " + id);
        FormData d = FormData.fromMap({
          "api_key": "0imfnc8mVLWwsAawjYr4Rx",
          "customer_id" : id,
        });
        setState(() {
          isLoading = true;
        });
        AppServices.getAddress(d).then((data) async {
          if (data.value == "y") {
            print("dl: ${data.data.length}");
            setState(() {
              isLoading = false;
            });
            for (int i = 0; i < data.data.length; i++) {
              print("work");
              _address.add(data.data[i]);
              print("add_"+_address.toString());
            }
          } else {
            setState(() {
              isLoading = false;
              _address.clear();
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          _toastMesssage("Something went wrong.");
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
      });
      _toastMesssage("No Internet Connection.");
    }
  }

  _toastMesssage(String message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white.withOpacity(0.3),
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
