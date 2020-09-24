import 'dart:async';
import 'package:foodtrucks/Data/FileHandler.dart';
import 'package:flutter/material.dart';
import 'package:foodtrucks/Modal/FoodTruck.dart';
import 'package:sqflite/sqflite.dart';

const TABLE_FOOD_TRUCKS = "foodTrucks";

//columns name for various tables
const CL_ID = "id";
const CL_NAME = "name";
const CL_TYPE = "type";
const CL_LAT = "lat";
const CL_LONG = "long";
const CL_ADDRESS = "address";
const CL_OPENING_TIME = "openingTime";
const CL_CLOSING_TIME = "closingTime";

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await initDB();
      return _database;
    }
  }

  initDB() async {
    String path = "${FileHandler.localPath}/DataProvider.db";
    debugPrint("DB_PATH : $path");
    Sqflite.setDebugModeOn(true);
    return await openDatabase(path, version: 1, onOpen: (db) {
      db.getVersion().then((v) {
        debugPrint("database opend V : $v");
      });
    }, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE $TABLE_FOOD_TRUCKS ("
          "$CL_ID INTEGER PRIMARY KEY,"
          "$CL_NAME TEXT,"
          "$CL_TYPE TEXT,"
          "$CL_LAT REAL,"
          "$CL_LONG REAL,"
          "$CL_ADDRESS TEXT,"
          "$CL_OPENING_TIME TEXT,"
          "$CL_CLOSING_TIME TEXT"
          ")");
    });
  }

  addFoodTruck(FoodTruck foodTruck) async {
    final db = await database;
    Batch batch = db.batch();
    List<Map> existingData = await db.query(
      TABLE_FOOD_TRUCKS,
      where: "$CL_ID = ?",
      whereArgs: [foodTruck.id],
      limit: 1,
    );
    if (existingData != null && existingData.length > 0) {
      batch.update(
        TABLE_FOOD_TRUCKS,
        {
          CL_NAME: foodTruck.name ?? "Food Truck - ${foodTruck.id}",
          CL_TYPE: foodTruck.type ?? "North Indian",
          CL_LAT: foodTruck.lat ?? 28.6304,
          CL_LONG: foodTruck.long ?? 77.2177,
          CL_ADDRESS:
              foodTruck.address ?? "Connaught Place, New Delhi, Delhi, 110001",
          CL_OPENING_TIME: foodTruck.openingTime ?? "10:00 AM",
          CL_CLOSING_TIME: foodTruck.closingTime ?? "10:00 PM",
        },
        where: "$CL_ID = ?",
        whereArgs: [foodTruck.id],
      );
    } else {
      batch.insert(TABLE_FOOD_TRUCKS, {
        CL_ID: foodTruck.id,
        CL_NAME: foodTruck.name ?? "Food Truck - ${foodTruck.id}",
        CL_TYPE: foodTruck.type ?? "North Indian",
        CL_LAT: foodTruck.lat ?? 28.6304,
        CL_LONG: foodTruck.long ?? 77.2177,
        CL_ADDRESS:
            foodTruck.address ?? "Connaught Place, New Delhi, Delhi, 110001",
        CL_OPENING_TIME: foodTruck.openingTime ?? "10:00 AM",
        CL_CLOSING_TIME: foodTruck.closingTime ?? "10:00 PM",
      });
    }

    await batch.commit(noResult: true);
  }

  Future<List<FoodTruck>> getAllFoodTrucks() async {
    List<FoodTruck> foodTrucks = List<FoodTruck>();
    final db = await database;
    List<Map> data = await db.query(TABLE_FOOD_TRUCKS);
    if (data != null && data.length > 0) {
      for (var item in data) {
        final foodTruck = FoodTruck.fromJson(item);
        foodTrucks.add(foodTruck);
      }
    }
    return foodTrucks;
  }

  Future<bool> checkIfIdIsUnique(int id) async {
    final db = await database;
    List<Map> data =
        await db.query(TABLE_FOOD_TRUCKS, where: "$CL_ID = ?", whereArgs: [id]);
    if (data != null && data.length > 0) {
      return false;
    } else {
      return true;
    }
  }

  deleteFoodTruck(FoodTruck foodTruck) async {
    final db = await database;
    await db.delete(TABLE_FOOD_TRUCKS,
        where: "$CL_ID = ? AND $CL_NAME = ?",
        whereArgs: [foodTruck.id, foodTruck.name]);
  }
}
