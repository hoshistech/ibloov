import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ibloov/Constants/ApiCalls.dart';

import 'package:ibloov/Constants/ColorList.dart';
import 'package:ibloov/Constants/Methods.dart';
import 'package:ibloov/model/event_model.dart';
import 'package:ibloov/model/event_response.dart';
import 'package:intl/intl.dart';

import 'Onboarding.dart';
import 'EventList.dart';
import 'EventDetails.dart';

var height, width;

class ExploreEvents extends StatefulWidget {
  String type, currentAddress;
  Position currentPosition;

  ExploreEvents(this.type, this.currentPosition, this.currentAddress);

  @override
  ExploreEventsState createState() => ExploreEventsState();
}

class ExploreEventsState extends State<ExploreEvents> {
  bool isLoading = true, isMap = false, isMsgShown = false;
  int countEvent = 0;
  String catIndex = "0";
  List categories = [];
  Map<String, dynamic> eventData;

  List listHeader = [
    {'text': 'Featured Events', 'name': 'featuredEvents'},
    {'text': 'Trending Now', 'name': 'trendingEvents'},
    {'text': 'Happening Near You', 'name': 'happeningNearMe'},
    {'text': 'Happening Today', 'name': 'happeningToday'},
    {'text': 'Happening This Week', 'name': 'happeningThisWeek'},
    {'text': 'Upcoming', 'name': 'upcoming'},
    {'text': 'Recommended For You', 'name': 'recommendedForYou'},
  ];

  BitmapDescriptor icon;
  LatLng _center;
  GoogleMapController mapController;
  final Set<Marker> _markers = {};
  bool stat = true;
  List<double> lat = [], lng = [];
  ExploreEventData exploreEventData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _center = LatLng(
          widget.currentPosition.latitude, widget.currentPosition.longitude);
      _getExploreEvents();
    });
  }

  _getExploreEvents() {
    if (stat && isLoading) {
      setState(() {
        stat = false;
      });

      ApiCalls.fetchEvents(context, widget.currentPosition.latitude,
              widget.currentPosition.longitude)
          .then((value) {
        setState(() {
          if (value != null) {
            eventData = json.decode(value);
            final exploreEventModel = ExploreEventResponse.fromJson(eventData);
            exploreEventData = exploreEventModel?.data;

            debugPrint(
                "featuredEvents: ${eventData['data'][listHeader.elementAt(0)['name']]}");
            debugPrint("featuredEvents: ${exploreEventData.featuredEvents}");

            isLoading = false;
          } else {
            Navigator.pop(context);
          }
        });
      });

      ApiCalls.fetchCategories().then((value) {
        setState(() {
          if (value != null) {
            var data = json.decode(value)['data'];

            categories.clear();
            categories.add('{"_id": "0", "name": "All"}');

            for (int i = 0; i < data.length; i++) {
              categories.add(json.encode(data[i]));
            }
          } else {
            Navigator.pop(context);
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    // _getExploreEvents();

    return isLoading
        ? Container(
            height: height,
            color: ColorList.colorAccent,
            child: Center(
              child: CircularProgressIndicator(
                color: ColorList.colorSeeAll,
              ),
            ),
          )
        : RefreshIndicator(
            color: ColorList.colorSeeAll,
            child: Scaffold(
                body: Stack(
              children: [
                WillPopScope(
                  child: Container(
                      padding: EdgeInsets.only(top: 160.0),
                      height: height,
                      child: Stack(
                        children: [
                          Container(
                            color: ColorList.colorAccent,
                            child: (!isMap) ? Container() : getMap(),
                          ),
                          SingleChildScrollView(
                            padding: EdgeInsets.only(top: 65.0, bottom: 100),
                            child: (!isMap) ? getList() : Container(),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 15.0, bottom: 5.0),
                            color: (!isMap)
                                ? ColorList.colorAccent
                                : Colors.transparent,
                            child: ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: new List.generate(categories.length,
                                  (int index) {
                                return Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
                                  child: MaterialButton(
                                    elevation: 2.0,
                                    textColor: (json.decode(
                                                categories[index])["_id"] ==
                                            catIndex)
                                        ? ColorList.colorAccent
                                        : ColorList.colorSplashBG,
                                    color: (json.decode(
                                                categories[index])["_id"] !=
                                            catIndex)
                                        ? ColorList.colorAccent.withOpacity(0.8)
                                        : ColorList.colorSplashBG,
                                    child: Text(
                                        json.decode(categories[index])["name"]),
                                    onPressed: () {
                                      if (json.decode(
                                              categories[index])["_id"] !=
                                          catIndex) {
                                        setState(() {
                                          countEvent = 0;
                                          catIndex = json
                                              .decode(categories[index])["_id"];
                                          isMsgShown = false;
                                        });
                                      }
                                    },
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            height: 70.0,
                          ),
                        ],
                      )),
                  onWillPop: () {
                    backMethod();
                    return null;
                  },
                ),
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: ColorList.colorAccent,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.25),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          InkWell(
                              onTap: () {
                                backMethod();
                              },
                              child: Padding(
                                child: Icon(Icons.arrow_back,
                                    color: ColorList.colorBack, size: 30),
                                padding: EdgeInsets.all(0.0),
                              )),
                          Spacer(),
                          (widget.type == 'Reg')
                              ? InkWell(
                                  splashColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  onTap: () {
                                    Methods.openSearch(
                                        context, new TextEditingController());
                                  },
                                  child: Icon(
                                    Icons.search,
                                    color: ColorList.colorPrimary,
                                  ),
                                )
                              : Container()
                        ],
                      ),
                      Container(
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/near_event.png',
                              width: 25.0,
                              height: 25.0,
                            ),
                            Container(
                              width: 18.0,
                            ),
                            Text(
                              'Explore Events',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: 'SF_Pro_900',
                                decoration: TextDecoration.none,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w900,
                                color: ColorList.colorPrimary,
                              ),
                            ),
                            Spacer(),
                            /*InkWell(
                                  onTap: (){
                                    if(widget.currentPosition == null) {
                                      _getCurrentLocation(false)
                                          .then((value) {
                                        setState(() {
                                          isMap = !isMap;
                                          countEvent = 0;
                                        });
                                      });
                                    } else{
                                      setState(() {
                                        isMap = !isMap;
                                        countEvent = 0;
                                      });
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        (isMap) ? 'assets/images/grid_view.png' : 'assets/images/map_view.png',
                                        //width: 10.0,
                                        height: 15.0,
                                        //color: ColorList.colorSplashBG,
                                      ),
                                      Container(
                                        width: 5.0,
                                      ),
                                      Text(
                                        (isMap) ? 'Grid view' : 'Map View',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontFamily: 'SF_Pro_600',
                                          decoration: TextDecoration.none,
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.normal,
                                          color: ColorList.colorSplashBG,
                                        ),
                                      ),
                                    ],
                                  ),
                                )*/
                          ],
                        ),
                        padding: EdgeInsets.fromLTRB(0.0, 25.0, 15.0, 25.0),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.fromLTRB(15, 35, 15, 5),
                ),
              ],
            )),
            onRefresh: () {
              return Future.delayed(
                Duration(seconds: 1),
                () {
                  isLoading = true;
                  stat = true;
                  _getExploreEvents();
                },
              );
            });
  }

  getIcons() async {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(50, 50)), 'assets/images/marker.png')
        .then((d) {
      icon = d;
    });
  }

  void _onCameraMove(CameraPosition position) {
    LatLng _currentMapPosition = _center;
    _currentMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    setState(() {
      _markers.add(Marker(
        markerId: MarkerId('Me'),
        draggable: false,
        icon: icon,
        anchor: const Offset(0.5, 0.5),
        position: _center,
      ));
    });
  }

  getMap() {
    getIcons();

    // addMarkers();

    Set<Circle> circles = Set.from([
      Circle(
        circleId: CircleId('3'),
        center: _center,
        radius: 1000,
        strokeWidth: 1,
        fillColor: ColorList.colorCorousalIndicatorActive.withOpacity(0.1),
        strokeColor: ColorList.colorSplashBG,
      ),
      Circle(
        circleId: CircleId('2'),
        center: _center,
        radius: 500,
        strokeWidth: 1,
        fillColor: ColorList.colorGenderBackground.withOpacity(0.1),
        strokeColor: ColorList.colorPrimary,
      ),
      Circle(
        circleId: CircleId('1'),
        center: _center,
        radius: 200,
        strokeWidth: 1,
        fillColor: ColorList.colorGrayBorder.withOpacity(0.1),
        strokeColor: ColorList.colorGrayHint,
      ),
    ]);

    return Container(
      height: (height - 145) * 0.95,
      child: GoogleMap(
        markers: _markers,
        onCameraMove: _onCameraMove,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 15.0,
        ),
        mapType: MapType.normal,
        circles: circles,
      ),
    );
  }

  //
  // void addMarkers() {
  //
  //   var listEvent = [];
  //   var idEvents = [];
  //
  //   for(int i=0; i<eventData['data'].length; i++){
  //     var sublistEvent = eventData['data'][listHeader.elementAt(i)['name']];
  //     for(int j=0; j<sublistEvent.length; j++){
  //       if(!idEvents.contains(sublistEvent[j]['_id'])){
  //         listEvent.add(sublistEvent[j]);
  //         idEvents.add(sublistEvent[j]['_id']);
  //       }
  //     }
  //   }
  //   var dataArray;
  //
  //   if(catIndex != "0")
  //     dataArray = listEvent
  //         .where((item) => item['category']['_id'] == catIndex).toList();
  //   else
  //     dataArray = listEvent;
  //
  //   countEvent = dataArray.length;
  //
  //   getMessege();
  //
  //   // for(int i=0; i<dataArray.length; i++){
  //   //   _markers.add(
  //   //       Marker(
  //   //           markerId: MarkerId('${dataArray[i]['_id']}'),
  //   //           position: LatLng(dataArray[i]['location']['coordinates'][1], dataArray[i]['location']['coordinates'][0]),
  //   //           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
  //   //           onTap: () {
  //   //             Methods.openEventDetails(context, dataArray[i]['_id']);
  //   //           },
  //   //           consumeTapEvents: true
  //   //       )
  //   //   );
  //   // }
  // }

  getList() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getFeaturedEventsSlides(),
          for (int i = 1; i < 7; i++) getEventsWidgets(i),
          getMessage(),
          Container(
            height: 25.0,
          )
        ],
      ),
    );
  }

  getFeaturedEventsSlides() {
    List<Event> events;

    if (catIndex != "0") {
      // events = eventData['data'][listHeader.elementAt(0)['name']]
      //     .where((item) => item['category']['_id'] == catIndex).toList();
      events = exploreEventData.featuredEvents
          .where((element) => element?.category?.sId == catIndex)
          .toList();
    } else {
      events = exploreEventData.featuredEvents;
      // dataArray = eventData['data'][listHeader.elementAt(0)['name']];
    }

    debugPrint("current DataArray: $events");

    if (events.length > 0) {
      countEvent += events.length;
      List<Widget> slides = [];
      List<bool> saved = [];

      for (int item = 0; item < events.length; item++) {
        saved.add(false);

        final data = Container(
          child: Card(
              elevation: 0.0,
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Methods.openEventDetails(context, events[item]?.sId ?? "");
                },
                child: Container(
                    padding: EdgeInsets.only(left: 10.0),
                    margin: EdgeInsets.zero,
                    // color: ColorList.colorSplashBG,
                    child: Container(
                      padding: (item == events.length - 1)
                          ? EdgeInsets.only(right: 10.0)
                          : EdgeInsets.zero,
                      child: ClipRRect(
                        child: Stack(
                          children: [
                            Methods.getSmallEventCardImage(
                                events[item]?.banner ?? "",
                                width: width * 0.8,
                                height: width * 0.6),
                            Container(
                                height: width * 0.6,
                                width: width * 0.8,
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Row(
                                            children: [
                                              Card(
                                                  elevation: 0.0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  child: Padding(
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          (events[item]
                                                                      ?.startTime ==
                                                                  null)
                                                              ? '01'
                                                              : DateFormat('dd')
                                                                  .format(DateTime
                                                                      .tryParse(
                                                                          events[item]
                                                                              .startTime)),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'SF_Pro_700',
                                                            decoration:
                                                                TextDecoration
                                                                    .none,
                                                            fontSize: 20.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: (events[item]
                                                                        ?.startTime ==
                                                                    null)
                                                                ? ColorList
                                                                    .colorAccent
                                                                : ColorList
                                                                    .colorPrimary,
                                                          ),
                                                        ),
                                                        Text(
                                                          (events[item]
                                                                      ?.startTime ==
                                                                  null)
                                                              ? '01'
                                                              : DateFormat(
                                                                      'MMM')
                                                                  .format(DateTime
                                                                      .tryParse(
                                                                          events[item]
                                                                              .startTime)),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'SF_Pro_400',
                                                            decoration:
                                                                TextDecoration
                                                                    .none,
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: (events[item]
                                                                        .startTime ==
                                                                    null)
                                                                ? ColorList
                                                                    .colorAccent
                                                                : ColorList
                                                                    .colorPrimary,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            12.0,
                                                            5.0,
                                                            12.0,
                                                            5.0),
                                                  )),
                                              Spacer(),
                                            ],
                                          ),
                                          SizedBox(
                                            height: width * 0.05,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 5.0),
                                            child: Text(
                                              events[item]?.category?.name ??
                                                  "",
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: 'SF_Pro_400',
                                                decoration: TextDecoration.none,
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.normal,
                                                color: ColorList.colorAccent,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: width * 0.012,
                                          ),
                                          SizedBox(
                                            width: width * 0.8,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 5.0, right: 5.0),
                                              child: Text(
                                                events[item]?.title,
                                                textAlign: TextAlign.start,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontFamily: 'SF_Pro_700',
                                                  decoration:
                                                      TextDecoration.none,
                                                  fontSize: 22.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: ColorList.colorAccent,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: width * 0.012,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 5.0),
                                            child: Text(
                                              '${events[item]?.location?.city ?? ""},${events[item]?.location?.country ?? ''}',
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: 'SF_Pro_400',
                                                decoration: TextDecoration.none,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.normal,
                                                color: ColorList.colorAccent,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: width * 0.006,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 5.0),
                                                child: Text(
                                                  Methods.getLowestPrice(
                                                      events[item]?.tickets,
                                                      true),
                                                  style: TextStyle(
                                                    fontFamily: 'SF_Pro_700',
                                                    decoration:
                                                        TextDecoration.none,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        ColorList.colorAccent,
                                                  ),
                                                ),
                                              ),
                                              Spacer(),
                                              InkWell(
                                                onTap: () {
                                                  Methods.shareEvent(
                                                      events[item]?.link);
                                                },
                                                child: Icon(
                                                  Icons.share_outlined,
                                                  size: 20,
                                                  color: ColorList.colorAccent,
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    events[item].userLiked =
                                                        !events[item].userLiked;
                                                  });

                                                  ApiCalls.toggleLike(
                                                          events[item]?.sId)
                                                      .then((value) {
                                                    if (!value)
                                                      setState(() {
                                                        events[item].userLiked =
                                                            !events[item]
                                                                .userLiked;
                                                      });
                                                  });
                                                },
                                                child: Icon(
                                                  (events[item].userLiked)
                                                      ? Icons.favorite
                                                      : Icons.favorite_outline,
                                                  size: 20,
                                                  color: (events[item]
                                                          .userLiked)
                                                      ? ColorList.colorRed
                                                      : ColorList.colorAccent,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      padding: EdgeInsets.fromLTRB(
                                          10.0, 10.0, 10.0, 10.0),
                                    )))
                          ],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    )),
              )),
        );

        slides.add(data);
      }

      final slider = Container(
        alignment: Alignment.topLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.only(top: 25.0, bottom: 10.0),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Text(
                      listHeader.elementAt(0)['text'],
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'SF_Pro_700',
                        decoration: TextDecoration.none,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: ColorList.colorPrimary,
                      ),
                    ),
                  ),
                  Spacer(),
                  if(events.length > 2)
                    InkWell(
                    child: Padding(
                      padding: EdgeInsets.only(right: 15.0),
                      child: Text(
                        'See all',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'SF_Pro_700',
                          decoration: TextDecoration.none,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: ColorList.colorSeeAll,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EventList(0, eventData['data'])),
                      );
                    },
                  )
                ],
              )),
          CarouselSlider(
            options: CarouselOptions(
                autoPlay: slides.length > 2 ? true : false,
                // enlargeCenterPage: true,
                // aspectRatio: 2.0,
                disableCenter: true,
                viewportFraction: 0.8,
                enableInfiniteScroll: false,
                autoPlayAnimationDuration: Duration(seconds: 5)),
            items: slides,
          )
        ],
      ));

      return slider;
    } else {
      return const SizedBox();
    }
  }

  List<Event> getEvents(int index) {
    switch (index) {
      case 1:
        return exploreEventData.trendingEvents;
      case 2:
        return exploreEventData.happeningNearMe;
      case 3:
        return exploreEventData.happeningToday;
      case 4:
        return exploreEventData.happeningThisWeek;
      case 5:
        return exploreEventData.upcoming;
      case 6:
        return exploreEventData.recommendedForYou;
      default:
        return <Event>[];
    }
  }

  getEventsWidgets(int index) {
    List<Event> events;

    if (catIndex != "0") {
      // events = eventData['data'][listHeader.elementAt(index)['name']]
      //     .where((item) => item['category']['_id'] == catIndex)
      //     .toList();
      events = getEvents(index)
          .where((item) => item.category.sId == catIndex)
          .toList();
    } else {
      // events = eventData['data'][listHeader.elementAt(index)['name']];
      events = getEvents(index);
    }

    if (events.length > 0) {
      countEvent += events.length;

      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.only(top: 25.0, bottom: 10.0),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Text(
                      listHeader.elementAt(index)['text'],
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'SF_Pro_700',
                        decoration: TextDecoration.none,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: ColorList.colorPrimary,
                      ),
                    ),
                  ),
                  Spacer(),
                  if(events.length > 3)
                    InkWell(
                    child: Padding(
                      padding: EdgeInsets.only(right: 15.0),
                      child: Text(
                        'See all',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'SF_Pro_700',
                          decoration: TextDecoration.none,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: ColorList.colorSeeAll,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EventList(index, eventData['data'])),
                      );
                    },
                  )
                ],
              )),
          Container(
            //padding: EdgeInsets.only(top: 15.0),
            height: 220.0,
            child: ListView.builder(
              physics: ClampingScrollPhysics(),
              // shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: (events.length >= 5) ? 5 : events.length,
              itemBuilder: (BuildContext context, int item) => Card(
                  elevation: 0.0,
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Methods.openEventDetails(context, events[item]?.sId);
                    },
                    child: Container(
                        padding: EdgeInsets.only(left: 10.0),
                        margin: EdgeInsets.zero,
                        color: ColorList.colorAccent,
                        child: Container(
                          padding: (item == 2)
                              ? EdgeInsets.only(right: 10.0)
                              : EdgeInsets.zero,
                          child: ClipRRect(
                            child: Stack(
                              children: [
                                Methods.getSmallEventCardImage(
                                    events[item]?.banner,
                                    width: width * 0.6,
                                    height: width * 0.8),
                                Container(
                                    width: width * 0.6,
                                    height: width * 0.8,
                                    child: Column(
                                      children: [
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Card(
                                                          elevation: 0.0,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                          child: Padding(
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  (events[item]
                                                                              ?.startTime ==
                                                                          null)
                                                                      ? '01'
                                                                      : DateFormat(
                                                                              'dd')
                                                                          .format(
                                                                              DateTime.tryParse(events[item]?.startTime)),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'SF_Pro_700',
                                                                    decoration:
                                                                        TextDecoration
                                                                            .none,
                                                                    fontSize:
                                                                        14.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: (events[item]?.startTime ==
                                                                            null)
                                                                        ? ColorList
                                                                            .colorAccent
                                                                        : ColorList
                                                                            .colorPrimary,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  (events[item]
                                                                              ?.startTime ==
                                                                          null)
                                                                      ? 'JAN'
                                                                      : DateFormat(
                                                                              'MMM')
                                                                          .format(
                                                                              DateTime.tryParse(events[item]?.startTime))
                                                                          .toUpperCase(),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'SF_Pro_400',
                                                                    decoration:
                                                                        TextDecoration
                                                                            .none,
                                                                    fontSize:
                                                                        12.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    color: (events[item]?.startTime ==
                                                                            null)
                                                                        ? ColorList
                                                                            .colorAccent
                                                                        : ColorList
                                                                            .colorPrimary,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    12.0,
                                                                    5.0,
                                                                    12.0,
                                                                    5.0),
                                                          )),
                                                      Spacer(),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: width * 0.05,
                                                  ),
                                                  Row(
                                                    children: [
                                                      // for showing the red mark for Live Events

                                                      /*SizedBox(
                                                            width: 2,
                                                          ),
                                                          Card(
                                                            color: ColorList.colorRed,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(5.0),
                                                            ),
                                                            child: Container(
                                                              height: 5,
                                                              width: 5,
                                                            ),
                                                          ),*/

                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5.0),
                                                        child: Text(
                                                          "${events[item]?.category?.name ?? ""}",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'SF_Pro_400',
                                                            decoration:
                                                                TextDecoration
                                                                    .none,
                                                            fontSize: 12.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: ColorList
                                                                .colorAccent,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: width * 0.005,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 5.0, right: 5.0),
                                                    child: Text(
                                                      events[item]?.title,
                                                      textAlign:
                                                          TextAlign.start,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'SF_Pro_700',
                                                        decoration:
                                                            TextDecoration.none,
                                                        fontSize: 20.0,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: ColorList
                                                            .colorAccent,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: width * 0.01,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 5.0),
                                                    child: Text(
                                                      '${events[item]?.location?.name ?? ""}, ${events[item]?.location?.city}}',
                                                      textAlign:
                                                          TextAlign.start,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'SF_Pro_400',
                                                        decoration:
                                                            TextDecoration.none,
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: ColorList
                                                            .colorAccent,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: width * 0.05,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5.0),
                                                          child: Text(
                                                            Methods
                                                                .getLowestPrice(
                                                                    events[item]
                                                                        ?.tickets,
                                                                    true),
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'SF_Pro_700',
                                                              decoration:
                                                                  TextDecoration
                                                                      .none,
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: ColorList
                                                                  .colorAccent,
                                                            ),
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        InkWell(
                                                          onTap: () {
                                                            Methods.shareEvent(
                                                                events[item]
                                                                    ?.link);
                                                          },
                                                          child: Icon(
                                                            Icons
                                                                .share_outlined,
                                                            size: 20,
                                                            color: ColorList
                                                                .colorAccent,
                                                          ),
                                                        ),
                                                        SizedBox(width: 10),
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              events[item]
                                                                      ?.userLiked =
                                                                  !events[item]
                                                                      .userLiked;
                                                            });

                                                            ApiCalls.toggleLike(
                                                                    events[item]
                                                                        ?.sId)
                                                                .then((value) {
                                                              if (!value)
                                                                setState(() {
                                                                  events[item]
                                                                      ?.userLiked = !events[
                                                                          item]
                                                                      .userLiked;
                                                                });
                                                            });
                                                          },
                                                          child: Icon(
                                                            (events[item]
                                                                    .userLiked)
                                                                ? Icons.favorite
                                                                : Icons
                                                                    .favorite_outline,
                                                            size: 20,
                                                            color: (events[item]
                                                                    .userLiked)
                                                                ? ColorList
                                                                    .colorRed
                                                                : ColorList
                                                                    .colorAccent,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              padding: EdgeInsets.fromLTRB(
                                                  10.0, 10.0, 10.0, 10.0),
                                            ))
                                      ],
                                    ))
                              ],
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                        )),
                  )),
            ),
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  void backMethod() {
    if (isMap) {
      setState(() {
        isMap = !isMap;
      });
    } else
      Navigator.pop(context);
    /*if(widget.type == 'Reg'){
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Onboarding()),
      );
    }*/
  }

  getMessage() {
    if (countEvent == 0) {
      isMsgShown = true;
      return Container(
          alignment: Alignment.center,
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                  padding: EdgeInsets.only(top: 30),
                  child: Center(
                    child: Text(
                      'No events found',
                      style: TextStyle(
                          fontFamily: 'SF_Pro_900',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: ColorList.colorPrimary,
                          decoration: TextDecoration.none
                      ),
                    ),
                  )
              ),
              const SizedBox(height: 25),
              Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.width * 0.5,
                  child: Image.asset('assets/images/img_astronaut.png')
              ),
              Container(
                  padding: EdgeInsets.only(top: 15),
                  child: Center(
                    child: Text(
                      'No event found in this category!\nTry any other category.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'SF_Pro_900',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: ColorList.colorPrimary,
                          decoration: TextDecoration.none
                      ),
                    ),
                  )
              ),
            ],
          )
      );
    } else {
      return Container();
    }
  }
}
