import 'package:flutter/material.dart';
import 'package:foodtrucks/Common/AppColors.dart';
import 'package:foodtrucks/Data/DBProvider.dart';
import 'package:foodtrucks/Modal/FoodTruck.dart';
import 'package:foodtrucks/Screens/AddFoodTruckScreen.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';


class FoodTruckDetailsScreen extends StatefulWidget {
  final FoodTruck foodTruck;
  FoodTruckDetailsScreen({@required this.foodTruck});

  @override
  State<StatefulWidget> createState() => FoodTruckDetailsScreenState();
}

class FoodTruckDetailsScreenState extends State<FoodTruckDetailsScreen> {
  double screenHeight;
  double screenWidth;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    DateFormat dateFormat = DateFormat.jm();
    final currentTime = dateFormat.parse(dateFormat.format(DateTime.now()));
    final openingTime = dateFormat.parse(widget.foodTruck.openingTime);
    final closingTime = dateFormat.parse(widget.foodTruck.closingTime);
    bool isOpen =
        currentTime.isAfter(openingTime) && currentTime.isBefore(closingTime);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: transparentColor,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: appThemeColor,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenHeight * 0.7,
              padding: EdgeInsets.fromLTRB(30, 100, 30, 60),
              decoration: BoxDecoration(
                color: appThemeColor,
                borderRadius: BorderRadius.vertical(
                    top: Radius.elliptical(screenWidth, 150)),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        widget.foodTruck.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: appBackgroundColor),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.foodTruck.openingTime +
                                " - " +
                                widget.foodTruck.closingTime,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: appSecondaryBackgroundColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          isOpen
                              ? Text(
                                  "(Open)",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.yellow,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              : Text(
                                  "(Closed)",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.yellow,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.foodTruck.address,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: appBackgroundColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.foodTruck.type + " Restaurant",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RawMaterialButton(
                            constraints: BoxConstraints(),
                            onPressed: () {
                              editFoodTruck();
                            },
                            elevation: 1,
                            fillColor: appBackgroundColor,
                            child: Icon(
                              Icons.edit,
                              size: 30.0,
                              color: appSecondaryTextColor,
                            ),
                            padding: EdgeInsets.all(10),
                            shape: CircleBorder(),
                          ),
                          RawMaterialButton(
                            constraints: BoxConstraints(),
                            onPressed: () async {
                              final availableMaps =
                                  await MapLauncher.installedMaps;
                              await availableMaps.first.showDirections(
                                destination: Coords(widget.foodTruck.lat, widget.foodTruck.long),
                                destinationTitle: widget.foodTruck.name,
                              );
                            },
                            elevation: 1,
                            fillColor: appBackgroundColor,
                            child: Icon(
                              Icons.navigation,
                              size: 30.0,
                              color: appThemeColor,
                            ),
                            padding: EdgeInsets.all(10),
                            shape: CircleBorder(),
                          ),
                          RawMaterialButton(
                            constraints: BoxConstraints(),
                            onPressed: () async {
                              await DBProvider.db
                                  .deleteFoodTruck(widget.foodTruck);
                              Navigator.of(context).pop();
                            },
                            elevation: 1,
                            fillColor: appBackgroundColor,
                            child: Icon(
                              Icons.delete,
                              size: 30.0,
                              color: Colors.red,
                            ),
                            padding: EdgeInsets.all(10),
                            shape: CircleBorder(),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.5,
            width: screenWidth,
            height: screenHeight * 0.5,
            child: Center(
              child: Image.asset(
                "assets/foodTruck.png",
                height: screenHeight * 0.4,
                width: screenHeight * 0.4,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  editFoodTruck() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddFoodTruckScreen(
          foodTruck: widget.foodTruck,
        ),
      ),
    );
  }
}
