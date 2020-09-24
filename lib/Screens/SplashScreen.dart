import 'dart:async';
import 'package:flutter/material.dart';
import 'package:foodtrucks/Common/AppColors.dart';
import 'package:foodtrucks/Data/FileHandler.dart';
import 'package:foodtrucks/Screens/HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  double screenHeight;
  double screenWidth;

  @override
  void initState() {
    super.initState();
    peformAppSetup();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenHeight * 0.5,
              padding: EdgeInsets.fromLTRB(30, 30, 30, 60),
              decoration: BoxDecoration(
                color: appThemeColor,
                borderRadius: BorderRadius.vertical(
                    top: Radius.elliptical(screenWidth, 150)),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        "FOOD TRUCKS",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: appBackgroundColor),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Hey, Now you can find best food near you in just one click. Also you can select your favourite food and we will help you to reach there!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: appSecondaryBackgroundColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.3,
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

  peformAppSetup() async {
    Timer(Duration(seconds: 3), () async {
      await FileHandler.initLocalPath();
      goToHomeScreen();
    });
  }

  goToHomeScreen() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }
  
}
