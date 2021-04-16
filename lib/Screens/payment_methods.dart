import 'package:crunch/Screens/widgets/appbar.dart';
import 'package:crunch/Static/Constant.dart';
import 'package:flutter/material.dart';

class PaymentMethods extends StatefulWidget {
  @override
  _PaymentMethodsState createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
          context: context,
          title: "Payment Methods"),
    );
  }
}
