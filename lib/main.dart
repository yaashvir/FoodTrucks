import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:foodtrucks/Common/AppColors.dart';
import 'package:foodtrucks/Screens/SplashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: appThemeColor,
        appBarTheme: AppBarTheme(
            color: appThemeColor, brightness: Brightness.dark),
        fontFamily: 'Nunito',
        backgroundColor: appBackgroundColor,
        scaffoldBackgroundColor: appBackgroundColor,
        applyElevationOverlayColor: false,
      ),
      darkTheme: ThemeData(
        primaryColor: appThemeColor,
        appBarTheme: AppBarTheme(
            color: appThemeColor, brightness: Brightness.dark),
        fontFamily: 'Nunito',
        backgroundColor: appBackgroundColor,
        scaffoldBackgroundColor: appBackgroundColor,
        applyElevationOverlayColor: false,
      ),
      color: appThemeColor,
      title: "Food Trucks",
      home: SplashScreen(),
    );
  }
}