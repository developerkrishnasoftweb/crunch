class ItemData {
  final String name,
      description,
      id,
      itemCategoryId,
      itemOrderType,
      itemAllowAddOn,
      inStock,
      price,
      image;
  bool addedToCart;
  int quantity;
  final List variation, addon;
  ItemData(
      {this.id,
      this.name,
      this.image,
      this.addon,
      this.description,
      this.inStock,
      this.itemAllowAddOn,
      this.itemCategoryId,
      this.itemOrderType,
      this.price,
      this.addedToCart: false,
      this.quantity: 1,
      this.variation});
}

class Banners {
  final String id, title, image;
  Banners({this.image, this.id, this.title});
}

class Category {
  final String id, name, image, active, rank, parentCategoryId, timings;
  Category(
      {this.id,
      this.image,
      this.name,
      this.active,
      this.parentCategoryId,
      this.rank,
      this.timings});
}

class AddOnGroup {
  final String addOnItemId, addOnName, addOnItemPrice, active, attributes;
  bool selected;
  AddOnGroup(
      {this.active,
      this.addOnItemId,
      this.addOnItemPrice,
      this.addOnName,
      this.selected,
      this.attributes});
}
