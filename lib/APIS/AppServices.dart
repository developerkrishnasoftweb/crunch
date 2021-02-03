import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import 'Class.dart';
import 'ClassList.dart';
import 'Constants.dart';

Dio dio = new Dio();

class AppServices {
  static Future<DataClass> getCategories(body) async {
    String url = API_BASE_URL;
    try {
      final http.Response response = await http.post(
        url,
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        DataClass dataClass = new DataClass(message: 'No Data', data: "1");
        dataClass.message = jsonResponse['message'];
        dataClass.data = jsonResponse['success'].toString();
        dataClass.Categories = jsonResponse['categories'];
        dataClass.Restaurant = jsonResponse['restaurants'];
        dataClass.addongroups = jsonResponse['addongroups'];
        dataClass.Items = jsonResponse['items'];
        // print("workiing "+dataClass.Restaurant.toString());
        return dataClass;
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      // print("Categories Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

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
      throw Exception("Something went wrong");
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
    String url =
        "http://52.76.48.26:4524/petpoojabilling_api/V1/pendingorders/mapped_restaurant_menus/";
    var headers = {
      'Content-Type': 'text/plain',
      'Cookie': 'CAKEPHP=ikabifbaphe2m3eobl92here51'
    };
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = '''{
        "access_token": "04fc7877ce7e5f771328b2a1434cb040ad1b2c0f",
        "app_key": "f14qd3se9a6juzbmoit85c0nrvhykgwp",
        "app_secret": "0ecb9930ec89b68dbc923d3ecedc43f37901cf61",
        "restID": "k13cv5ho",
        "last_updated_on": "",
        "data_type": "json"
      }''';
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        FetchMenu data;
        var fetchedData = jsonDecode(await response.stream.bytesToString());
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
}
