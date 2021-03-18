class Variation {
  String id, variationid, name, groupname, price, active, itemPackingcharges, variationrank, itemId, variationallowaddon;
  List<Addon> addon;

  Variation(
      {this.id,
        this.variationid,
        this.name,
        this.groupname,
        this.price,
        this.active,
        this.itemPackingcharges,
        this.variationrank,
        this.addon,
        this.variationallowaddon, this.itemId});

  Variation.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    variationid = json['variationid'].toString();
    name = json['name'].toString();
    groupname = json['groupname'].toString();
    price = json['price'].toString();
    active = json['active'].toString();
    itemPackingcharges = json['item_packingcharges'].toString();
    variationrank = json['variationrank'].toString();
    if (json['addon'] != null) {
      addon = new List<Addon>();
      json['addon'].forEach((v) {
        addon.add(new Addon.fromJson(v));
      });
    }
    variationallowaddon = json['variationallowaddon'].toString();
  }
}

class Addon {
  String addonGroupId;
  String addonItemSelectionMin;
  String addonItemSelectionMax;

  Addon(
      {this.addonGroupId,
        this.addonItemSelectionMin,
        this.addonItemSelectionMax});

  Addon.fromJson(Map<String, dynamic> json) {
    addonGroupId = json['addon_group_id'].toString();
    addonItemSelectionMin = json['addon_item_selection_min'].toString();
    addonItemSelectionMax = json['addon_item_selection_max'].toString();
  }
}
