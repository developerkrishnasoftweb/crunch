import 'package:crunch/APIS/AppServices.dart';
import 'package:crunch/Static/Constant.dart' as cnst;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  bool isLoading = false;
  List<OrderDetails> orderDetails = [];
  setLoading(bool status) {
    setState(() {
      isLoading = status;
    });
  }

  @override
  void initState() {
    super.initState();
    getOrders();
  }

  getOrders() async {
    orderDetails.clear();
    setLoading(true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String customerId = sharedPreferences.getString(cnst.Session.id);
    FormData formData = FormData.fromMap({
      "api_key": "0imfnc8mVLWwsAawjYr4Rx",
      "customer_id": customerId,
    });
    await AppServices.orders(formData).then((value) {
      if (value.value == "true") {
        for (int i = 0; i < value.data[0]["orders"].length; i++) {
          List<ItemData> itemData = [];
          var details = value.data[0]["orders"][i]["details"];
          for (int j = 0; j < details.length; j++) {
            List<AddonData> addOnData = [];
            var addons = details[j]["addon"];
            for (int k = 0; k < addons.length; k++) {
              setState(() {
                addOnData.add(AddonData(
                    quantity: addons[k]["quantity"],
                    price: addons[k]["price"],
                    name: addons[k]["name"],
                    id: addons[k]["id"],
                    addonId: addons[k]["addon_id"],
                    groupId: addons[k]["group_id"],
                    groupName: addons[k]["group_name"],
                    orderDetailId: addons[k]["order_detail_id"]));
              });
            }
            setState(() {
              itemData.add(ItemData(
                  id: details[j]["id"],
                  description: details[j]["description"],
                  itemId: details[j]["item_id"],
                  name: details[j]["name"],
                  orderId: details[j]["order_id"],
                  price: details[j]["price"],
                  quantity: details[j]["quantity"],
                  variationId: details[j]["variation_id"],
                  addOn: addOnData,
                  variationName: details[j]["variation_name"]));
            });
          }
          setState(() {
            orderDetails.add(OrderDetails(
                id: value.data[0]["orders"][i]["id"],
                addressId: value.data[0]["orders"][i]["address_id"],
                deliveryCharges: value.data[0]["orders"][i]["delivery_charges"],
                discount: value.data[0]["orders"][i]["discount"],
                discountTotal: value.data[0]["orders"][i]["discount_total"],
                discountType: value.data[0]["orders"][i]["discount_type"],
                orderStatus: value.data[0]["orders"][i]["order_status"],
                orderType: value.data[0]["orders"][i]["order_type"],
                packingCharges: value.data[0]["orders"][i]["packing_charges"],
                paymentId: value.data[0]["orders"][i]["payment_id"],
                paymentType: value.data[0]["orders"][i]["payment_type"],
                petpoojaOrderId: value.data[0]["orders"][i]
                    ["petpooja_order_id"],
                taxtotal: value.data[0]["orders"][i]["tax_total"],
                items: itemData,
                total: value.data[0]["orders"][i]["total"]));
          });
        }
        setLoading(false);
      } else {
        setState(() {
          orderDetails = null;
        });
        setLoading(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Your Orders",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: cnst.appPrimaryMaterialColor,
          elevation: 1,
        ),
        body: isLoading
            ? Center(
                child: orderDetails != null
                    ? CircularProgressIndicator()
                    : Text("No orders found"),
              )
            : ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      child: Column(
                    children: [
                      Text("Items"),
                      Text(
                          "${orderDetails[index].items[0].quantity} x ${orderDetails[index].items[0].name}")
                    ],
                  ));
                },
                physics: BouncingScrollPhysics(),
                itemCount: orderDetails.length,
              ));
  }
}

class OrderDetails {
  final String id,
      deliveryCharges,
      packingCharges,
      paymentType,
      discount,
      discountTotal,
      discountType,
      orderType,
      taxtotal,
      total,
      addressId,
      orderStatus,
      petpoojaOrderId,
      paymentId;
  final List<ItemData> items;
  OrderDetails(
      {this.id,
      this.paymentId,
      this.items,
      this.total,
      this.addressId,
      this.deliveryCharges,
      this.discount,
      this.discountTotal,
      this.discountType,
      this.orderStatus,
      this.orderType,
      this.packingCharges,
      this.paymentType,
      this.petpoojaOrderId,
      this.taxtotal});
}

class ItemData {
  final String id,
      itemId,
      orderId,
      name,
      price,
      quantity,
      description,
      variationName,
      variationId;
  final List<AddonData> addOn;
  ItemData(
      {this.id,
      this.description,
      this.name,
      this.itemId,
      this.quantity,
      this.price,
      this.addOn,
      this.orderId,
      this.variationId,
      this.variationName});
}

class AddonData {
  final String id,
      orderDetailId,
      addonId,
      name,
      price,
      groupId,
      quantity,
      groupName;
  AddonData(
      {this.price,
      this.quantity,
      this.name,
      this.id,
      this.addonId,
      this.groupId,
      this.groupName,
      this.orderDetailId});
}
