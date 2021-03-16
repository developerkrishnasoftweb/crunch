import 'package:crunch/Common/classes.dart';
import 'package:crunch/Common/items_addons.dart';
import 'package:crunch/Screens/cart.dart';
import 'package:crunch/Static/Constant.dart';
import 'package:crunch/models/variation_model.dart';
import 'package:flutter/material.dart';

itemVariation({BuildContext context, ItemData itemData}) async {
  List<Variation> variation = [];
  itemData.variation.forEach((element) {
    variation.add(Variation.fromJson(element));
  });
  Variation selectedVariation = variation[0];
  return showModalBottomSheet(
      context: context,
      isDismissible: true,
      builder: (_) => StatefulBuilder(builder: (_, state) {
        return BottomSheet(
          onClosing: () {

          },
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Text("Variations",
                      style: TextStyle(fontSize: 17, color: primaryColor)),
                ),
                Expanded(
                  child: ListView.builder(
                      itemBuilder: (_, index) {
                        return RadioListTile<Variation>(
                            value: variation[index],
                            groupValue: selectedVariation,
                            onChanged: (value) {
                              state(() {
                                selectedVariation = value;
                              });
                            },
                            title: Text(variation[index].name),
                            subtitle: Text("\u20b9" + variation[index].price));
                      },
                      itemCount: variation.length),
                ),
                Divider(
                  height: 1,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                            "Total payable : \u20b9${selectedVariation.price}",
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          )),
                      FlatButton(
                        child: Text(
                          "ADD TO CART",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          if(await addToCart(variation: selectedVariation) != null) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                "Added to cart",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: primaryColor,
                              action: SnackBarAction(
                                label: "GO TO CART",
                                textColor: Colors.white,
                                onPressed: () =>
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => Cart())),
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
