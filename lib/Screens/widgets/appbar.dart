import 'package:crunch/Static/Constant.dart';
import 'package:flutter/material.dart';

AppBar appBar(
    {@required BuildContext context,
    String title,
    Widget leading,
    List<Widget> actions,
    Color backgroundColor, bool automaticallyImplyLeading = true}) {
  return AppBar(
    title: title != null
        ? Text(
            "$title",
            style: TextStyle(color: Colors.white),
          )
        : null,
    leading: leading ??
        (automaticallyImplyLeading ? IconButton(
          splashRadius: 25,
          onPressed: () => Navigator.maybePop(context),
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
        ) : null),
    automaticallyImplyLeading: automaticallyImplyLeading,
    actions: actions,
    backgroundColor: backgroundColor ?? primaryColor,
  );
}
