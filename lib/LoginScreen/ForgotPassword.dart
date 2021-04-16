import 'package:crunch/Screens/widgets/appbar.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: "Review & Ratings",
        context: context
      ),
    );
  }
}
