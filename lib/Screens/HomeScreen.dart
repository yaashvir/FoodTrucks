import 'package:foodtrucks/Screens/FoodTruckDetailsScreen.dart';
import 'package:foodtrucks/Screens/FoodTrucksListScreen.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:foodtrucks/Common/AppColors.dart';
import 'package:foodtrucks/Data/Repository.dart';
import 'package:foodtrucks/Modal/FoodTruck.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  double screenHeight;
  double screenWidth;
  String mapStyle;
  MarkerId previousMarker;
  GoogleMapController controller;
  double defaultZoom = 15;
  LatLng center = LatLng(28.6304, 77.2177);
  List<FoodTruck> foodTrucks = List<FoodTruck>();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  PageController pageController = PageController(viewportFraction: 0.9);

  @override
  void initState() {
    super.initState();
    getFoodtrucks();
    pageController.addListener(() {
      int page = pageController.page.toInt();
      highlightMaker(MarkerId(foodTrucks[page].id.toString()));
    });
    rootBundle.loadString('assets/mapStyle.txt').then((string) {
      mapStyle = string;
    });
  }

  getFoodtrucks() async {
    foodTrucks = await Repository().getFoodTrucks();
    buildMarkers();
  }

  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
    this.controller.setMapStyle(mapStyle);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: center,
              zoom: defaultZoom,
            ),
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            padding: EdgeInsets.only(bottom: 180),
            markers: Set<Marker>.of(markers.values),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: SizedBox(
                  height: 165.0,
                  child: PageView.builder(
                    itemCount: foodTrucks.length,
                    controller: pageController,
                    itemBuilder: (BuildContext context, int itemIndex) {
                      return buildPageItem(context, foodTrucks[itemIndex]);
                    },
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 10,
            bottom: MediaQuery.of(context).padding.bottom + 180,
            child: RawMaterialButton(
              constraints: BoxConstraints(),
              onPressed: goToAllListScreen,
              elevation: 1,
              fillColor: appBackgroundColor,
              child: Icon(
                Icons.list,
                size: 35.0,
                color: appThemeColor,
              ),
              padding: EdgeInsets.all(10),
              shape: CircleBorder(),
            ),
          )
        ],
      ),
    );
  }

  buildMarkers() {
    for (int i = 0; i < foodTrucks.length; i++) {
      FoodTruck foodTruck = foodTrucks[i];
      MarkerId markerId = MarkerId(foodTruck.id.toString());
      final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(foodTruck.lat, foodTruck.long),
        infoWindow:
            InfoWindow(title: foodTruck.name, snippet: foodTruck.address),
        onTap: () {
          pageController.jumpToPage(i);
        },
      ).copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
        194,
      ));
      setState(() {
        markers[markerId] = marker;
      });
    }
  }

  buildPageItem(BuildContext context, FoodTruck item) {
    DateFormat dateFormat = DateFormat.jm();
    final currentTime = dateFormat.parse(dateFormat.format(DateTime.now()));
    final openingTime = dateFormat.parse(item.openingTime);
    final closingTime = dateFormat.parse(item.closingTime);
    bool isOpen =
        currentTime.isAfter(openingTime) && currentTime.isBefore(closingTime);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: GestureDetector(
        onTap: () {
          goToFoodTruckDetailsScreen(item);
        },
        child: Card(
          elevation: 3,
          color: appBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              : Text(
                                  "(Closed)",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
                Align(
                  alignment: Alignment.bottomRight,
                  child: RawMaterialButton(
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  highlightMaker(MarkerId markerId) {
    final Marker marker = markers[markerId];
    if (marker != null) {
      setState(() {
        if (previousMarker != null) {
          final Marker resetOld = markers[previousMarker].copyWith(
              iconParam: BitmapDescriptor.defaultMarkerWithHue(
            194,
          ));
          markers[previousMarker] = resetOld;
        }

        final Marker newMarker = marker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            339,
          ),
        );

        markers[markerId] = newMarker;
        previousMarker = newMarker.markerId;
        controller.showMarkerInfoWindow(markerId);
        controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            bearing: 0,
            target: newMarker.position,
            zoom: defaultZoom,
          ),
        ));
      });
    }
  }

  goToFoodTruckDetailsScreen(FoodTruck foodTruck) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodTruckDetailsScreen(
          foodTruck: foodTruck,
        ),
      ),
    ).then((_) {
      getFoodtrucks();
    });
  }

  goToAllListScreen() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodTrucksListScreen(
          foodTrucks: foodTrucks,
        ),
      ),
    ).then((_) {
      getFoodtrucks();
    });
  }
}
