import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  String title;
  Function ontap;
  double width,height;
  Color btncolor;

  CustomButton({this.title,this.ontap,this.width,this.btncolor,this.height});
  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      elevation: 5.0,
      height: widget.height != null ? widget.height : size.height * 0.07,
      minWidth: widget.width == null ? size.width * 0.85 : widget.width,
      color: widget.btncolor,
      child: new Text(widget.title,
          style: new TextStyle(fontSize: 16.0, color: Colors.white)),
      onPressed: widget.ontap
    );
  }
}
