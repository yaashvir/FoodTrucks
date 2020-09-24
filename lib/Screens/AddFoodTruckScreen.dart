import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodtrucks/Common/AppColors.dart';
import 'package:foodtrucks/Modal/FoodTruck.dart';
import 'package:foodtrucks/Data/DBProvider.dart';

class AddFoodTruckScreen extends StatefulWidget {
  final FoodTruck foodTruck;
  AddFoodTruckScreen({this.foodTruck});

  @override
  State<StatefulWidget> createState() => AddFoodTruckScreenState();
}

class AddFoodTruckScreenState extends State<AddFoodTruckScreen> {
  double screenHeight;
  double screenWidth;
  final FocusNode _idNode = FocusNode();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _typeNode = FocusNode();
  final FocusNode _addressNode = FocusNode();
  final FocusNode _latNode = FocusNode();
  final FocusNode _longNode = FocusNode();
  final FocusNode _openingTimeNode = FocusNode();
  final FocusNode _closingTimeNode = FocusNode();

  final _idControl = TextEditingController();
  final _nameControl = TextEditingController();
  final _typeControl = TextEditingController();
  final _addressControl = TextEditingController();
  final _latControl = TextEditingController();
  final _longControl = TextEditingController();
  final _openingTimeControl = TextEditingController();
  final _closingTimeControl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.foodTruck != null) {
      _idControl.text = widget.foodTruck.id.toString();
      _nameControl.text = widget.foodTruck.name;
      _typeControl.text = widget.foodTruck.type;
      _addressControl.text = widget.foodTruck.address;
      _latControl.text = widget.foodTruck.lat.toString();
      _longControl.text = widget.foodTruck.long.toString();
      _openingTimeControl.text = widget.foodTruck.openingTime;
      _closingTimeControl.text = widget.foodTruck.closingTime;
    }
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
        title: Text(widget.foodTruck != null ? "EDIT TRUCK" : "ADD TRUCK"),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Theme(
              data: ThemeData(primaryColor: appThemeColor),
              child: Column(
                children: [
                  getTextField(
                    title: "ID",
                    controller: _idControl,
                    focusNode: _idNode,
                    leadingIcon: Icons.vpn_key,
                    keyboardType: TextInputType.number,
                    onFieldSubmitted: () {
                      FocusScope.of(context).requestFocus(_nameNode);
                    },
                  ),
                  getTextField(
                    title: "Name",
                    controller: _nameControl,
                    focusNode: _nameNode,
                    leadingIcon: Icons.location_city,
                    onFieldSubmitted: () {
                      FocusScope.of(context).requestFocus(_typeNode);
                    },
                  ),
                  getTextField(
                    title: "Type",
                    controller: _typeControl,
                    focusNode: _typeNode,
                    leadingIcon: Icons.fastfood,
                    readOnly: true,
                    onTap: () {
                      showModalBottomSheet(
                          elevation: 8,
                          context: context,
                          builder: (BuildContext builder) {
                            return _buildBottomPicker(builder);
                          });
                    },
                  ),
                  getTextField(
                    title: "Address",
                    controller: _addressControl,
                    focusNode: _addressNode,
                    leadingIcon: Icons.place,
                    onFieldSubmitted: () {
                      FocusScope.of(context).requestFocus(_latNode);
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: getTextField(
                          title: "Latitude",
                          controller: _latControl,
                          focusNode: _latNode,
                          leadingIcon: Icons.add_location,
                          keyboardType: TextInputType.datetime,
                          onFieldSubmitted: () {
                            FocusScope.of(context).requestFocus(_typeNode);
                          },
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: getTextField(
                          title: "Longitude",
                          controller: _longControl,
                          focusNode: _longNode,
                          leadingIcon: Icons.add_location,
                          keyboardType: TextInputType.datetime,
                          onFieldSubmitted: () {
                            FocusScope.of(context)
                                .requestFocus(_openingTimeNode);
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: getTextField(
                          title: "Open At",
                          controller: _openingTimeControl,
                          focusNode: _openingTimeNode,
                          leadingIcon: Icons.store,
                          readOnly: true,
                          onTap: () async {
                            TimeOfDay time = await showTimePicker(
                                context: context, initialTime: TimeOfDay.now());
                            if (time != null) {
                              _openingTimeControl.text = time.format(context);
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: getTextField(
                          title: "Close At",
                          controller: _closingTimeControl,
                          focusNode: _closingTimeNode,
                          leadingIcon: Icons.store,
                          readOnly: true,
                          onTap: () async {
                            TimeOfDay time = await showTimePicker(
                                context: context, initialTime: TimeOfDay.now());
                            if (time != null) {
                              _closingTimeControl.text = time.format(context);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    height: 50,
                    width: screenWidth - 30,
                    child: RaisedButton(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.all(Radius.elliptical(30, 30)),
                      ),
                      child: RichText(
                          text: TextSpan(
                              text: "SAVE",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: appThemeColor))),
                      onPressed: () {
                        saveFoodTruck();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomPicker(BuildContext builder) {
    List<String> types = ["North Indian", "Italian", "Chinese"];

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
                _typeControl.text = types[index];
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

  getTextField(
      {@required String title,
      @required TextEditingController controller,
      @required FocusNode focusNode,
      @required IconData leadingIcon,
      bool readOnly = false,
      TextInputType keyboardType = TextInputType.text,
      TextInputAction textInputAction = TextInputAction.next,
      void Function() onFieldSubmitted,
      void Function() onTap}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.elliptical(50, 50)),
        ),
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          style: TextStyle(
            fontSize: 16,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(12, 8, 20, 8),
            border: InputBorder.none,
            labelText: title,
            prefixIcon: Icon(leadingIcon),
          ),
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          readOnly: readOnly,
          onTap: () {
            if (onTap != null) {
              onTap();
            }
          },
          onFieldSubmitted: (String value) {
            if (onFieldSubmitted != null) {
              onFieldSubmitted();
            }
          },
        ),
      ),
    );
  }

  saveFoodTruck() async {
    if (_idControl.text != null && _idControl.text.isNotEmpty) {
      final id = int.parse(_idControl.text) ?? 1;

      FoodTruck editedFoodTruck = FoodTruck(
        id: id,
        name: _nameControl.text != "" ? _nameControl.text : "Food Truck - $id",
        type: _typeControl.text != "" ? _typeControl.text : "North Indian",
        openingTime: _openingTimeControl.text != ""
            ? _openingTimeControl.text
            : "10:00 AM",
        closingTime: _closingTimeControl.text != ""
            ? _closingTimeControl.text
            : "10:00 PM",
        address: _addressControl.text != ""
            ? _addressControl.text
            : "Connaught Place, New Delhi, Delhi, 110001",
        lat:
            double.parse(_latControl.text != "" ? _latControl.text : "28.6304"),
        long: double.parse(
            _longControl.text != "" ? _longControl.text : "77.2177"),
      );

      if (widget.foodTruck != null) {
        await DBProvider.db.addFoodTruck(editedFoodTruck);
        showSnackBar("Great",
            "Selected Food Truck details is edited successfully.", false);
      } else {
        bool isIdUnique = await DBProvider.db.checkIfIdIsUnique(id);
        if (isIdUnique) {
          await DBProvider.db.addFoodTruck(editedFoodTruck);
          showSnackBar(
              "Great", "New Food Truck details submitted successfully.", false);
        } else {
          showSnackBar(
              "Oooooops!",
              "Id for your Food Truck must be unique try another integer value.",
              true);
        }
      }
    } else {
      showSnackBar(
          "Oooooops!", "Please enter a numeric Id for your Food Truck.", true);
    }
  }

  showSnackBar(String title, String message, bool isError) {
    Flushbar(
      backgroundColor: isError ? appBackgroundColor : appThemeColor,
      titleText: Text(
        title,
        style: TextStyle(
            color: isError ? Colors.red : appBackgroundColor,
            fontSize: 16,
            fontWeight: FontWeight.w600),
      ),
      messageText: Text(
        message,
        style: TextStyle(
            color: isError ? appTextColor : appSecondaryBackgroundColor,
            fontSize: 12,
            fontWeight: FontWeight.w400),
      ),
      duration: Duration(seconds: 3),
    )..show(context);
  }
}
