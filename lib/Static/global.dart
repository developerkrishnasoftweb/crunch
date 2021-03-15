import 'package:crunch/APIS/tables.dart';
import 'package:crunch/models/config_model.dart';
import 'package:crunch/models/userdata_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> openMyDataBase () async {
  String databasePath = await getDatabasesPath();
  return await openDatabase(databasePath + 'myDb.db',
      version: 1, onCreate: (Database db, int version) async {});
}

Future<void> createTables() async {
  var isTablesCreated = sharedPreferences.getBool("isTablesCreated") ?? false;
  if (!isTablesCreated) {
    await SQFLiteTables.createTables().then((value) async {
      if (value) {
        await SQFLiteTables.insertData();
      }
    });
    sharedPreferences.setBool("isTablesCreated", true);
  }
}

SharedPreferences sharedPreferences;
Database db;
Userdata userdata;
Config config;