import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 10.0,),
            TextFormField(
              textAlign: TextAlign.start,
              keyboardType: TextInputType.text,
              obscureText: true,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
              ),
              controller: email,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) {
                FocusScope.of(context).unfocus();
              },
              decoration: InputDecoration(
                //filled: true,
                //fillColor: Colors.grey.withOpacity(0.1),
                hintText: "Email",
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.grey.shade100, width: 0.1),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                hintStyle: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 15,
                ),
              ),
            ),
            SizedBox(height: 10.0,),
            TextFormField(
              textAlign: TextAlign.start,
              keyboardType: TextInputType.text,
              obscureText: true,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
              ),
              controller: password,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) {
                FocusScope.of(context).unfocus();
              },
              decoration: InputDecoration(
                //filled: true,
                //fillColor: Colors.grey.withOpacity(0.1),
                hintText: "Password",
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.grey.shade100, width: 0.1),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                hintStyle: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 15,
                ),
              ),
            ),
            TextField(),
            Text("Hello"),
          ],
        ),
      ),
    );
  }
}
