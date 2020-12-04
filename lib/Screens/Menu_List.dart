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
  bool cheackvalue = false;
  final List<String> categories = [
    "vegetables",
    "bakery",
    "foodgrain",
  ];
  final List<Product> products = [
    Product("assets/images/spalsh.png", "locale.freshRedOnios",
        "Pajeroma", "\$30.0"),
    Product("assets/images/CrunchTM.png", "locale.freshRedTomatoes",
        "Lecoil Eeva", "\$44.0"),
    Product("assets/images/spalsh.png", "locale.mediumPotatoes",
        "Pajeroma", "\$29.0"),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_sharp,color: Colors.black,)),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: ListTile(
          title: Text("Truck 21 | UK10Aj1075",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
          subtitle: Text("Adarsh Balniketan, Century Gate, 12-C, Roorkee ",style: TextStyle(color: Colors.black,fontSize: 12.0),),
        ),
      ),
      body:SingleChildScrollView(
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
      bottomNavigationBar: AppBottomBar(currentindex: 1,),
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
        buildList(category,context),
      ],
    );
  }

  GestureDetector buildList(List<Product> products,BuildContext context) {
    return GestureDetector(
      onTap: (){
        _settingModalBottomSheet(context);
      },
      child: Container(
        height: MediaQuery.of(context).size.height *0.55,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0,),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ClipRRect(
                      clipBehavior: Clip.hardEdge,
                        borderRadius: BorderRadius.circular(3),
                        child: Image.asset(
                          "assets/images/spalsh.png",
                          height: 115,
                          width: 130,
                          fit: BoxFit.cover,
                        )),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.71,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.check_box_outlined,size: 20,),
                              SizedBox(width: 5.0,),
                              Text(
                                "Special Masala Dosa",
                                style: Theme.of(context).textTheme.title,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Dosa spreaded with melted butter and spiced potato",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("\u20B9122",
                                  textAlign: TextAlign.right,
                                  style: Theme.of(context).textTheme.title),
                              addproduct == false
                              ?GestureDetector(
                                onTap: () {
                                  setState(() {
                                    addproduct = !addproduct;
                                  });
                                },
                                child:Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 81,
                                      height: 27,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3.0),
                                        color: cnst.AppColors.greencolor,
                                      ),
                                      child: Center(
                                        child: Text("ADD",
                                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17.0,color: cnst.AppColors.whitecolor)),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                ),
                              )
                              :Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  buildIconButton(Icons.remove, index, products, count,27.0,27.0),
                                  Container(
                                    width: 27,
                                    height: 27,
                                    decoration: BoxDecoration(
                                      color: cnst.AppColors.greencolor,
                                    ),
                                    child: Center(
                                      child: Text('${count[index]}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1),
                                    ),
                                  ),
                                  buildIconButton(Icons.add, index, products, count,27.0,27.0),
                                  SizedBox(
                                    width: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  GestureDetector buildIconButton(IconData icon, int index, items, count,double height,width) {
    return GestureDetector(
      onTap: (){
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
          child: Icon(icon,size: 16.0,color: cnst.AppColors.blackcolor,)
        ),
      ),
    );
  }

  CheckboxListTile buildCheckBox(){
    return CheckboxListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Mexican Mayo Dip"),
            Text("\u20B949"),
          ],
        ),
        value: cheackvalue,
        onChanged: (val){
          setState(() {
            cheackvalue = val;
          });
        }
    );
  }

  _settingModalBottomSheet(context){
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc){
          return Container(
            margin: EdgeInsets.only(bottom: 10),
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    title: new Text("Crunch Fish Shots W Dip"),
                    subtitle: Text("Served with regular size dip"),
                    trailing: Icon(Icons.cancel_outlined),
                    onTap: () => {}
                ),
                Divider(thickness: 1,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                  child: Column(
                    children: [
                      ListTile(
                          title: new Text("Extra Dip"),
                          subtitle: Text("You can Choose up to 9 options"),
                          onTap: () => {}
                      ),
                      buildCheckBox(),
                      ListTile(
                          title: new Text("Desert"),
                          subtitle: Text("Please select any on option"),
                          onTap: () => {}
                      ),
                      buildCheckBox(),
                      ListTile(
                          title: new Text("Sprinklers"),
                          subtitle: Text("Please select any on option"),
                          onTap: () => {}
                      ),
                      buildCheckBox(),
                      Container(
                        margin: EdgeInsets.only(top: 10,bottom: 10.0),
                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                buildIconButton(Icons.remove, 0, products, count,45.0,30.0),
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
                                buildIconButton(Icons.add, 0, products, count,45.0,30.0),
                              ],
                            ),
                            CustomButton(
                              width: MediaQuery.of(context).size.width * 0.65,height:45,
                                title: "ADD \u20B9308", btncolor: cnst.appPrimaryMaterialColor,
                                ontap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>Home()))
                            ),
                            // Container(
                            //   width: 81,
                            //   height: 27,
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(3.0),
                            //     color: cnst.AppColors.greencolor,
                            //   ),
                            //   child: Center(
                            //     child: Text("ADD \u20B9308",
                            //         style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0,color: cnst.AppColors.whitecolor)),
                            //   ),
                            // ),

                          ],
                        ),
                      )
                    ],
                  ),

                ),
              ],
            ),
          );
        }
    );
  }
}