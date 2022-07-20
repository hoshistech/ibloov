import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ibloov/Activity/SelectLocation.dart';
import 'package:ibloov/Constants/ApiCalls.dart';

import 'package:ibloov/Constants/ColorList.dart';
import 'package:ibloov/Constants/Methods.dart';
import 'package:ibloov/Widget/HomeWidget.dart';
import 'package:ibloov/model/event_model.dart';
import 'package:ibloov/model/event_response.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilterFrame extends StatefulWidget {
  BuildContext context;
  double height;
  double width;
  VoidCallback onApply;

  FilterFrame(this.context, this.height, this.width, this.onApply);

  @override
  FilterFrameState createState() => FilterFrameState();
}

class FilterFrameState extends State<FilterFrame> {
  SharedPreferences prefs;

  Map data;
  bool reset = true;

  List locationFilter = [
    {'text': 'Current Location', 'icon': Icons.location_pin},
    // {'text': 'Find Location', 'icon': Icons.search}
  ];
  List conditionFilter = [
    'Women only',
    'Men only',
    '18+',
    'Kids',
    'Invites only'
  ];
  List dateFilter = [
    'Today',
    'Tomorrow',
    'This week',
    'This weekend',
    'Choose a date'
  ];

  @override
  void initState() {
    getPref(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      //height: MediaQuery.of(context).size.height * 0.9,
      color: Colors.transparent, //could change this to Color(0xFF737373),
      //so you don't have to change MaterialApp canvasColor
      child: new Container(
          height: 551,
          padding: EdgeInsets.all(15.0),
          decoration: new BoxDecoration(
              borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(50.0),
                  topRight: const Radius.circular(50.0)),
              gradient: LinearGradient(
                  begin: const Alignment(0.0, -1),
                  end: const Alignment(0.0, 0.0),
                  colors: [ColorList.colorBackground, Colors.white])),
          child: Column(
            children: [
              Container(
                child: Text(
                  'Filters',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: 'SF_Pro_900',
                    decoration: TextDecoration.none,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: ColorList.colorPrimary,
                  ),
                ),
                padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
              ),
              Container(
                height: 460,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text(
                          'Location',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: 'SF_Pro_700',
                            decoration: TextDecoration.none,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: ColorList.colorPrimary,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5.0),
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: new List.generate(locationFilter.length,
                              (int index) {
                            return Padding(
                              padding:
                                  EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
                              child: MaterialButton(
                                //elevation: 2.0,
                                textColor: (index == Methods.locationIndex)
                                    ? ColorList.colorAccent
                                    : ColorList.colorSplashBG,
                                color: (index != Methods.locationIndex)
                                    ? ColorList.colorAccent
                                    : ColorList.colorSplashBG,
                                child: Row(
                                  children: [
                                    Icon(
                                      locationFilter[index]['icon'],
                                      size: 20,
                                      color: (index == Methods.locationIndex)
                                          ? ColorList.colorAccent
                                          : ColorList.colorSplashBG,
                                    ),
                                    SizedBox(width: 5),
                                    Text(locationFilter[index]['text'])
                                  ],
                                ),
                                onPressed: () async {
                                  if (index != Methods.locationIndex) {
                                    setState(() {
                                      reset = false;
                                      Methods.locationIndex = index;
                                    });
                                  }
                                  if (index == 0) {
                                    getPref(false);
                                  } else if (index == 1) {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SelectLocation(
                                              currentPosition)),
                                    );
                                    Methods.currentPosition = result;
                                    _getAddressFromLatLng();
                                  }
                                },
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                              ),
                            );
                          }),
                        ),
                        height: 65.0,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(
                            left: 15.0, top: 15.0, bottom: 10.0),
                        child: Text(
                          'Condition',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: 'SF_Pro_700',
                            decoration: TextDecoration.none,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: ColorList.colorPrimary,
                          ),
                        ),
                      ),
                      Wrap(
                        children:
                            List.generate(conditionFilter.length, (int index) {
                          return Padding(
                            padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                            child: MaterialButton(
                              //elevation: 2.0,
                              textColor: (index == Methods.conditionIndex)
                                  ? ColorList.colorAccent
                                  : ColorList.colorSplashBG,
                              color: (index != Methods.conditionIndex)
                                  ? ColorList.colorAccent
                                  : ColorList.colorSplashBG,
                              child: Text(conditionFilter[index]),
                              onPressed: () {
                                if (index != Methods.conditionIndex) {
                                  setState(() {
                                    reset = false;
                                    Methods.conditionIndex = index;
                                    // Methods.conditionString =
                                    //     conditionFilter[index];
                                    Methods.conditionString =
                                        getCondition(index);
                                  });
                                }
                              },
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                            ),
                          );
                        }),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(
                            left: 15.0, top: 15.0, bottom: 10.0),
                        child: Text(
                          'Date',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: 'SF_Pro_700',
                            decoration: TextDecoration.none,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: ColorList.colorPrimary,
                          ),
                        ),
                      ),
                      Wrap(
                        children: List.generate(dateFilter.length, (int index) {
                          return Padding(
                            padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                            child: MaterialButton(
                              //elevation: 2.0,
                              textColor: (index == Methods.dateIndex)
                                  ? ColorList.colorAccent
                                  : ColorList.colorSplashBG,
                              color: (index != Methods.dateIndex)
                                  ? ColorList.colorAccent
                                  : ColorList.colorSplashBG,
                              child: Text(dateFilter[index]),
                              onPressed: () {
                                // if (index != Methods.dateIndex) {
                                setState(() {
                                  reset = false;
                                  Methods.dateIndex = index;
                                  if (index == 0) {
                                    setDate(0, 0);
                                  } else if (index == 1) {
                                    setDate(1, 1);
                                  } else if (index == 2) {
                                    DateTime today = DateTime.now();
                                    int day =
                                        DateTime.daysPerWeek - today.weekday;
                                    setDate(0, day);
                                  } else if (index == 3) {
                                    DateTime today = DateTime.now();
                                    int day =
                                        DateTime.daysPerWeek - today.weekday;
                                    setDate(day - 1, day);
                                  } else if (index == 4) {
                                    DatePicker.showDatePicker(context,
                                        showTitleActions: true,
                                        minTime: DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day),
                                        onConfirm: (date) {
                                      final future = DateTime(
                                          date.year, date.month, date.day);
                                      final today = DateTime.now();
                                      setDate(
                                          future.difference(today).inDays + 1,
                                          future.difference(today).inDays + 1);

                                      dateFilter[index] =
                                          DateFormat.yMd().format(date);
                                    },
                                        currentTime: DateTime.now(),
                                        locale: LocaleType.en);
                                  }
                                });
                                // }
                              },
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                            ),
                          );
                        }),
                      ),
                      // Container(
                      //   alignment: Alignment.centerLeft,
                      //   padding: EdgeInsets.only(
                      //       left: 15.0, top: 15.0, bottom: 10.0),
                      //   child: Text(
                      //     'Price',
                      //     textAlign: TextAlign.start,
                      //     style: TextStyle(
                      //       fontFamily: 'SF_Pro_700',
                      //       decoration: TextDecoration.none,
                      //       fontSize: 15.0,
                      //       fontWeight: FontWeight.bold,
                      //       color: ColorList.colorPrimary,
                      //     ),
                      //   ),
                      // ),
                      // Container(
                      //   alignment: Alignment.centerLeft,
                      //   padding:
                      //       EdgeInsets.only(left: 15.0, top: 0.0, bottom: 10.0),
                      //   child: Text(
                      //     Methods.priceString,
                      //     textAlign: TextAlign.start,
                      //     style: TextStyle(
                      //       fontFamily: 'SF_Pro_700',
                      //       decoration: TextDecoration.none,
                      //       fontSize: 15.0,
                      //       fontWeight: FontWeight.bold,
                      //       color: ColorList.colorPrimary,
                      //     ),
                      //   ),
                      // ),
                      // RangeSlider(
                      //   values: Methods.rangeValues,
                      //   min: 0,
                      //   max: 20000,
                      //   divisions: 100,
                      //   onChanged: (RangeValues values) {
                      //     setState(() {
                      //       reset = false;
                      //       Methods.rangeValues = values;
                      //       Methods.priceString = (values.start == 0
                      //               ? 'Free'
                      //               : values.start.toInt().toString()) +
                      //           (values.end == 0
                      //               ? ''
                      //               : (' - ' + values.end.toInt().toString()));
                      //     });
                      //   },
                      // ),
                      Container(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MaterialButton(
                            color: ColorList.colorAccent.withOpacity(0.9),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            minWidth: widget.width * 0.25,
                            height: 50.0,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                            ),
                            elevation: 0.0,
                            onPressed: () {
                              getPref(true);
                            },
                            child: Text(
                              'Reset',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: 'SF_Pro_600',
                                decoration: TextDecoration.none,
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal,
                                color: ColorList.colorSplashBG,
                              ),
                            ),
                          ),
                          MaterialButton(
                            color: ColorList.colorSplashBG,
                            minWidth: widget.width * 0.6,
                            height: 50.0,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                            ),
                            elevation: 5.0,
                            onPressed: () {
                              setMapData();
                              Navigator.pop(context);
                              widget.onApply();
                              // setState(() {
                              //   Methods.data == reset ? null : data;
                              // });
                            },
                            child: Text(
                              'Apply',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: 'SF_Pro_600',
                                decoration: TextDecoration.none,
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal,
                                color: ColorList.colorAccent,
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        height: 15.0,
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }

  void setDate(start, end) {
    DateTime now = new DateTime.now();
    Methods.startDateString =
        new DateTime(now.year, now.month, now.day + start).toString();
    Methods.endDateString =
        new DateTime(now.year, now.month, now.day + end).toString();
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          Methods.currentPosition.latitude, Methods.currentPosition.longitude);

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
        Methods.currentAddress = '$subLocality$locality$country';
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> getPref(stat) async {
    prefs = await SharedPreferences.getInstance();
    Methods.currentPosition = Position(
        latitude: prefs.getDouble('latitude'),
        longitude: prefs.getDouble('longitude'));
    Methods.currentAddress = prefs.getString('Methods.currentAddress');

    if (stat) setDefaultData();
  }

  void setDefaultData() {
    setState(() {
      reset = true;
      Methods.locationIndex = 0;
      Methods.conditionIndex = 0;
      Methods.conditionString = '';
      Methods.dateIndex = 0;
      Methods.startDateString = '';
      Methods.endDateString = '';
      Methods.rangeValues = const RangeValues(0, 0);
      Methods.priceString = '';
    });

    setMapData();
  }

  void setMapData() {
    data = {
      'latitude': Methods.currentPosition.latitude,
      'longitude': Methods.currentPosition.longitude,
      'condition': Methods.conditionString,
      'start_date': Methods.startDateString,
      'end_date': Methods.endDateString,
      'min_price': Methods.rangeValues.start.toInt(),
      'max_price': Methods.rangeValues.end.toInt()
    };
  }

  _filterEvents() {
    ApiCalls.filterEvents(
            context,
            Methods.currentPosition.latitude,
            Methods.currentPosition.longitude,
            Methods.conditionString,
            Methods.rangeValues.end.toInt(),
            Methods.startDateString,
            Methods.endDateString)
        .then((value) {
      if (value != null) {
        final eventData = json.decode(value);
        final exploreEventModel = ExploreEventResponse.fromJson(eventData);
        final filteredEvents = exploreEventModel?.data?.filtered;
        widget.onApply();
        Navigator.pop(context);
      }
    });
  }

  String getCondition(int index) {
    switch (index) {
      case 0:
        return "WOMEN_ONLY";
      case 1:
        return "MEN_ONLY";
      case 2:
        return "NO_CHILDREN";
      case 3:
        return "CHILDREN_ONLY";
      case 4:
        return "INVITES_ONLY";
      default:
        return "";
    }
  }
}
