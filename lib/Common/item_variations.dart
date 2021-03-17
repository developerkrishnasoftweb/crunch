import 'package:crunch/APIS/tables.dart';
import 'package:crunch/Common/classes.dart';
import 'package:crunch/Screens/cart.dart';
import 'package:crunch/Static/Constant.dart';
import 'package:crunch/models/add_on_group_model.dart';
import 'package:crunch/models/variation_model.dart';
import 'package:flutter/material.dart';

itemVariation({BuildContext context, ItemData itemData}) async {
  List<Variation> variation = [];
  itemData.variation.forEach((element) {
    variation.add(Variation.fromJson(element));
  });
  int selectedIndex = 0;
  double price = 0;
  Variation selectedVariation = variation[selectedIndex];
  List<AddOnGroup> addonWithGroups = [];
  getAddons({StateSetter state}) async {
    if(state != null) {
      state(() {
        addonWithGroups.clear();
        selectedVariation.addon.forEach((variationAddon) async {
          var addOns = await SQFLiteTables.where(column: 'addongroupid', table: Tables.ADD_ON_GROUPS, value: variationAddon.addonGroupId);
          addOns.forEach((element) {
            addonWithGroups.add(AddOnGroup.fromJson(element)
              ..addOnMinItemSelection = variationAddon.addonItemSelectionMin
              ..addOnMaxItemSelection = variationAddon.addonItemSelectionMax);
          });
        });
        price = double.parse(selectedVariation.price);
      });
    } else {
      addonWithGroups.clear();
      selectedVariation.addon.forEach((variationAddon) async {
        var addOns = await SQFLiteTables.where(column: 'addongroupid', table: Tables.ADD_ON_GROUPS, value: variationAddon.addonGroupId);
        addOns.forEach((element) {
          addonWithGroups.add(AddOnGroup.fromJson(element)
            ..addOnMinItemSelection = variationAddon.addonItemSelectionMin
            ..addOnMaxItemSelection = variationAddon.addonItemSelectionMax);
        });
      });
      price = double.parse(selectedVariation.price);
    }
  }
  getAddons();
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
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          separatorBuilder: (_, index) {
                            return SizedBox(
                                width: index == variation.length ? 0 : 10);
                          },
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (_, index) {
                            return TextButton(
                              onPressed: () async {
                                state(() {
                                  selectedVariation = variation[index];
                                  selectedIndex = index;
                                });
                                await getAddons(state: state);
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
                    Expanded(child: addonWithGroups.length > 0 ? ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return Column(children: [
                          Container(
                            child: Text(
                                addonWithGroups[index].addOnGroupName,
                                style: TextStyle(
                                    fontSize: 17, color: primaryColor)),
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                          ),
                          Divider(
                            indent: 20,
                            endIndent: 20,
                            height: 0,
                            thickness: 1,
                          ),
                          for (int i = 0;
                          i <
                              addonWithGroups[index]
                                  .addOnGroupItems
                                  .length;
                          i++)
                            addonWithGroups[index]
                                .addOnMaxItemSelection !=
                                "1"
                                ? CheckboxListTile(
                                value: addonWithGroups[index]
                                    .addOnGroupItems[i]
                                    .selected,
                                onChanged: (value) {
                                  if (addonWithGroups[index]
                                      .addOnGroupItems[i]
                                      .selected) {
                                    state(() {
                                      addonWithGroups[index]
                                          .addOnGroupItems[i]
                                          .selected = false;
                                      price = price -
                                          double.parse(
                                              addonWithGroups[index]
                                                  .addOnGroupItems[i]
                                                  .addOnItemPrice);
                                    });
                                  } else {
                                    state(() {
                                      addonWithGroups[index]
                                          .addOnGroupItems[i]
                                          .selected = true;
                                      price = price +
                                          double.parse(
                                              addonWithGroups[index]
                                                  .addOnGroupItems[i]
                                                  .addOnItemPrice);
                                    });
                                  }
                                },
                                subtitle: Text("\u20b9" +
                                    addonWithGroups[index]
                                        .addOnGroupItems[i]
                                        .addOnItemPrice),
                                title: Text(addonWithGroups[index]
                                    .addOnGroupItems[i]
                                    .addOnItemName))
                                : RadioListTile<AddOnGroupItems>(
                                value: addonWithGroups[index]
                                    .addOnGroupItems[i],
                                groupValue: addonWithGroups[index]
                                    .addOnGroupItem,
                                controlAffinity:
                                ListTileControlAffinity.trailing,
                                title: Text(addonWithGroups[index]
                                    .addOnGroupItems[i]
                                    .addOnItemName),
                                subtitle: Text("\u20b9" +
                                    addonWithGroups[index]
                                        .addOnGroupItems[i]
                                        .addOnItemPrice),
                                onChanged: (value) {
                                  addonWithGroups[index]
                                      .addOnGroupItems
                                      .forEach((element) {
                                    if (element.selected) {
                                      state(() {
                                        price = price -
                                            double.parse(element
                                                .addOnItemPrice);
                                        element.selected = false;
                                      });
                                    }
                                  });
                                  AddOnGroupItems selectedAddon =
                                      addonWithGroups[index]
                                          .addOnGroupItems
                                          .where((element) =>
                                      element == value)
                                          .first;
                                  state(() {
                                    addonWithGroups[index]
                                        .addOnGroupItem =
                                        selectedAddon;
                                    selectedAddon.selected = true;
                                    price = price +
                                        double.parse(selectedAddon
                                            .addOnItemPrice);
                                  });
                                })
                        ]);
                      },
                      physics: BouncingScrollPhysics(),
                      itemCount: addonWithGroups.length,
                    ) : SizedBox()),
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
                            "Total payable : \u20b9${price}",
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
                              // if (await SQFLiteTables.addToCart(
                              //         variation: selectedVariation) !=
                              //     null) {
                              //   Navigator.pop(context);
                              //   ScaffoldMessenger.of(context)
                              //       .showSnackBar(SnackBar(
                              //     content: Text(
                              //       "Added to cart",
                              //       style: TextStyle(
                              //           color: Colors.white,
                              //           fontWeight: FontWeight.bold),
                              //     ),
                              //     backgroundColor: primaryColor,
                              //     action: SnackBarAction(
                              //       label: "GO TO CART",
                              //       textColor: Colors.white,
                              //       onPressed: () => Navigator.push(
                              //           context,
                              //           MaterialPageRoute(
                              //               builder: (_) => Cart())),
                              //     ),
                              //   ));
                              // }
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
