import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

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

  static Future<DataClass> SellerSignUp(body) async {
    print("body: ${body.toString()}");
    String url = API_BASE_URL + 'Registration/selleraddAPI';
    print("Seller Registration URL: " + url);
    dio.options.contentType = Headers.jsonContentType;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        DataClass saveDataClass =
        new DataClass(message: 'No Data', data: "1");
        final jsonResponse = json.decode(response.data);
        saveDataClass.message = jsonResponse['message'];
        saveDataClass.data = jsonResponse['data'].toString();
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


}