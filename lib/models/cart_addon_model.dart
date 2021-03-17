class CartAddOn {
  String id, addonGroupId, addonItemId, addonItemName, price, active, attributes;

  CartAddOn(
      {this.id,
        this.addonGroupId,
        this.addonItemId,
        this.addonItemName,
        this.price,
        this.active,
        this.attributes});

  CartAddOn.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    addonGroupId = json['addon_group_id'].toString();
    addonItemId = json['addon_item_id'].toString();
    addonItemName = json['addon_item_name'].toString();
    price = json['price'].toString();
    active = json['active'].toString();
    attributes = json['attributes'].toString();
  }

}
