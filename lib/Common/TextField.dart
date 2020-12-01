import 'package:flutter/material.dart';
import '../Color/Constant.dart' as cnst;

class CustomTextField extends StatefulWidget {
  TextEditingController textcontroller;
  bool obtext;
  String hint;
  double borderside;
  Icon texticon;
  Color textColor;

  CustomTextField({this.textcontroller,this.texticon,this.obtext,this.hint,this.textColor,this.borderside});
  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width *0.85,
      height: size.height * 0.07,
      decoration: BoxDecoration(
          color: cnst.AppColors.whitecolor.withOpacity(0.3),
          border: widget.borderside == null ? null : Border.all(color: widget.textColor.withOpacity(0.2), width: 1),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.only(left: 10,top: 7.0),
        child: TextFormField(
          controller: widget.textcontroller,
          obscureText: widget.obtext,
          textAlign: TextAlign.start,
          scrollPadding: EdgeInsets.all(0),
          style: TextStyle(
            color: widget.textColor,
            fontSize: 18.0,
          ),
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) {
            FocusScope.of(context).unfocus();
          },
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.texticon,
            floatingLabelBehavior:
            FloatingLabelBehavior.never,
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: widget.textColor,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
