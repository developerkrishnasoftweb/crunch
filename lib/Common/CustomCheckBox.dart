import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget {
  String title,price;
  bool cvalue;
  CustomCheckBox({this.title,this.price,this.cvalue});
  @override
  _CustomCheckBoxState createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CheckboxListTile(
          title: Stack(
            overflow: Overflow.visible,
              children: [
                Text(widget.title,style: TextStyle(fontSize: 15.0),),
                Positioned(
                  right: -17.0,
                    child: Text("\u20B9${widget.price}",style: TextStyle(fontSize: 15.0),))
              ],
            ),
          value: widget.cvalue,
          onChanged: (val){
            print(widget.cvalue);
            setState(() {
              return widget.cvalue = val;
            });
          }
      ),
    );
  }
}
