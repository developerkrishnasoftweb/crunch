import 'package:flutter/material.dart';
import '../Common/TextField.dart';
import '../Common/CustomButton.dart';
import '../Static/Constant.dart' as cnst;

class Add_Address extends StatefulWidget {
  @override
  _Add_AddressState createState() => _Add_AddressState();
}

class _Add_AddressState extends State<Add_Address> {

  TextEditingController Address = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController country = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_sharp,color: Colors.black,)),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text("Add New Address",style: TextStyle(color: Colors.black),),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(right:10.0,top: 15.0),
              child: Text("cancel",style: TextStyle(fontSize: 20.0,color: cnst.AppColors.blackcolor),),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16.0,),
              CustomTextField(textcontroller: Address,obtext: true,hint: "Address", textColor: cnst.appPrimaryMaterialColor.withOpacity(0.5),borderside: 1.0,
              ),
              SizedBox(height: 16.0,),
              CustomTextField(textcontroller: pincode,obtext: true,hint: "Pincode", textColor: cnst.appPrimaryMaterialColor.withOpacity(0.5),
                borderside: 1.0,),
              SizedBox(height: 16.0,),
              CustomTextField(textcontroller: city,obtext: true,hint: "City", textColor: cnst.appPrimaryMaterialColor.withOpacity(0.5),
                borderside: 1.0,),
              SizedBox(height: 16.0,),
              CustomTextField(textcontroller: state,obtext: true,hint: "State", textColor: cnst.appPrimaryMaterialColor.withOpacity(0.5),
                borderside: 1.0,),
              SizedBox(height: 16.0,),
              CustomTextField(textcontroller: country,obtext: true,hint: "Country", textColor: cnst.appPrimaryMaterialColor.withOpacity(0.5),
                borderside: 1.0,),
              SizedBox(height: 16.0,),
              CustomButton(
                title: "Add Address",btncolor: cnst.appPrimaryMaterialColor,
                ontap: () {
                  Validation();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Validation() {

  }



}
