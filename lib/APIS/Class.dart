class SaveDataClass {
  String message;
  String value;
  List data;

  SaveDataClass({
    this.message,
    this.value,
    this.data,
  });
  factory SaveDataClass.fromJson(Map<String, dynamic> json) {
    return SaveDataClass(
        message: json['message'] as String,
        value: json['value'] as String,
        data: json['data'] as List);
  }
}
