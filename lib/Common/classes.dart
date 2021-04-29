import 'package:crunch/models/cart_addon_model.dart';

class ItemData {
  final String name,
      description,
      id,
      itemCategoryId,
      itemOrderType,
      itemAllowAddOn,
      inStock,
      price,
      image,
      itemAttributeId;
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
      this.itemAttributeId,
      this.variation});
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

class CartData {
  String cartId,
      itemId,
      itemName,
      itemPrice,
      combinedPrice,
      qty,
      variationId,
      variationName,
      total;
  List<CartAddOn> cartAddOns;

  CartData(
      {this.cartId,
      this.combinedPrice,
      this.itemId,
      this.itemName,
      this.qty,
      this.itemPrice,
      this.cartAddOns,
      this.variationId,
      this.variationName,
      this.total});
}
