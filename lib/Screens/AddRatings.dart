import 'dart:io';

import 'package:crunch/APIS/AppServices.dart';
import 'package:crunch/APIS/Constants.dart';
import 'package:crunch/Screens/Home.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../Static/Constant.dart' as cnst;

class AddRatings extends StatefulWidget {
  @override
  _AddRatingsState createState() => _AddRatingsState();
}

class _AddRatingsState extends State<AddRatings> {
  double rate;
  TextEditingController ratecomment = TextEditingController();
  ProgressDialog pr;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Please wait..");
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
        title: Text("Review & Ratings",style: TextStyle(color: Colors.black),),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              width: size.width *0.9,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.0,),
                    Container(
                      width: size.width * 0.8,
                      // height: size.width * 0.16,
                      padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: cnst.appPrimaryMaterialColor.withOpacity(0.1),
                      ),
                      child: Center(
                        child: RatingBar.builder(
                          initialRating: 0,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            size: size.width,
                            color: cnst.appPrimaryMaterialColor,
                          ),
                          unratedColor: Colors.grey.withOpacity(0.3),
                          itemPadding: EdgeInsets.symmetric(horizontal: 2.5),
                          onRatingUpdate: (rating) {
                            setState(() {
                              rate = rating;
                            });
                            print(rate);
                          },
                          updateOnDrag: true,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    Text("Rate your experience",style: TextStyle(fontSize: 17.0 ),),
                    SizedBox(height: 50.0,),
                    Container(
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          textAlign: TextAlign.start,
                          keyboardType: TextInputType.multiline,
                          minLines: 7,
                          controller: ratecomment,
                          maxLines: 8,
                          scrollPadding: EdgeInsets.all(0),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                          ),
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).unfocus();
                          },
                          decoration: InputDecoration(
                            hintText: "Write your experience",
                            floatingLabelBehavior:
                            FloatingLabelBehavior.never,
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,left: 0,right: 0,
              child: Container(
                height: size.height * 0.1,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(topLeft:Radius.circular(30.0),topRight: Radius.circular(30.0))
                ),
            child: FlatButton(
              onPressed: () {
                _validation();
              },
              child: Text("Done",style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            ),
          ))
        ],
      ),
    );
  }

  _validation() {
    if(rate == null || rate == 0.0){
      _toastMesssage("Please give your rating");
    }else if(ratecomment.text == ""){
      _toastMesssage("please enter your comment");
    } else {
      _addrating();
    }
  }

  _addrating() async {
    try{
      pr.show();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String id = prefs.getString(cnst.Session.id);
        print(id+" "+ratecomment.text+ " " +rate.toString() + " ");
        FormData d = FormData.fromMap({
          "api_key" : API_Key,
          "customer_id" : id,
          "comment" : ratecomment.text,
          "rate" : rate,
        });

        AppServices.addrate(d).then((data) async {
          pr.hide();
          if(data.value == "y"){
            print(data.data);
            _toastMesssage(data.message);
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Home()), (route) => false);
          }
        },onError: (e) {
          pr.hide();
          _toastMesssage("Something went wrong.");
        });
      }
    }catch(e){
      pr.hide();
      _toastMesssage("No Internet Connection.");
    }
  }

  _toastMesssage(String message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black.withOpacity(0.3),
        textColor: Colors.white,
        fontSize: 16.0
    );
  }


}
