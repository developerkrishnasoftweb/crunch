import 'package:flutter/material.dart';
import '../Static/Constant.dart' as cnst;


class CustomCounterBtn extends StatefulWidget {
  double height,width;
  int index;
  bool addproduct;
  Function ontap;
  CustomCounterBtn({this.height,this.width,this.index,this.addproduct,this.ontap});
  @override
  _CustomCounterBtnState createState() => _CustomCounterBtnState();
}

class _CustomCounterBtnState extends State<CustomCounterBtn> {
  bool addproduct = false;
  List<int> count = [1, 1, 1];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          buildIconButton(Icons.remove, widget.index, count, widget.height, widget.width),
          Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
                border: Border.all(width: 1),
              color: cnst.appPrimaryMaterialColor.withOpacity(0.5),
            ),
            child: Center(
              child: Text('${count[0]}',
                  style: Theme.of(context).textTheme.subtitle1),
            ),
          ),
          buildIconButton(Icons.add, widget.index, count,widget.height, widget.width),
        ],
      ),
    );
  }

  GestureDetector buildIconButton(
      IconData icon, int index, count, double height, width) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (icon == Icons.remove) {
            if (count[index] > 0)
              count[index]--;
            else
              widget.ontap;
            print(widget.ontap);
          } else {
            count[index]++;
          }
        });
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            border: Border.all( width: 1)),
        child: Center(
            child: Icon(
              icon,
              size: 16.0,
              color: cnst.AppColors.blackcolor,
            )),
      ),
    );
  }
}
