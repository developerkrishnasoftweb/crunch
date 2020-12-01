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
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          child: Column(
            children: [
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
              padding: const EdgeInsets.only(left: 16.0),
              child: Container(
                width: MediaQuery.of(context).size.width / 2.5,
                child: buildProductCard(
                  index,
                    context,
                    products[index].image,
                    products[index].productName,
                    products[index].productType,
                    products[index].price),
              ),
            );
          }),
    );
  }

  Widget buildProductCard(
      index, BuildContext context, String image, String name, String type, String price,
      {bool favourites = false}) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => ProductInfo()));
      },
      child: Container(
        color: Colors.red,
        margin: EdgeInsets.all(5.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              image,
              width: MediaQuery.of(context).size.width / 3.0,
              height: MediaQuery.of(context).size.width / 3.5,
              fit: BoxFit.fill,
            ),
            SizedBox(width: 10.0,),
            Container(
              width: MediaQuery.of(context).size.width / 2.0,
              height: MediaQuery.of(context).size.width / 3.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.radio_button_checked_outlined),
                            SizedBox(width: 5.0,),
                            Text(name, style: TextStyle(fontWeight: FontWeight.w500)),
                          ],
                        ),
                        Container(
                          child: Text(type, style: TextStyle(color: Colors.grey[500], fontSize: 10)),
                        )
                      ],
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(price,
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            buildIconButton(Icons.remove, index, products, count),
                            Container(
                              width: 30,
                              height: 30,
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
                              width: 40,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 1.5, bottom: 1.5, left: 4, right: 3),
      //width: 30,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            "4.2",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.button.copyWith(fontSize: 10),
          ),
          SizedBox(
            width: 1,
          ),
          Icon(
            Icons.star,
            size: 10,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ],
      ),
    );
  }
  
  Container buildIconButton(IconData icon, int index, items, count) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
          border: Border.all(color: cnst.AppColors.greencolor, width: 2)),
      child: Center(
        child: GestureDetector(
          onTap: (){
            setState(() {
              if (icon == Icons.remove) {
                if (count[index] > 0) count[index]--;
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