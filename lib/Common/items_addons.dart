import 'dart:convert';

import 'package:crunch/APIS/tables.dart';
import 'package:crunch/Screens/cart.dart';
import 'package:crunch/Screens/new_home.dart';
import 'package:crunch/Static/Constant.dart';
import 'package:crunch/Static/global.dart';
import 'package:flutter/material.dart';

import 'classes.dart';

showItemAddons({ItemData itemData, BuildContext context, AnimationController animationController}) async {
  List<AddonWithGroup> addonWithGroups = [];
  String addOnIds = "";
  double price = double.parse(itemData.price);
  for (int i = 0; i < itemData.addon.length; i++) {
    (i == (itemData.addon.length - 1))
        ? addOnIds += itemData.addon[i]["addon_group_id"] + ""
        : addOnIds += itemData.addon[i]["addon_group_id"] + ", ";
  }
  var addOns = await SQFLiteTables.where(
      table: Tables.ADD_ON_GROUPS, column: "addongroupid", value: addOnIds);
  for (int i = 0; i < addOns.length; i++) {
    var addOnsList = jsonDecode(addOns[i]["addongroupitems"]);
    List<AddOnGroup> tempAddOnGroup = [];
    for (int j = 0; j < addOnsList.length; j++) {
      tempAddOnGroup.add(AddOnGroup(
          active: addOnsList[j]["active"],
          addOnItemId: addOnsList[j]["addonitemid"],
          addOnItemPrice: addOnsList[j]["addonitem_price"],
          addOnName: addOnsList[j]["addonitem_name"],
          attributes: addOnsList[j]["attributes"],
          selected: false));
    }
    for (int k = 0; k < itemData.addon.length; k++) {
      if (itemData.addon[k]['addon_group_id'] == addOns[i]['addongroupid']) {
        addonWithGroups.add(AddonWithGroup(
            addOnGroups: tempAddOnGroup,
            addOnGroupName: addOns[i]['addongroupname'],
            addOnGroupId: addOns[i]['addongroupid'],
            addOnMaxItemSelection:
            itemData.addon[k]['addon_item_selection_max'].toString(),
            addOnMinItemSelection:
            itemData.addon[k]['addon_item_selection_min'].toString()));
      }
    }
  }
  showModalBottomSheet(
      context: context,
      builder: (_) {
        return StatefulBuilder(
            builder: (BuildContext
            context,
                StateSetter
                state) {
              return BottomSheet(
                  onClosing:
                      () {},
                  animationController:
                  animationController,
                  builder:
                      (BuildContext
                  context) {
                    return Container(
                        color: Colors
                            .white,
                        alignment:
                        Alignment
                            .center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "ADD ONS",
                                    style: TextStyle(color: Colors.grey, fontSize: 20),
                                  )),
                            ),
                            itemData.variation.length > 0 ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              child: Text("Variations",
                                  style: TextStyle(fontSize: 17, color: primaryColor)),
                            ) : SizedBox(),
                            itemData.variation.length > 0 ? Container(
                              height: 60,
                              child: ListView.builder(
                                  itemBuilder: (_, index) {
                                    return Container(
                                      child: Text("Hello", style: TextStyle(color: Colors.black)),
                                      margin: EdgeInsets.only(right: 10, left: index == 0 ? 10 : 0),
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: Colors.grey)
                                      ),
                                    );
                                  },
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: 10),
                            ) : SizedBox(),
                            Divider(),
                            Expanded(
                              child: ListView.builder(
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(children: [
                                    Container(
                                      child: Text(addonWithGroups[index].addOnGroupName,
                                          style: TextStyle(fontSize: 17, color: primaryColor)),
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                    ),
                                    Divider(
                                      indent: 20,
                                      endIndent: 20,
                                      height: 0,
                                      thickness: 1,
                                    ),
                                    for (int i = 0; i < addonWithGroups[index].addOnGroups.length; i++)
                                      addonWithGroups[index].addOnMaxItemSelection != "1"
                                          ? CheckboxListTile(
                                          value: addonWithGroups[index].addOnGroups[i].selected,
                                          onChanged: (value) {
                                            if (addonWithGroups[index].addOnGroups[i].selected) {
                                              state(() {
                                                addonWithGroups[index].addOnGroups[i].selected =
                                                false;
                                                price = price -
                                                    double.parse(addonWithGroups[index]
                                                        .addOnGroups[i]
                                                        .addOnItemPrice);
                                              });
                                            } else {
                                              state(() {
                                                addonWithGroups[index].addOnGroups[i].selected =
                                                true;
                                                price = price +
                                                    double.parse(addonWithGroups[index]
                                                        .addOnGroups[i]
                                                        .addOnItemPrice);
                                              });
                                            }
                                          },
                                          subtitle: Text("\u20b9" +
                                              addonWithGroups[index].addOnGroups[i].addOnItemPrice),
                                          title:
                                          Text(addonWithGroups[index].addOnGroups[i].addOnName))
                                          : RadioListTile<AddOnGroup>(
                                          value: addonWithGroups[index].addOnGroups[i],
                                          groupValue: addonWithGroups[index].addOnGroup,
                                          controlAffinity: ListTileControlAffinity.trailing,
                                          title:
                                          Text(addonWithGroups[index].addOnGroups[i].addOnName),
                                          subtitle: Text("\u20b9" +
                                              addonWithGroups[index].addOnGroups[i].addOnItemPrice),
                                          onChanged: (value) {
                                            addonWithGroups[index].addOnGroups.forEach((element) {
                                              if (element.selected) {
                                                state(() {
                                                  price = price -
                                                      double.parse(addonWithGroups[index]
                                                          .addOnGroups[i]
                                                          .addOnItemPrice);
                                                  element.selected = false;
                                                });
                                              }
                                            });
                                            AddOnGroup selectedAddon = addonWithGroups[index]
                                                .addOnGroups
                                                .where((element) => element == value)
                                                .first;
                                            state(() {
                                              addonWithGroups[index].addOnGroup = selectedAddon;
                                              selectedAddon.selected = true;
                                              price = price +
                                                  double.parse(selectedAddon.addOnItemPrice);
                                            });
                                          })
                                  ]);
                                },
                                physics: BouncingScrollPhysics(),
                                itemCount: addonWithGroups.length,
                              ),
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
                                        "Total payable : \u20b9${price.toStringAsFixed(2)}",
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
                                      double combinedTotal = 0;
                                      for (int i = 0; i < addonWithGroups.length; i++) {
                                        for (int j = 0; j < addonWithGroups[i].addOnGroups.length; j++) {
                                          if (addonWithGroups[i].addOnGroups[j].selected) {
                                            state(() {
                                              combinedTotal +=
                                                  double.parse(addonWithGroups[i].addOnGroups[j].addOnItemPrice);
                                            });
                                          }
                                        }
                                      }
                                      var id = await db.insert(SQFLiteTables.tableCart, {
                                        "item_id": "${itemData.id}",
                                        "item_name": "${itemData.name}",
                                        "item_price": "${itemData.price}",
                                        "combined_price": "$combinedTotal",
                                        "qty": "1"
                                      });
                                      for (int i = 0; i < addonWithGroups.length; i++) {
                                        for (int j = 0; j < addonWithGroups[i].addOnGroups.length; j++) {
                                          if (addonWithGroups[i].addOnGroups[j].selected) {
                                            await db.insert(SQFLiteTables.tableCartAddon, {
                                              "cart_id": "$id",
                                              "addon_id": addonWithGroups[i].addOnGroups[j].addOnItemId
                                            });
                                          }
                                        }
                                      }
                                      if (itemData.addon.length > 0) Navigator.pop(context);
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
                                    },
                                    color: Colors.green,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ));
                  });
            });
      });
}

addToCart({@required ItemData itemData}) async {
  await db.insert(SQFLiteTables.tableCart, {
    "item_id": "${itemData.id}",
    "item_name": "${itemData.name}",
    "item_price": "${itemData.price}",
    "combined_price": "${itemData.price}",
    "qty": "1"
  });
}

Widget addToCartButton({@required VoidCallback onPressed}) {
  return SizedBox(
      width: 73,
      height: 33,
      child: FlatButton(
        child: Text(
          "ADD",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
        ),
        onPressed: onPressed,
        color: Colors.green[500],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ));
}

updateCart({ItemData itemData}) async {
  await db.rawQuery(
      "update ${SQFLiteTables.tableCart} set qty = ${itemData.quantity} where item_id = ${itemData.id}");
}
