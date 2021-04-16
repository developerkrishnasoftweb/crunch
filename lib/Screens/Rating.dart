import 'package:crunch/Screens/AddRatings.dart';
import 'package:crunch/Screens/widgets/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Rating extends StatefulWidget {
  @override
  _RatingState createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(
        context: context,
        title: "Review & Ratings",
        actions: [
          GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddRatings()));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          child: ListView.builder(
              itemCount: 2,
              itemBuilder: (context, index) {
                return buildRatingView(size);
              }),
        ),
      ),
    );
  }

  Container buildRatingView(size) {
    return Container(
      margin: EdgeInsets.all(5.0),
      width: size.width,
      height: size.height * 0.1,
      child: ListTile(
          leading: CircleAvatar(
              radius: 30, child: Image.asset("assets/images/CrunchTM.png")),
          title: Text("Cheey Does It"),
          subtitle: Container(
              child: Text(
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry.")),
          trailing: buildRatingShow(size, "2.5")),
    );
  }

  Container buildRatingShow(size, number) {
    return Container(
        width: size.width * 0.1,
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(5.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.star,
              color: Color(0xffffb910),
              size: 17,
            ),
            Text(
              number,
              style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }
}
