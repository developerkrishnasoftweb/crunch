import 'package:crunch/Common/AppBottomBar.dart';
import 'package:crunch/Common/CustomButton.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../Static/Constant.dart' as cnst;
import 'Home.dart';

class Menu_list extends StatefulWidget {
  @override
  _Menu_listState createState() => _Menu_listState();
}

class Product {
  Product(this.image, this.productName, this.productType, this.price);

  String image;
  String productName;
  String productType;
  String price;
}

class _Menu_listState extends State<Menu_list> {
  List<int> count = [1, 1, 1];
  bool addproduct = false;
  bool item1 = false,
      item2 = false,
      item3 = false,
      item4 = false,
      item5 = false,
      item6 = false,
      item7 = false,
      item8 = false,
      item9 = false,
      item10 = false,
      item11 = false,
      item12 = false,
      item13 = false,
      item14 = false;
  final List<String> categories = [
    "vegetables",
    "bakery",
    "foodgrain",
  ];
  final List<Product> products = [
    Product("assets/images/spalsh.png", "locale.freshRedOnios", "Pajeroma",
        "\$30.0"),
    Product("assets/images/CrunchTM.png", "locale.freshRedTomatoes",
        "Lecoil Eeva", "\$44.0"),
    Product("assets/images/spalsh.png", "locale.mediumPotatoes", "Pajeroma",
        "\$29.0"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_sharp,
              color: Colors.black,
            )),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: ListTile(
          title: Text(
            "Truck 21 | UK10Aj1075",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Adarsh Balniketan, Century Gate, 12-C, Roorkee ",
            style: TextStyle(color: Colors.black, fontSize: 12.0),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          child: Column(
            children: [
              buildCompleteVerticalList(context, products, "SouthIndian"),
              buildCompleteVerticalList(context, products, "SouthIndian"),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomBar(
        currentindex: 1,
      ),
    );
  }

  Column buildCompleteVerticalList(
      BuildContext context, List<Product> category, String heading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(heading,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        buildList(category, context),
      ],
    );
  }

  GestureDetector buildList(List<Product> products, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // _settingModalBottomSheet(context);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 15.0),
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                              clipBehavior: Clip.hardEdge,
                              borderRadius: BorderRadius.circular(3),
                              child: Image.asset(
                                "assets/products/img1.jpg",
                                height: 85,
                                width: 85,
                                fit: BoxFit.fill,
                              )),
                          Positioned(
                            right: 2.0,
                            top: 2.0,
                            child: Icon(
                              Icons.check_box_outlined,
                              size: 15,
                              color: cnst.AppColors.greencolor,
                            ),
                          )
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.95,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Special Masala Dosa",
                              style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              "Dosa spreaded with melted butter and spiced potato",
                              style: TextStyle(fontSize: 12.0),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text("\u20B9122",
                                textAlign: TextAlign.right,
                                style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _settingModalBottomSheet(context);
                          });
                        },
                        child:Container(
                            width: 79,
                            height: 27,
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(3.0),
                                border: Border.all(width: 1)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("ADD",style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(width: 2,),
                                Icon(Icons.add,size: 15.0,color: cnst.appPrimaryMaterialColor,)
                              ],
                            )
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  GestureDetector buildIconButton(
      IconData icon, int index, items, count, double height, width) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (icon == Icons.remove) {
            if (count[index] > 0)
              count[index]--;
            else
              setState(() {
                addproduct = !addproduct;
              });
          } else {
            count[index]++;
          }
        });
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1),
            border: Border.all(color: cnst.AppColors.greencolor, width: 2)),
        child: Center(
            child: Icon(
              icon,
              size: 16.0,
              color: cnst.AppColors.blackcolor,
            )),
      ),
    );
  }

  Row buildCheckBox(String title, price, _check) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 15.0),
        ),
        Row(
          children: [
            Text("\u20B9${price}"),
            Checkbox(
              value: _check,
              onChanged: (val) {
                setState(() {
                  _check = val;
                });
              },
            ),
          ],
        ),
      ],
    );
  }
  _settingModalBottomSheet(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            margin: EdgeInsets.only(bottom: 10),
            child: new Wrap(
              spacing: 01.0,
              children: <Widget>[
                new ListTile(
                    title: new Text("Crunch Fish Shots W Dip"),
                    subtitle: Text("Served with regular size dip"),
                    trailing: Icon(Icons.cancel_outlined),
                    onTap: () => {}),
                Divider(
                  thickness: 1,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                  child: Column(
                    children: [
                      ListTile(
                          title: new Text("Extra Dip"),
                          subtitle: Text("You can Choose up to 5 options"),
                          onTap: () => {}),
                      buildCheckBox("Mexican Mayo Dip", "49", item1),
                      buildCheckBox("Mango Jalapeno Dip", "49", item2),
                      buildCheckBox("Peri Peri Mayo Dip", "49", item3),
                      buildCheckBox("Brabecue Mayo Dip", "49", item4),
                      buildCheckBox("Plain Mayo Dip", "49", item5),
                      // buildCheckBox("Cheesy Mayo Dip","49",item6),
                      // buildCheckBox("Texas Bbq Sauce","49",item7),
                      // buildCheckBox("Red Devil Sauce","49",item8),
                      // buildCheckBox("Garlic Mayo Dip","49",item9),
                      // buildCheckBox("Garlic Mayo Dip","49",item9),
                      ListTile(
                          title: new Text("Desert"),
                          subtitle: Text("Please select any on option"),
                          onTap: () => {}),
                      buildCheckBox(
                          "Chocolava Cake W Cashew Nuts", "49", item10),
                      ListTile(
                          title: new Text("Sprinklers"),
                          subtitle: Text("Please select any on option"),
                          onTap: () => {}),
                      buildCheckBox("Peri-peri Sprinkler", "49", item11),
                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10.0),
                        padding:
                        EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                buildIconButton(Icons.remove, 0, products,
                                    count, 45.0, 30.0),
                                Container(
                                  width: 27,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: cnst.AppColors.greencolor,
                                  ),
                                  child: Center(
                                    child: Text('${count[0]}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1),
                                  ),
                                ),
                                buildIconButton(
                                    Icons.add, 0, products, count, 45.0, 30.0),
                              ],
                            ),
                            CustomButton(
                                width: MediaQuery.of(context).size.width * 0.65,
                                height: 45,
                                title: "ADD \u20B9308",
                                btncolor: cnst.appPrimaryMaterialColor,
                                ontap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Home()))),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

// CheckboxListTile buildCheckBox(String title, price,_check){
//   return CheckboxListTile(
//       title: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(title),
//           Text("\u20B9${price}"),
//         ],
//       ),
//       value: _check,
//       onChanged: (val){
//         setState(() {
//           _check = val;
//         });
//       }
//   );
// }
}