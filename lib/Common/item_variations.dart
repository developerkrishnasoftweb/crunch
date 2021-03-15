import 'package:crunch/Common/classes.dart';
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
            return ListView.builder(
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
                itemCount: variation.length);
          },
        );
      }));
}
