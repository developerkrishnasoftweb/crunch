import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../Color/Constant.dart' as cnst;

class AddRatings extends StatefulWidget {
  @override
  _AddRatingsState createState() => _AddRatingsState();
}

class _AddRatingsState extends State<AddRatings> {
  double rate = 1.0;

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
                      width: size.width * 0.7,
                      height: size.width * 0.16,
                      padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: cnst.appPrimaryMaterialColor.withOpacity(0.1),
                      ),
                      child: RatingBar.builder(
                        initialRating: 3,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          size: 70.0,
                          color: cnst.appPrimaryMaterialColor,
                        ),
                        unratedColor: Colors.grey.withOpacity(0.3),
                        itemPadding: EdgeInsets.symmetric(horizontal: 2.5),
                        onRatingUpdate: (rating) {
                          setState(() {
                          });
                        },
                        updateOnDrag: true,
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
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          textAlign: TextAlign.start,
                          keyboardType: TextInputType.multiline,
                          minLines: 7,
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
              onPressed: () {},
              child: Text("Done",style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            ),
          ))
        ],
      ),
    );
  }
}
