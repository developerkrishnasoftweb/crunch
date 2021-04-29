import 'dart:async';
import 'dart:convert';

import 'package:crunch/Screens/dashboard.dart';
import 'package:crunch/Static/global.dart';
import 'package:crunch/models/config_model.dart';
import 'package:crunch/models/userdata_models.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LoginScreen/Login.dart';
import 'Static/Constant.dart' as cnst;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  db = await openMyDataBase();
  sharedPreferences = await SharedPreferences.getInstance();
  await createTables();
  bool credential = await getCredentials();
  runApp(MaterialApp(
    title: 'Crunch',
    theme: ThemeData(
      primarySwatch: cnst.primaryColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: "Poppins",
    ),
    debugShowCheckedModeBanner: false,
    home: credential ? Dashboard() : Login(),
  ));
  position = await determinePosition();
}

Future<bool> getCredentials() async {
  final userData = sharedPreferences.getString('userdata');
  final configData = sharedPreferences.getString('config');
  if (userData != null) {
    userdata = Userdata.fromJson(await jsonDecode(userData));
    if (configData != null) {
      config = Config.fromJson(jsonDecode(configData));
    }
    return true;
  } else {
    return false;
  }
}

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.value(null);
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.value(null);
    }
    if (permission == LocationPermission.denied) {
      return Future.value(null);
    }
  }
  return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}
