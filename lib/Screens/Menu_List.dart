import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../Color/Constant.dart' as cnst;

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
          title: Text("T",style: TextStyle(color: Colors.black),),
          subtitle: Text("T",style: TextStyle(color: Colors.black),),
        ),
        centerTitle: true,
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
      )
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

  Container buildList(List<Product> products,BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height *0.5,
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
                      borderRadius: BorderRadius.circular(1),
                      child: Image.asset(
                        "assets/images/spalsh.png",
                        height: 100,
                        width: 130,
                        fit: BoxFit.fill,
                      )),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.check_box_outlined,size: 20,),
                            SizedBox(width: 5.0,),
                            Text(
                              "items[index].name",
                              style: Theme.of(context).textTheme.title,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "items[index].category",
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("\$122",
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
                                    width: 75,
                                    height: 25,
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
                                buildIconButton(Icons.remove, index, products, count),
                                Container(
                                  width: 25,
                                  height: 25,
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
                                buildIconButton(Icons.add, index, products, count),
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
    );
  }

  Container buildIconButton(IconData icon, int index, items, count) {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
          border: Border.all(color: cnst.AppColors.greencolor, width: 2)),
      child: Center(
        child: GestureDetector(
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
          child: Icon(icon,size: 16.0,color: cnst.AppColors.blackcolor,),
        )
      ),
    );
  }
}