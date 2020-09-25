import 'package:flutter/cupertino.dart';
import 'package:foodtrucks/Screens/FoodTruckDetailsScreen.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:foodtrucks/Common/AppColors.dart';
import 'package:foodtrucks/Modal/FoodTruck.dart';
import 'package:foodtrucks/Screens/AddFoodTruckScreen.dart';
import 'package:map_launcher/map_launcher.dart';

class FoodTrucksListScreen extends StatefulWidget {
  final List<FoodTruck> foodTrucks;
  FoodTrucksListScreen({@required this.foodTrucks});

  @override
  State<StatefulWidget> createState() => FoodTrucksListScreenState();
}

class FoodTrucksListScreenState extends State<FoodTrucksListScreen> {
  double screenHeight;
  double screenWidth;
  String selectedType = "Any";
  List<FoodTruck> filteredFoodTrucks = List<FoodTruck>();

  @override
  void initState() {
    super.initState();
    filteredFoodTrucks = widget.foodTrucks;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: appSecondaryBackgroundColor,
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        title: Text("ALL TRUCKS"),
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.sort,
                  size: 30,
                ),
                onPressed: () {
                  showModalBottomSheet(
                      elevation: 8,
                      context: context,
                      builder: (BuildContext builder) {
                        return _buildBottomPicker(builder);
                      });
                },
              ),
              Visibility(
                visible: selectedType != "Any",
                child: Container(
                  height: 30,
                  width: 5,
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 5,
                    width: 5,
                    decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(11)),
                  ),
                ),
              )
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.add,
              size: 30,
            ),
            onPressed: addFoodTruck,
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: filteredFoodTrucks.length,
        itemBuilder: (context, index) {
          return buildListItem(filteredFoodTrucks[index]);
        },
      ),
    );
  }

  buildListItem(FoodTruck item) {
    DateFormat dateFormat = DateFormat.jm();
    final currentTime = dateFormat.parse(dateFormat.format(DateTime.now()));
    final openingTime = dateFormat.parse(item.openingTime);
    final closingTime = dateFormat.parse(item.closingTime);
    bool isOpen =
        currentTime.isAfter(openingTime) && currentTime.isBefore(closingTime);

    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          goToFoodTruckDetailsScreen(item);
        },
        child: Card(
          elevation: 3,
          color: appBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          color: appTextColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.openingTime + " - " + item.closingTime,
                            style: TextStyle(
                              color: appSecondaryTextColor,
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
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              : Text(
                                  "(Closed)",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        item.address,
                        style: TextStyle(
                          color: appTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                RawMaterialButton(
                  constraints: BoxConstraints(),
                  onPressed: () async {
                    final availableMaps = await MapLauncher.installedMaps;
                    await availableMaps.first.showDirections(
                      destination: Coords(item.lat, item.long),
                      destinationTitle: item.name,
                    );
                  },
                  elevation: 1,
                  fillColor: appThemeColor,
                  child: Icon(
                    Icons.navigation,
                    size: 30.0,
                    color: appBackgroundColor,
                  ),
                  padding: EdgeInsets.all(10),
                  shape: CircleBorder(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomPicker(BuildContext builder) {
    List<String> types = ["Any", "North Indian", "Italian", "Chinese"];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 50,
          color: Colors.grey[100],
          alignment: Alignment.centerRight,
          child: Container(
            margin: EdgeInsets.only(right: 10),
            height: 30,
            width: 100,
            child: RaisedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: appThemeColor,
              child: Text(
                "DONE",
                style: TextStyle(
                    color: appBackgroundColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        Container(
          height: screenHeight * 0.3,
          child: CupertinoPicker(
            useMagnifier: true,
            magnification: 1.2,
            itemExtent: 40,
            backgroundColor: Colors.grey[100],
            onSelectedItemChanged: (int index) {
              setState(() {
                selectedType = types[index];
                filteredFoodTrucks = widget.foodTrucks
                    .where((item){
                      if (selectedType == "Any") {
                        return true;
                      } else {
                         return item.type == selectedType;
                      }
                    })
                    .toList();
              });
            },
            children: new List<Widget>.generate(types.length, (int index) {
              return new Center(
                child: new Text(
                  types[index],
                  style: TextStyle(
                    color: appThemeColor,
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  goToFoodTruckDetailsScreen(FoodTruck foodTruck) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodTruckDetailsScreen(
          foodTruck: foodTruck,
        ),
      ),
    );
  }

  addFoodTruck() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddFoodTruckScreen(),
      ),
    );
  }
}
