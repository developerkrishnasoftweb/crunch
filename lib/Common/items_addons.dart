import 'package:crunch/APIS/tables.dart';
import 'package:crunch/Screens/cart.dart';
import 'package:crunch/Static/Constant.dart';
import 'package:crunch/Static/global.dart';
import 'package:crunch/models/add_on_group_model.dart';
import 'package:flutter/material.dart';

import 'classes.dart';

showItemAddons(
    {ItemData itemData,
    BuildContext context,
    AnimationController animationController,
    StateSetter state}) async {
  List<AddOnGroup> addonWithGroups = [];
  double price = double.parse(itemData.price);
  for (int i = 0; i < itemData.addon.length; i++) {
    var addOns = await SQFLiteTables.where(
        table: Tables.ADD_ON_GROUPS,
        column: "addongroupid",
        value: itemData.addon[i]['addon_group_id']);
    for (int j = 0; j < addOns.length; j++) {
      state(() {
        addonWithGroups.add(AddOnGroup.fromJson(addOns[j])
          ..addOnMinItemSelection =
              itemData.addon[i]['addon_item_selection_min'].toString()
          ..addOnMaxItemSelection =
              itemData.addon[i]['addon_item_selection_max'].toString());
      });
    }
  }
  showModalBottomSheet(
      context: context,
      builder: (_) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter state) {
          return BottomSheet(
              onClosing: () {},
              animationController: animationController,
              builder: (BuildContext context) {
                return Container(
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "ADD ONS",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 20),
                              )),
                        ),
                        Divider(
                          height: 3,
                          color: Colors.black,
                        ),
                        Expanded(
                          child: ListView.builder(
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
                                          toggleable: true,
                                          onChanged: (AddOnGroupItems value) {
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
                                  double combinedTotal = 0;
                                  for (int i = 0;
                                      i < addonWithGroups.length;
                                      i++) {
                                    for (int j = 0;
                                        j <
                                            addonWithGroups[i]
                                                .addOnGroupItems
                                                .length;
                                        j++) {
                                      if (addonWithGroups[i]
                                          .addOnGroupItems[j]
                                          .selected) {
                                        state(() {
                                          combinedTotal += double.parse(
                                              addonWithGroups[i]
                                                  .addOnGroupItems[j]
                                                  .addOnItemPrice);
                                        });
                                      }
                                    }
                                  }
                                  var id = await SQFLiteTables.addToCart(
                                      itemData: itemData);
                                  for (int i = 0;
                                      i < addonWithGroups.length;
                                      i++) {
                                    for (int j = 0;
                                        j <
                                            addonWithGroups[i]
                                                .addOnGroupItems
                                                .length;
                                        j++) {
                                      if (addonWithGroups[i]
                                          .addOnGroupItems[j]
                                          .selected) {
                                        await db.insert(
                                            SQFLiteTables.tableCartAddon, {
                                          "cart_id": "$id",
                                          "addon_id": addonWithGroups[i]
                                              .addOnGroupItems[j]
                                              .addOnItemId
                                        });
                                      }
                                    }
                                  }
                                  if (id != 0) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context)
                                        .removeCurrentSnackBar();
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
                    ));
              });
        });
      });
}
