class DataClass {
  String message;
  String data;
  List Restaurant;
  List Categories;
  List parentcategories;
  List Items;
  List addongroups;

  DataClass({this.message, this.data, this.Restaurant,this.Categories,this.Items,});

  factory DataClass.fromJson(Map<String, dynamic> json) {
    return DataClass(
        message: json['message'] as String,
        data: json['data'] as String,
        Restaurant: json['Restaurant'] as List,
        Categories: json['Categories'] as List,
        Items: json['Items'] as List
    );
  }
}
