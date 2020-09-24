// To parse this JSON data, do
//
//     final foodTruck = foodTruckFromJson(jsonString);

import 'dart:convert';

FoodTruck foodTruckFromJson(String str) => FoodTruck.fromJson(json.decode(str));

String foodTruckToJson(FoodTruck data) => json.encode(data.toJson());

class FoodTruck {
    FoodTruck({
        this.id,
        this.name,
        this.type,
        this.lat,
        this.long,
        this.address,
        this.openingTime,
        this.closingTime,
    });

    int id;
    String name;
    String type;
    double lat;
    double long;
    String address;
    String openingTime;
    String closingTime;

    factory FoodTruck.fromJson(Map<String, dynamic> json) => FoodTruck(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        type: json["type"] == null ? null : json["type"],
        lat: json["lat"] == null ? null : json["lat"],
        long: json["long"] == null ? null : json["long"],
        address: json["address"] == null ? null : json["address"],
        openingTime: json["openingTime"] == null ? null : json["openingTime"],
        closingTime: json["closingTime"] == null ? null : json["closingTime"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "type": type == null ? null : type,
        "lat": lat == null ? null : lat,
        "long": long == null ? null : long,
        "address": address == null ? null : address,
        "openingTime": openingTime == null ? null : openingTime,
        "closingTime": closingTime == null ? null : closingTime,
    };
}
