import 'dart:convert';

class AddOnGroup {
  String addOnGroupId,
      addOnGroupRank,
      active,
      addOnGroupName,
      addOnMaxItemSelection,
      addOnMinItemSelection;
  List<AddOnGroupItems> addOnGroupItems;

  AddOnGroup(
      this.addOnGroupId,
      this.addOnGroupRank,
      this.active,
      this.addOnGroupName,
      this.addOnGroupItems,
      this.addOnMaxItemSelection,
      this.addOnMinItemSelection);

  AddOnGroup.fromJson(Map<String, dynamic> json) {
    addOnGroupId = json['addongroupid'].toString();
    addOnGroupRank = json['addongroup_rank'].toString();
    active = json['active'].toString();
    if (json['addongroupitems'] != null) {
      addOnGroupItems = new List<AddOnGroupItems>();
      jsonDecode(json['addongroupitems']).forEach((v) {
        addOnGroupItems.add(new AddOnGroupItems.fromJson(v)..selected = false);
      });
    }
    addOnGroupName = json['addongroupname'].toString();
  }
}

class AddOnGroupItems {
  String addOnItemId,
      addOnItemName,
      addOnItemPrice,
      active,
      attributes,
      addOnItemRank;
  bool selected;

  AddOnGroupItems(
      {this.addOnItemId,
      this.addOnItemName,
      this.addOnItemPrice,
      this.active,
      this.attributes,
      this.addOnItemRank,
      this.selected});

  AddOnGroupItems.fromJson(Map<String, dynamic> json) {
    addOnItemId = json['addonitemid'].toString();
    addOnItemName = json['addonitem_name'].toString();
    addOnItemPrice = json['addonitem_price'].toString();
    active = json['active'].toString();
    attributes = json['attributes'].toString();
    addOnItemRank = json['addonitem_rank'].toString();
  }
}
