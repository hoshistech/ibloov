import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:ibloov/Constants/ColorList.dart';
import 'package:ibloov/Constants/Methods.dart';

import 'Signup.dart';
import 'SignupSuccess.dart';

var width,height;
Position _currentPosition;
String _currentAddress;

class EnableLocation extends StatefulWidget {
  @override
  EnableLocationState createState() => EnableLocationState();
}

class EnableLocationState extends State<EnableLocation> {

  _getCurrentLocation() {
    Methods.determinePosition().then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        //_currentAddress = "${place.locality}, ${place.postalCode}, ${place.country}";
        _currentAddress = "${place.locality}, ${place.country}";

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Your Current Location: $_currentAddress"),
            )
        );

        gotoSuccess(context);

      });

      print('Current Position: $_currentPosition');
      print('Current Address: $_currentAddress');
    } catch (e) {
      print(e);
    }
  }
  
  @override
  Widget build(BuildContext context) {

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    
    return Scaffold(
      body: WillPopScope(
        child: Container(
          height: height,
          width: width,
          color: ColorList.colorAccent,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: height * 0.2,
                ),
                Container(
                    width: width * 0.5,
                    height: width * 0.5,
                    child: Image.asset('assets/images/enable_location.png')
                ),
                Padding(
                  padding: EdgeInsets.only(top:20.0),
                  child: Text(
                    "Enable your location",
                    style: TextStyle(
                        fontFamily: 'SF_Pro_700',
                        decoration: TextDecoration.none,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top:20.0),
                  child: Container(
                    child: Column(
                      children: [
                        Text(
                          "Before proceeding, kindly enable your",
                          style: TextStyle(
                              fontFamily: 'SF_Pro_400',
                              decoration: TextDecoration.none,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                        SizedBox(height: height * 0.005),
                        Text(
                          "location to start seeing events around you",
                          style: TextStyle(
                              fontFamily: 'SF_Pro_400',
                              decoration: TextDecoration.none,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: height * 0.15,
                ),
                MaterialButton(
                  minWidth: width * 0.9,
                  height: 50.0,
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  onPressed: () {
                    /*Navigator.pushReplacement(
               context,
               MaterialPageRoute(builder: (context) => EnableLocation()),
             );*/

                    _getCurrentLocation();
                  },
                  color: ColorList.colorSplashBG,
                  child: Text(
                    'Turn on Location',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'SF_Pro_700',
                      decoration: TextDecoration.none,
                      fontSize: 15.0,
                      fontWeight: FontWeight.normal,
                      color: ColorList.colorAccent,
                    ),
                  ),
                ),
                Container(
                  height: height * 0.01,
                ),
                MaterialButton(
                  minWidth: width * 0.6,
                  height: 50.0,
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  onPressed: () {
                    gotoSuccess(context);
                  },
                  color: Colors.transparent,
                  //splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  highlightElevation: 0.0,
                  elevation: 0.0,
                  child: Text(
                    'Do Not allow',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'SF_Pro_400',
                      decoration: TextDecoration.none,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: ColorList.colorSplashBG,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        onWillPop: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Signup())
          );
          return null;
        },
      )
    );
  }

  void gotoSuccess(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignupSuccess()),
    );
  }
}