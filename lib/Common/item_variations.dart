import 'package:crunch/APIS/tables.dart';
import 'package:crunch/Common/classes.dart';
import 'package:crunch/Screens/cart.dart';
import 'package:crunch/Static/Constant.dart';
import 'package:crunch/models/variation_model.dart';
import 'package:flutter/material.dart';

itemVariation({BuildContext context, ItemData itemData}) async {
  List<Variation> variation = [];
  itemData.variation.forEach((element) {
    variation.add(Variation.fromJson(element));
  });
  int selectedIndex = 0;
  Variation selectedVariation = variation[selectedIndex];
  return showModalBottomSheet(
      context: context,
      isDismissible: true,
      builder: (_) => StatefulBuilder(builder: (_, state) {
            return BottomSheet(
              onClosing: () {},
              builder: (_) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: Text("Variations",
                          style: TextStyle(fontSize: 17, color: primaryColor)),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      child: ListView.separated(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          separatorBuilder: (_, index) {
                            return SizedBox(
                                width: index == variation.length ? 0 : 10);
                          },
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (_, index) {
                            return TextButton(
                              onPressed: () {
                                state(() {
                                  selectedVariation = variation[index];
                                  selectedIndex = index;
                                });
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateColor.resolveWith((states) =>
                                          index == selectedIndex
                                              ? primaryColor
                                              : primaryColor[200]),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.symmetric(horizontal: 20))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(variation[index].name,
                                      style: TextStyle(
                                          color: index == selectedIndex
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                  Text("\u20b9" + variation[index].price,
                                      style: TextStyle(
                                          color: index == selectedIndex
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis)
                                ],
                              ),
                            );
                          },
                          itemCount: variation.length),
                    ),
                    Spacer(),
                    Divider(
                      height: 2,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            "Total payable : \u20b9${selectedVariation.price}",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          )),
                          FlatButton(
                            child: Text(
                              "ADD TO CART",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () async {
                              if (await SQFLiteTables.addToCart(
                                      variation: selectedVariation) !=
                                  null) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                    "Added to cart",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: primaryColor,
                                  action: SnackBarAction(
                                    label: "GO TO CART",
                                    textColor: Colors.white,
                                    onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => Cart())),
                                  ),
                                ));
                              }
                            },
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          }));
}
