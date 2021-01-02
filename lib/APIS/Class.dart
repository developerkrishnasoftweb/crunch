class SaveDataClass {
  String message;
  String value;
  List data;

  SaveDataClass({this.message, this.value, this.data,});
  factory SaveDataClass.fromJson(Map<String, dynamic> json) {
    return SaveDataClass(
        message: json['message'] as String,
        value: json['value'] as String,
        data: json['data'] as List
    );
  }
}

/*
* Fetching menu and Store in class
* */
class FetchMenu {
  String message, response, serverDateTime, dbVersion, appVersion;
  List restaurants, orderTypes, categories, parentCategories, items, variations, addOnGroups, attributes, discounts, taxes;
  FetchMenu({this.response, this.message, this.addOnGroups, this.appVersion, this.attributes, this.categories, this.dbVersion, this.discounts, this.items, this.orderTypes, this.parentCategories, this.restaurants, this.serverDateTime, this.taxes, this.variations});
  factory FetchMenu.fromJson(Map<String, dynamic> json) {
    return FetchMenu(
      addOnGroups: json['addongroups'] as List,
      appVersion: json['application_version'] as String,
      attributes: json['attributes'] as List,
      categories: json['categories'] as List,
      dbVersion: json['db_version'] as String,
      discounts: json['discounts'] as List,
      items: json['items'] as List,
      message: json['message'] as String,
      orderTypes: json['ordertypes'] as List,
      parentCategories: json['parentcategories'] as List,
      response: json['success'] as String,
      restaurants: json['restaurants'] as List,
      serverDateTime: json['serverdatetime'] as String,
      taxes: json['taxes'] as List,
      variations: json['variations'] as List
    );
  }
}