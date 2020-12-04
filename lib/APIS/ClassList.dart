class DataClass {
  String message;
  String data;
  List value;

  DataClass({this.message, this.data, this.value});

  factory DataClass.fromJson(Map<String, dynamic> json) {
    return DataClass(
        message: json['message'] as String,
        data: json['data'] as String,
        value: json['value'] as List);
  }
}
