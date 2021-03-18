class OrderDetails {
  String id,
      advanceOrder,
      preorderDate,
      preorderTime,
      minimumOrderAmount,
      deliveryCharges,
      packingCharges,
      paymentType,
      discount,
      discountTotal,
      description,
      discountType,
      orderType,
      taxTotal,
      total,
      created,
      callbackUrl,
      customerId,
      addressId,
      orderStatus,
      petpoojaOrderId,
      paymentId,
      couponApplied,
      couponAmount,
      driverId,
      pushedStatus,
      cancelReason,
      variationId;
  List<Details> details;

  OrderDetails(
      {this.id,
      this.advanceOrder,
      this.preorderDate,
      this.preorderTime,
      this.minimumOrderAmount,
      this.deliveryCharges,
      this.packingCharges,
      this.paymentType,
      this.discount,
      this.discountTotal,
      this.description,
      this.discountType,
      this.orderType,
      this.taxTotal,
      this.total,
      this.created,
      this.callbackUrl,
      this.customerId,
      this.addressId,
      this.orderStatus,
      this.petpoojaOrderId,
      this.paymentId,
      this.couponApplied,
      this.couponAmount,
      this.driverId,
      this.pushedStatus,
      this.cancelReason,
      this.variationId,
      this.details});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    advanceOrder = json['advance_order'].toString();
    preorderDate = json['preorder_date'].toString();
    preorderTime = json['preorder_time'].toString();
    minimumOrderAmount = json['minimum_order_amount'].toString();
    deliveryCharges = json['delivery_charges'].toString();
    packingCharges = json['packing_charges'].toString();
    paymentType = json['payment_type'].toString();
    discount = json['discount'].toString();
    discountTotal = json['discount_total'].toString();
    description = json['description'].toString();
    discountType = json['discount_type'].toString();
    orderType = json['order_type'].toString();
    taxTotal = json['tax_total'].toString();
    total = json['total'].toString();
    created = json['created'].toString();
    callbackUrl = json['callback_url'].toString();
    customerId = json['customer_id'].toString();
    addressId = json['address_id'].toString();
    orderStatus = json['order_status'].toString();
    petpoojaOrderId = json['petpooja_order_id'].toString();
    paymentId = json['payment_id'].toString();
    couponApplied = json['coupon_applied'].toString();
    couponAmount = json['coupon_amount'].toString();
    driverId = json['driver_id'].toString();
    pushedStatus = json['pushed_status'].toString();
    cancelReason = json['cancel_reason'].toString();
    variationId = json['variation_id'].toString();
    if (json['details'] != null) {
      details = new List<Details>();
      json['details'].forEach((v) {
        details.add(new Details.fromJson(v));
      });
    }
  }
}

class Details {
  String id,
      itemId,
      orderId,
      name,
      price,
      quantity,
      description,
      variationName,
      variationId;
  List<Addon> addon;

  Details(
      {this.id,
      this.itemId,
      this.orderId,
      this.name,
      this.price,
      this.quantity,
      this.description,
      this.variationName,
      this.variationId,
      this.addon});

  Details.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    itemId = json['item_id'].toString();
    orderId = json['order_id'].toString();
    name = json['name'].toString();
    price = json['price'].toString();
    quantity = json['quantity'].toString();
    description = json['description'].toString();
    variationName = json['variation_name'].toString();
    variationId = json['variation_id'].toString();
    if (json['addon'] != null) {
      addon = new List<Addon>();
      json['addon'].forEach((v) {
        addon.add(new Addon.fromJson(v));
      });
    }
  }
}

class Addon {
  String id, orderDetailId, addonId, name, price, groupId, quantity, groupName;

  Addon(
      {this.id,
      this.orderDetailId,
      this.addonId,
      this.name,
      this.price,
      this.groupId,
      this.quantity,
      this.groupName});

  Addon.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    orderDetailId = json['order_detail_id'].toString();
    addonId = json['addon_id'].toString();
    name = json['name'].toString();
    price = json['price'].toString();
    groupId = json['group_id'].toString();
    quantity = json['quantity'].toString();
    groupName = json['group_name'].toString();
  }
}
