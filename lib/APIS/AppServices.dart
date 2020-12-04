import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'ClassList.dart';
import 'Constants.dart';

Dio dio = new Dio();

class AppServices{

  static Future<DataClass> SellerSignUp(body) async {
    print("body: ${body.toString()}");
    String url = API_URL + 'Registration/selleraddAPI';
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