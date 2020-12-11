import 'dart:convert';

import 'package:crunch/Screens/Address.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'Class.dart';
import 'ClassList.dart';
import 'Constants.dart';

Dio dio = new Dio();

class AppServices{


  static Future<DataClass> getCategories(body) async {
    String url = API_BASE_URL;
        try{
          final http.Response response = await http.post(url, body: jsonEncode(body),);
          if (response.statusCode == 200) {
            final jsonResponse = json.decode(response.body);
            DataClass dataClass = new DataClass(message: 'No Data', data: "1");
            dataClass.message = jsonResponse['message'];
            dataClass.data = jsonResponse['success'].toString();
            dataClass.Categories = jsonResponse['categories'];
            dataClass.Restaurant = jsonResponse['restaurants'];
            dataClass.Items = jsonResponse['items'];
            print("workiing "+dataClass.Restaurant.toString());
            return dataClass;
          } else {
            throw Exception('Failed to load');
          }
        }catch(e){
          print("Categories Error : " + e.toString());
          throw Exception("Something went wrong");
        }
  }

  static Future<SaveDataClass> getSlider(body) async {
    print("body: ${body.toString()}");
    String url = Base_URL+"sliders";
    print("Slider  URL: " + url);
    dio.options.contentType = Headers.jsonContentType;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
        new SaveDataClass(message: 'No Data', value: "n");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.value = jsonResponse['status'].toString();
        saveDataClass.data = jsonResponse['banners'];
        print("Seller Registration Responce: ${jsonResponse}");
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Seller Registration Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> CustomerLogin(body) async {
    String url = Base_URL + 'login';
    print("Login URL: ${url}");
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
        new SaveDataClass(message: 'No Data', value: "n");
        final jsonResponse = json.decode(response.data);
        print("Customer Login Responce: ${jsonResponse}");
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
      print("Customer Login Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> CustomerSignUp(body) async {
    String url = Base_URL + 'register';
    print("Register URL: ${url}");
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
        new SaveDataClass(message: 'No Data', value: "n");
        final jsonResponse = json.decode(response.data);
        print("Customer SignUp Responce: ${jsonResponse}");
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
      print("Customer Login Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> getAddress(body) async {
    print("body: ${body.toString()}");
    String url = Base_URL+"customer_address";
    print("address  URL: " + url);
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
        print("Customer Address Responce: ${jsonResponse}");
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> AddAddress (body) async {
    print("body: ${body.toString()}");
    String url = Base_URL+"add_address";
    print("address Add  URL: " + url);
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
        print("Customer Address Responce: ${jsonResponse}");
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<SaveDataClass> deleteAddress (body) async {
    print("body: ${body.toString()}");
    String url = Base_URL+"delete_address";
    print("address delete  URL: " + url);
    dio.options.contentType = Headers.jsonContentType;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveDataClass =
        new SaveDataClass(message: 'No Data', value: "n");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.value = jsonResponse['status'].toString();
        print("Customer Address Responce: ${jsonResponse}");
        return saveDataClass;
      } else {
        throw Exception("Something went Wrong");
      }
    } catch (e) {
      print("Error : " + e.toString());
      throw Exception("Something went wrong");
    }
  }



}