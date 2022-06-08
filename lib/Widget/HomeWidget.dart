import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ibloov/Activity/CreateEvents.dart';
import 'package:ibloov/Activity/ExploreEvents.dart';
import 'package:ibloov/Activity/FAQ.dart';
import 'package:ibloov/Activity/SelectLocation.dart';
import 'package:ibloov/Activity/TicketQRCode.dart';

import 'package:ibloov/Constants/ColorList.dart';
import 'package:ibloov/Constants/Methods.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import '../Activity/ShowQRCode.dart';

Position currentPosition;
String currentAddress = 'Fetching location...';
// final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

class HomeWidget extends StatefulWidget {
  @override
  HomeWidgetState createState() => HomeWidgetState();
}

class HomeWidgetState extends State<HomeWidget> with TickerProviderStateMixin {
  SharedPreferences prefs;
  String fullName;
  var isLocationTracked = false;

  AnimationController controller;
  Animation createEventAnimation;
  Animation exploreEventAnimation;
  Animation liveEventAnimation;

  getName() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      fullName = prefs.getString('fullName').split(" ")[0];
      isLocationTracked = prefs.getBool('isLocationTracked');
      debugPrint("isLocationTracked: $isLocationTracked");
      if (isLocationTracked == null) {
        isLocationTracked = false;
        _getCurrentLocation();
      } else if (!isLocationTracked)
        _getCurrentLocation();
      else {
        currentPosition = new Position(
          latitude: prefs.getDouble('latitude'),
          longitude: prefs.getDouble('longitude'),
          speed: 0.0,
          accuracy: 0.0,
          altitude: 0.0,
          timestamp: null,
          speedAccuracy: 0.0,
          heading: 0.0,
        );
        currentAddress = prefs.getString('currentAddress');
      }
    });
  }

  _getCurrentLocation() {
    debugPrint("getCurrentLocation");

    try {
      Methods.determinePosition().then((Position position) {
        debugPrint("currentLocation: $position");
        setState(() {
          currentPosition = position;
        });

        _getAddressFromLatLng();
      }).catchError((e) {
        debugPrint("location error: $e");
      });
    } catch (e) {
      debugPrint("location error: $e");
    }
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        var placeData = json.decode(json.encode(place.toJson()));
        String subLocality = placeData["subLocality"].length > 0
            ? '${placeData["subLocality"]}, '
            : "";
        String locality = placeData["locality"].length > 0
            ? '${placeData["locality"]}, '
            : "";
        String country =
            placeData["country"].length > 0 ? placeData["country"] : "";
        currentAddress = '$subLocality$locality$country';
        isLocationTracked = true;
        prefs.setBool('isLocationTracked', isLocationTracked);
        prefs.setString('currentAddress', currentAddress);
        prefs.setDouble('longitude', currentPosition.toJson()['longitude']);
        prefs.setDouble('latitude', currentPosition.toJson()['latitude']);
      });
    } catch (e) {
      debugPrint("getAddressLatLng: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getName();
    });

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 10));

    createEventAnimation = TweenSequence(
      [
        TweenSequenceItem(
            tween: Tween<Offset>(begin: Offset(0, 0), end: Offset(0.3, -0.1)),
            weight: 1),
        TweenSequenceItem(
            tween: Tween<Offset>(
                begin: Offset(0.3, -0.1), end: Offset(-0.3, -0.1)),
            weight: 1),
        TweenSequenceItem(
            tween: Tween<Offset>(begin: Offset(-0.3, -0.1), end: Offset(0, 0)),
            weight: 1),
        //  TweenSequenceItem(tween: Tween<Offset>(begin: Offset(0, 0),end: Offset(0, -0.4)), weight: 1),
      ],
    ).animate(controller);

    exploreEventAnimation = TweenSequence(
      [
        TweenSequenceItem(
            tween:
                Tween<Offset>(begin: Offset(0.1, 0.2), end: Offset(-0.2, 0.2)),
            weight: 1),
        TweenSequenceItem(
            tween:
                Tween<Offset>(begin: Offset(-0.2, 0.2), end: Offset(0.2, 0.1)),
            weight: 1),
        TweenSequenceItem(
            tween:
                Tween<Offset>(begin: Offset(0.2, 0.1), end: Offset(0.1, 0.2)),
            weight: 1),
        //  TweenSequenceItem(tween: Tween<Offset>(begin: Offset(0, 0),end: Offset(0, -0.4)), weight: 1),
      ],
    ).animate(controller);

    liveEventAnimation = TweenSequence(
      [
        TweenSequenceItem(
            tween:
                Tween<Offset>(begin: Offset(-0.2, 0.2), end: Offset(0.2, 0.3)),
            weight: 1),
        TweenSequenceItem(
            tween:
                Tween<Offset>(begin: Offset(0.2, 0.3), end: Offset(-0.2, 0.3)),
            weight: 1),
        TweenSequenceItem(
            tween:
                Tween<Offset>(begin: Offset(-0.2, 0.3), end: Offset(-0.2, 0.2)),
            weight: 1),
        //  TweenSequenceItem(tween: Tween<Offset>(begin: Offset(0, 0),end: Offset(0, -0.4)), weight: 1),
      ],
    ).animate(controller);
    // Repeat the animation after finish

    controller.repeat(reverse: false);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: height * 0.2,
                color: ColorList.colorBackground,
                padding: EdgeInsets.only(top: 60, left: 20, right: 20),
                width: width,
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text("Hi, $fullName",
                              style: TextStyle(
                                  fontFamily: 'SF_Pro_700',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                        Container(
                          height: height * 0.0055,
                        ),
                        InkWell(
                            onTap: () async {
                              // final result = await Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) =>
                              //           SelectLocation(currentPosition)),
                              // );
                              // debugPrint(
                              //     'Latitude before: ${currentPosition.latitude}');
                              // debugPrint(
                              //     'Longitude before: ${currentPosition.longitude}');
                              // debugPrint('Address before: $currentAddress');
                              // currentPosition = result;
                              // _getAddressFromLatLng();
                              // debugPrint(
                              //     'Latitude after: ${currentPosition.latitude}');
                              // debugPrint(
                              //     'Longitude after: ${currentPosition.longitude}');
                              // debugPrint('Address after: $currentAddress');
                            },
                            child:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              Text(currentAddress,
                                  style: TextStyle(
                                      fontFamily: 'SF_Pro_700',
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black)),
                              Opacity(
                                opacity: 0.0,
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.black,
                                ),
                              ),
                            ])),
                      ],
                    ),
                    Spacer(),
                    Opacity(
                      opacity: 0.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                              onTap: () {
                                Methods.showComingSoon();
                              },
                              child: Image.asset("assets/images/scanner.png")),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                  width: width,
                  height: height * 0.8,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: const Alignment(0.0, -1),
                          end: const Alignment(0.0, 0.6),
                          colors: [ColorList.colorBackground, Colors.white])),
                  padding: EdgeInsets.only(bottom: height * 0.15),
                  child: Stack(
                    children: [
                      _getCircle(
                          "create_event.png",
                          width * 0.5,
                          //createEventAnimation, TicketQRCode('6154fdcf27bd0deac9e44032', false)),
                          createEventAnimation,
                          CreateEvents()),
                      //createEventAnimation, FAQ()),
                      /*_getCircle("live_event.png", width * 0.35,
                        liveEventAnimation, CreateEvents()),*/
                      _getCircle(
                          "explore_event.png",
                          width * 0.32,
                          exploreEventAnimation,
                          ExploreEvents(
                              "Reg", currentPosition, currentAddress)),
                    ],
                  )),
            ],
          ),
          if (!isLocationTracked)
            Container(
              height: height,
              width: width,
              color: ColorList.colorSeeAll.withOpacity(0.25),
              child: Center(
                  child: CircularProgressIndicator(
                color: ColorList.colorAccent,
              ) /*Text(
                  'Please wait until location is fetched...',
                  style: TextStyle(
                    fontFamily: 'SF_Pro_600',
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: ColorList.colorSplashBG,
                  ),
                ),*/
                  ),
            )
        ],
      ),
    );
  }

  Widget _getCircle(image, width, animation, pageName) {
    return SlideTransition(
      position: animation,
      child: Center(
        child: GestureDetector(
          onTap: () {
            if (pageName != null)
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => pageName),
              );
          },
          child: ClipRRect(
              borderRadius: BorderRadius.circular(300),
              child: Image(
                  image: AssetImage(
                'assets/images/' + image,
              ))),
        ),
      ),
    );
  }
}
