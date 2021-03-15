class Userdata {
  final String id,
      name,
      mobile,
      email,
      image,
      gender,
      password,
      status,
      inserted,
      modified,
      token;

  Userdata(
      {this.id,
      this.name,
      this.mobile,
      this.email,
      this.image,
      this.gender,
      this.password,
      this.status,
      this.inserted,
      this.modified,
      this.token});

  Userdata.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        name = json['name'].toString(),
        mobile = json['mobile'].toString(),
        email = json['email'].toString(),
        image = json['image'].toString(),
        gender = json['gender'].toString(),
        password = json['password'].toString(),
        status = json['status'].toString(),
        inserted = json['inserted'].toString(),
        modified = json['modified'].toString(),
        token = json['token'].toString();
}