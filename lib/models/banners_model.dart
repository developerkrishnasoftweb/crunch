class Banners {
  final String id,
      title,
      image,
      status,
      inserted,
      insertedBy,
      modified,
      modifiedBy;

  Banners(
      {this.id,
      this.title,
      this.image,
      this.status,
      this.inserted,
      this.insertedBy,
      this.modified,
      this.modifiedBy});

  Banners.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        image = json['image'],
        status = json['status'],
        inserted = json['inserted'],
        insertedBy = json['inserted_by'],
        modified = json['modified'],
        modifiedBy = json['modified_by'];
}
