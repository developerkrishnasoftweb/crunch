import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: TextField(
            decoration: InputDecoration(
                hintText: "Search",
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black))),
          ),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
