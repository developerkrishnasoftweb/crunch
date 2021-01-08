import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'AppServices.dart';

const String API_BASE_URL =
    "http://52.76.48.26:4524/petpoojabilling_api/V1/pendingorders/mapped_restaurant_menus/";
const String Base_URL = "http://crunch.kriishnacab.com/api/";
const String Image_URL = "http://crunch.kriishnacab.com/";
const String API_Key = "0imfnc8mVLWwsAawjYr4Rx";


/*
* Database Managements
* */

class SQFLiteTables {
  static String replaceChar(String char) {
    return char.replaceAll(r"'", r"''");
  }
  static String tableRestaurants = "restaurants",
      tableOrderType = "ordertype",
      tableCategory = "category",
      tableItems = "items",
      tableVariations = "variations",
      tableAddOnGroups = "addongroups",
      tableAttributes = "attributes",
      tableDiscounts = "discounts",
      tableTaxes = "taxes";
  static Future<bool> createTables({Database db}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var isTablesCreated = sharedPreferences.getBool("isTablesCreated");
    if(isTablesCreated != null && isTablesCreated) {
      await db.execute("drop table if exists $tableRestaurants");
      await db.execute("drop table if exists $tableOrderType");
      await db.execute("drop table if exists $tableCategory");
      await db.execute("drop table if exists $tableItems");
      await db.execute("drop table if exists $tableVariations");
      await db.execute("drop table if exists $tableAddOnGroups");
      await db.execute("drop table if exists $tableAttributes");
      await db.execute("drop table if exists $tableDiscounts");
      await db.execute("drop table if exists $tableTaxes");
      await db.execute(
          "create table if not exists `$tableRestaurants` (`restaurantid` varchar(10), `menusharingcode` varchar(20), `restaurantname` varchar(50), `address` text, `contact` varchar(20), `lat` varchar(20), `lang` varchar(20), `landmark` varchar(50), `city` varchar(20), `state` varchar(30), `minimumorderamount` varchar(5), `minimumdeliverytime` varchar(30), `deliverycharge` varchar(5), `packaging_charge` varchar(15), `packaging_charge_type` varchar(20))");
      await db.execute(
          "create table if not exists `$tableOrderType` (`ordertypeid` varchar(3), `ordertype` varchar(15))");
      await db.execute(
          "create table if not exists `$tableCategory` (`categoryid` varchar(6), `active` varchar(3), `categoryrank` varchar(2), `parent_category_id` varchar(2), `categoryname` varchar(30), `categorytimings` varchar(50), `category_image_url` text)");
      await db.execute(
          "create table if not exists `$tableItems` (`itemid` varchar(100),`itemallowvariation` varchar(100),`itemrank` varchar(100),`item_categoryid` varchar(100),`item_ordertype` varchar(100),`item_packingcharges` varchar(100),`itemallowaddon` varchar(100),`itemaddonbasedon` varchar(100),`item_favorite` varchar(100),`ignore_taxes` varchar(100),`ignore_discounts` varchar(100),`in_stock` varchar(100),`variation` text, `addon` text, `itemname` varchar(100), `itemdescription` varchar(200), `price` varchar(4), `image` varchar(100), item_tax varchar(50), preparationtime varchar(5))");
      await db.execute(
          "create table if not exists `$tableVariations` (`variationid` varchar(100),`name` varchar(100),`groupname` varchar(100),`status` varchar(1))");
      await db.execute(
          "create table if not exists `$tableAddOnGroups`(`addongroupid` varchar(100),`addongroup_rank` varchar(100),`active` varchar(1), `addongroupitems` text, `addongroupname` varchar(50))");
      await db.execute(
          "create table if not exists `$tableAttributes` (`attributeid` varchar(100),`attribute` varchar(100),`active` varchar(1))");
      await db.execute(
          "create table if not exists `$tableDiscounts` (`discountid` varchar(100),`discountname` varchar(100),`discounttype` varchar(100),`discount` varchar(100),`discountordertype` varchar(100),`discountapplicableon` varchar(100),`discountdays` varchar(100),`active` varchar(100),`discountontotal` varchar(100),`discountstarts` varchar(100),`discountends` varchar(100),`discounttimefrom` varchar(100),`discounttimeto` varchar(100),`discountminamount` varchar(100),`discountmaxamount` varchar(100),`discounthascoupon` varchar(100),`discountcategoryitemids` varchar(100),`discountmaxlimit` varchar(100))");
      await db.execute(
          "create table if not exists `$tableTaxes` (`taxid` varchar(100),`taxname` varchar(100),`tax` varchar(100),`taxtype` varchar(100),`tax_ordertype` varchar(100),`active` varchar(1),`tax_coreortotal` varchar(100),`tax_taxtype` varchar(100),`rank` varchar(100),`description` varchar(100))");
      return true;
    } else {

    }

  }
  static Future<bool> insertData ({Database db}) async {
    await AppServices.fetchMenu().then((menuList) async {
      try {
        if (menuList.response == "1") {
          for (int i = 0; i < menuList.orderTypes.length; i++) {
            await db.execute(
                "insert into `$tableOrderType` values ('${menuList.orderTypes[i]["ordertypeid"]}', '${menuList.orderTypes[i]["ordertype"]}')");
          }
          for (int i = 0; i < menuList.restaurants.length; i++) {
            await db.execute(
                "insert into `$tableRestaurants` values ('${menuList.restaurants[i]["restaurantid"]}', '${menuList.restaurants[i]["details"]["menusharingcode"]}', '${menuList.restaurants[i]["details"]["restaurantname"]}', '${menuList.restaurants[i]["details"]["address"]}', '${menuList.restaurants[i]["details"]["contact"]}', '${menuList.restaurants[i]["details"]["latitude"]}', '${menuList.restaurants[i]["details"]["longitude"]}', '${menuList.restaurants[i]["details"]["landmark"]}', '${menuList.restaurants[i]["details"]["city"]}', '${menuList.restaurants[i]["details"]["state"]}', '${menuList.restaurants[i]["details"]["minimumorderamount"]}', '${menuList.restaurants[i]["details"]["minimumdeliverytime"]}', '${menuList.restaurants[i]["details"]["deliverycharge"]}', '${menuList.restaurants[i]["details"]["packaging_charge"]}', '${menuList.restaurants[i]["details"]["packaging_charge_type"]}')");
          }
          for (int i = 0; i < menuList.categories.length; i++) {
            await db.execute(
                "insert into `$tableCategory` values ('${menuList.categories[i]["categoryid"]}', '${menuList.categories[i]["active"]}', '${menuList.categories[i]["categoryrank"]}', '${menuList.categories[i]["parent_category_id"]}', '${SQFLiteTables.replaceChar(menuList.categories[i]["categoryname"])}', '${menuList.categories[i]["categorytimings"]}', '${menuList.categories[i]["category_image_url"]}')");
          }
          for (int i = 0; i < menuList.items.length; i++) {
            await db.execute("insert into `$tableItems` values ('${menuList.items[i]["itemid"]}', '${menuList.items[i]["itemallowvariation"]}', '${menuList.items[i]["itemrank"]}', '${menuList.items[i]["item_categoryid"]}', '${menuList.items[i]["item_ordertype"]}', '${menuList.items[i]["item_packingcharges"]}', '${menuList.items[i]["itemallowaddon"]}', '${menuList.items[i]["itemaddonbasedon"]}', '${menuList.items[i]["item_favorite"]}', '${menuList.items[i]["ignore_taxes"]}', '${menuList.items[i]["ignore_discounts"]}', '${menuList.items[i]["in_stock"]}', '${jsonEncode(menuList.items[i]["variation"])}', '${jsonEncode(menuList.items[i]["addon"])}', '${menuList.items[i]["itemname"]}', '${menuList.items[i]["itemdescription"]}', '${menuList.items[i]["price"]}', '${menuList.items[i]["item_image_url"]}', '${menuList.items[i]["item_tax"]}', '${menuList.items[i]["minimumpreparationtime"]}')");
          }
          for (int i = 0; i < menuList.variations.length; i++) {
            await db.execute("insert into `$tableVariations` values ('${menuList.variations[i]["variationid"]}', '${menuList.variations[i]["name"]}', '${menuList.variations[i]["groupname"]}', '${menuList.variations[i]["status"]}')");
          }
          for (int i = 0; i < menuList.addOnGroups.length; i++) {
            await db.execute("insert into `$tableAddOnGroups` values ('${menuList.addOnGroups[i]["addongroupid"]}', '${menuList.addOnGroups[i]["addongroup_rank"]}', '${menuList.addOnGroups[i]["active"]}', '${jsonEncode(menuList.addOnGroups[i]["addongroupitems"])}', '${menuList.addOnGroups[i]["addongroup_name"]}')");
          }
          for (int i = 0; i < menuList.attributes.length; i++) {
            await db.execute("insert into `$tableAttributes` values ('${menuList.attributes[i]["attributeid"]}', '${menuList.attributes[i]["attribute"]}', '${menuList.attributes[i]["active"]}')");
          }
          for (int i = 0; i < menuList.discounts.length; i++) {
            await db.execute("insert into `$tableDiscounts` values ('${menuList.discounts[i]["discountid"]}', '${menuList.discounts[i]["discountname"]}', '${menuList.discounts[i]["discounttype"]}', '${menuList.discounts[i]["discount"]}', '${menuList.discounts[i]["discountordertype"]}', '${menuList.discounts[i]["discountapplicableon"]}', '${menuList.discounts[i]["discountdays"]}', '${menuList.discounts[i]["active"]}', '${menuList.discounts[i]["discountontotal"]}', '${menuList.discounts[i]["discountstarts"]}', '${menuList.discounts[i]["discountends"]}', '${menuList.discounts[i]["discounttimefrom"]}', '${menuList.discounts[i]["discounttimeto"]}', '${menuList.discounts[i]["discountminamount"]}', '${menuList.discounts[i]["discountmaxamount"]}', '${menuList.discounts[i]["discounthascoupon"]}', '${menuList.discounts[i]["discountcategoryitemids"]}', '${menuList.discounts[i]["discountmaxlimit"]}')");
          }
          for (int i = 0; i < menuList.taxes.length; i++) {
            await db.execute("insert into `$tableTaxes` values ('${menuList.taxes[i]["taxid"]}', '${menuList.taxes[i]["taxname"]}', '${menuList.taxes[i]["tax"]}', '${menuList.taxes[i]["taxtype"]}', '${menuList.taxes[i]["tax_ordertype"]}', '${menuList.taxes[i]["active"]}', '${menuList.taxes[i]["tax_coreortotal"]}', '${menuList.taxes[i]["tax_taxtype"]}', '${menuList.taxes[i]["rank"]}', '${menuList.taxes[i]["description"]}')");
          }
          return true;
        }
      } catch (exception) {
        print(exception);
        return false;
      }
    });
    return false;
  }
  static Future<List<Map<String, dynamic>>> getData({Tables table}) async {
    String databasePath = await getDatabasesPath();
    Database db = await openDatabase(databasePath + 'myDb.db', version: 1, onCreate: (Database db, int version) async {});
    switch(table) {
      case Tables.RESTAURANTS :
        return db.rawQuery("select * from `$tableRestaurants`");
        break;
      case Tables.ADD_ON_GROUPS :
        return db.rawQuery("select * from `$tableAddOnGroups`");
        break;
      case Tables.ATTRIBUTES :
        return db.rawQuery("select * from `$tableAttributes`");
        break;
      case Tables.CATEGORY :
        return db.rawQuery("select * from `$tableCategory`");
        break;
      case Tables.DISCOUNTS :
        return db.rawQuery("select * from `$tableDiscounts`");
        break;
      case Tables.ITEMS :
        return db.rawQuery("select * from `$tableItems`");
        break;
      case Tables.ORDER_TYPE :
        return db.rawQuery("select * from `$tableOrderType`");
        break;
      case Tables.TAXES :
        return db.rawQuery("select * from `$tableTaxes`");
        break;
      case Tables.VARIATIONS :
        return db.rawQuery("select * from `$tableVariations`");
        break;
      default :
        return null;
        break;
    }
  }
}
enum Tables{
  RESTAURANTS,
  ORDER_TYPE,
  CATEGORY,
  ITEMS,
  VARIATIONS,
  ADD_ON_GROUPS,
  ATTRIBUTES,
  DISCOUNTS,
  TAXES
}