import 'dart:convert';

import 'package:crunch/models/menu_model.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import 'Class.dart';
import 'tables.dart';

Dio dio = new Dio();

class AppServices {

  static Future<SaveDataClass> getSlider() async {
    String url = Base_URL + "sliders";
    dio.options.contentType = Headers.jsonContentType;
    try {
      final response = await dio.post(url,
          data: FormData.fromMap({"api_key": "0imfnc8mVLWwsAawjYr4Rx"}));
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass = new SaveDataClass();
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = "Data fetched successfully";
        saveDataClass.value = jsonResponse["status"];
        saveDataClass.data = [jsonResponse["data"]];
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      // print("Seller Registration Error : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<SaveDataClass> CustomerLogin(body) async {
    String url = Base_URL + 'login';
    // print("Login URL: ${url}");
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', value: "n");
        final jsonResponse = json.decode(response.data);
        // print("Customer Login Responce: ${jsonResponse}");
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.value = jsonResponse['status'].toString();
        List list = [];
        if (jsonResponse["status"].toString() == "y") {
          list = [
            {
              "id": jsonResponse['customer']["id"],
              "name": jsonResponse['customer']["name"],
              "mobile": jsonResponse['customer']["mobile"],
              "email": jsonResponse['customer']["email"],
              "image": jsonResponse['customer']["image"],
              "gender": jsonResponse['customer']["gender"],
              "password": jsonResponse['customer']["password"],
              "status": jsonResponse['customer']["status"],
            }
          ];
        }
        saveDataClass.data = list;
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      // print("Customer Login Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> CustomerSignUp(body) async {
    String url = Base_URL + 'register';
    // print("Register URL: ${url}");
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', value: "n");
        final jsonResponse = json.decode(response.data);
        // print("Customer SignUp Responce: ${jsonResponse}");
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.value = jsonResponse['status'].toString();
        List list = [];
        if (jsonResponse["status"].toString() == "y") {
          list = [
            {
              "id": jsonResponse['customer']["id"],
              "name": jsonResponse['customer']["name"],
              "mobile": jsonResponse['customer']["mobile"],
              "email": jsonResponse['customer']["email"],
              "image": jsonResponse['customer']["image"],
              "gender": jsonResponse['customer']["gender"],
              "password": jsonResponse['customer']["password"],
              "status": jsonResponse['customer']["status"],
            }
          ];
        }
        saveDataClass.data = list;
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      // print("Customer Login Error : " + e.toString());
      throw Exception(e.toString());
    }
  }

  static Future<SaveDataClass> getAddress(body) async {
    // print("body: ${body.toString()}");
    String url = Base_URL + "customer_address";
    // print("address  URL: " + url);
    dio.options.contentType = Headers.jsonContentType;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', value: "n");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.value = jsonResponse['status'].toString();
        saveDataClass.data = jsonResponse['address'];
        // print("Customer Address Responce: ${jsonResponse}");
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      // print("Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> AddAddress(body) async {
    // print("body: ${body.toString()}");
    String url = Base_URL + "add_address";
    // print("address Add  URL: " + url);
    dio.options.contentType = Headers.jsonContentType;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', value: "n");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.value = jsonResponse['status'].toString();
        saveDataClass.data = jsonResponse['address'];
        // print("Customer Address Responce: ${jsonResponse}");
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      // print("Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> deleteAddress(body) async {
    // print("body: ${body.toString()}");
    String url = Base_URL + "delete_address";
    // print("address delete  URL: " + url);
    dio.options.contentType = Headers.jsonContentType;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', value: "n");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.value = jsonResponse['status'].toString();
        // print("Customer Address Responce: ${jsonResponse}");
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      // print("Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> addrate(body) async {
    // print("body: ${body.toString()}");
    String url = Base_URL + "rate_now";
    // print("address delete  URL: " + url);
    dio.options.contentType = Headers.jsonContentType;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', value: "n");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.value = jsonResponse['status'].toString();
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      // print("Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  /*
  * Fetch restaurants menu and data
  * */
  static Future<FetchMenu> fetchMenu() async {
    var headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Cookie': 'CAKEPHP=ikabifbaphe2m3eobl92here51'
    };
    try {
      var request = await http.post(API_BASE_URL,
          headers: headers,
          body: jsonEncode({
            "access_token": "998d2c96566d545b4b4c5c60835b3e7a94ee7775",
            "api_key": "the6pya9ksjmucn4goqdvzx0273r8bf1",
            "api_secret": "85f2c43cefec0072744107ef5321eef7875e40e0",
            "restID": "yp941tsn",
            "last_updated_on": "",
            "data_type": "json"
          }));
      if (request.statusCode == 200) {
        FetchMenu data;
        var fetchedData = jsonDecode(request.body);
        data = FetchMenu.fromJson(fetchedData);
        return data;
      } else {
        // print(response.reasonPhrase);
      }
      return null;
    } catch (e) {
      FetchMenu data = FetchMenu(message: "Something went wrong");
      return data;
    }
  }

  /*
  * Save Order
  * */
  static Future<SaveDataClass> saveOrder(body) async {
    String url = Base_URL + 'save_order';
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', value: "n");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.value = jsonResponse['status'].toString();
        saveDataClass.data = [jsonResponse['data']];
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /*
  * Get orders
  * */
  static Future<SaveDataClass> orders(body) async {
    String url = Base_URL + 'get_orders';
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', value: "n");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.value = jsonResponse['status'];
        saveDataClass.data = [jsonResponse['data']];
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /*
  * Cancel order
  * */
  static Future<SaveDataClass> cancelOrder(body) async {
    String url = Base_URL + 'cancel_order';
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', value: "n");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.value = jsonResponse['status'];
        saveDataClass.data = [jsonResponse['data']];
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /*
  * Get coupons
  * */
  static Future<SaveDataClass> getCoupons() async {
    String url = Base_URL + 'get_all_coupons';
    try {
      final response = await dio.post(url,
          data: FormData.fromMap({"api_key": "0imfnc8mVLWwsAawjYr4Rx"}));
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', value: "n");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.value = jsonResponse['status'];
        saveDataClass.data = jsonResponse['data'];
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /*
  * Get coupons
  * */
  static Future<SaveDataClass> checkCoupon(
      {String couponCode, String amount}) async {
    String url = Base_URL + 'check_coupon';
    try {
      final response = await dio.post(url,
          data: FormData.fromMap({
            "api_key": "0imfnc8mVLWwsAawjYr4Rx",
            "code": couponCode,
            "amount": amount
          }));
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', value: "n");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.value = jsonResponse['status'];
        saveDataClass.data = [jsonResponse['data']];
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /*
  * Track order
  * */
  static Future<SaveDataClass> trackOrder(body) async {
    String url = Base_URL + 'get_order_detail';
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
            new SaveDataClass(message: 'No Data', value: "n");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.value = jsonResponse['status'];
        saveDataClass.data = [jsonResponse['data']];
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
