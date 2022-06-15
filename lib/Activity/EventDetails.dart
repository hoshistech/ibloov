import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ibloov/Activity/SelectTicket.dart';
import 'package:ibloov/Constants/ApiCalls.dart';

import 'package:ibloov/Constants/ColorList.dart';
import 'package:ibloov/Constants/Methods.dart';
import 'package:ibloov/Utils/FestEvents.dart';
import 'package:intl/intl.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'EditProfile.dart';
import 'MultipleDatesOptions.dart';
import 'ReportEvent.dart';

var height, width;

class EventDetails extends StatefulWidget {
  String id;

  EventDetails(this.id);

  @override
  EventDetailsState createState() => EventDetailsState();
}

class EventDetailsState extends State<EventDetails> {
  bool isLoading = true, saved = false;
  bool descTextShowFlag = false;
  var data, more_data, performingArtists;

  double posx = 100.0;
  double posy = 100.0;

  String address = '', location = '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() {
    print(widget.id);

    ApiCalls.fetchEventDetails(context, widget.id).then((value) {
      setState(() {
        if (value != null) {
          data = json.decode(value)['data'];
          performingArtists = data['performingArtists'];

          if (data['location'] != null) {
            if ((data['location']['name'] != null)) {
              address = '${data['location']['name']} ';
            }

            if (data['location']['country'] != null) {
              if ((data['location']['city'] != null)) {
                location = '${data['location']['city']}, ';
              }
              location += '${data['location']['country']} ';
            }
          }
          isLoading = false;
        } else {
          Navigator.pop(context);
        }
      });
    });

    ApiCalls.fetchMoreEvents(context, widget.id).then((value) {
      setState(() {
        if (value != null) {
          more_data = json.decode(value)['data'];
          isLoading = false;
        } else {
          Navigator.pop(context);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return isLoading
        ? Container(
            height: height,
            color: ColorList.colorAccent,
          )
        : Scaffold(
            backgroundColor: ColorList.colorPrimary,
            body: Stack(
              children: [
                WillPopScope(
                  child: RefreshIndicator(
                    color: ColorList.colorSeeAll,
                    child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            // Container(
                            //   height: MediaQuery.of(context).padding.top + 10,
                            //   color: ColorList.colorGray,
                            // ),
                            Container(
                                width: double.infinity,
                                height: height * 0.55,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: isLoading
                                        ? ''
                                        : Methods.getLargeEventCardImage(
                                            data['banner']),
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: height * 0.55,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                            ColorList.colorPrimary
                                                .withOpacity(0.5),
                                            ColorList.colorPrimary
                                                .withOpacity(0.98)
                                          ])),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          height * 0.02,
                                          MediaQuery.of(context).padding.top +
                                              10,
                                          height * 0.02,
                                          0),
                                      child: Column(
                                        children: [
                                          Container(
                                            child: Row(
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Padding(
                                                      child: Icon(
                                                          Icons.arrow_back,
                                                          color: ColorList
                                                              .colorAccent,
                                                          size: 30),
                                                      padding:
                                                          EdgeInsets.all(0.0),
                                                    )),
                                                Spacer(),
                                                InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    onTap: () {
                                                      setState(() {
                                                        data['userLiked'] =
                                                            !data['userLiked'];
                                                      });

                                                      ApiCalls.toggleLike(
                                                              data['_id'])
                                                          .then((value) {
                                                        if (!value)
                                                          setState(() {
                                                            data['userLiked'] =
                                                                !data[
                                                                    'userLiked'];
                                                          });
                                                      });
                                                    },
                                                    child: Icon(
                                                      (data['userLiked'])
                                                          ? Icons.favorite
                                                          : Icons
                                                              .favorite_outline,
                                                      size: 30,
                                                      color: (data['userLiked'])
                                                          ? ColorList.colorRed
                                                          : ColorList
                                                              .colorAccent,
                                                    ))
                                              ],
                                            ),
                                            padding: EdgeInsets.fromLTRB(
                                                5.0,
                                                height * 0.02,
                                                5.0,
                                                height * 0.01),
                                          ),
                                          Spacer(),
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        data['category']
                                                            ['name'],
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'SF_Pro_400',
                                                            color: ColorList
                                                                .colorAccent,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 14),
                                                      ),
                                                      Container(
                                                        width: width * 0.8,
                                                        child: Text(
                                                          data['title'],
                                                          overflow: TextOverflow
                                                              .visible,
                                                          softWrap: true,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'SF_Pro_900',
                                                              color: ColorList
                                                                  .colorAccent,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                              fontSize: 35),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  GestureDetector(
                                                    onTap: () {
                                                      showPopup();
                                                    },
                                                    child: Image.asset(
                                                      "assets/images/more_vert.png",
                                                      height: 25,
                                                      color:
                                                          ColorList.colorAccent,
                                                    ),
                                                    onTapDown: (TapDownDetails
                                                        details) {
                                                      RenderBox box = context
                                                          .findRenderObject();
                                                      Offset localOffset = box
                                                          .globalToLocal(details
                                                              .globalPosition);
                                                      setState(() {
                                                        posx = localOffset.dx;
                                                        posy = localOffset.dy;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                              padding: EdgeInsets.all(5.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                            Container(
                              color: ColorList.colorPrimary,
                              padding: EdgeInsets.fromLTRB(height * 0.02,
                                  height * 0.02, height * 0.02, 0),
                              width: width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            height * 0.01, 0, height * 0.02, 0),
                                        child: Image.asset(
                                          "assets/images/event_date.png",
                                          height: 20,
                                        ),
                                      ),
                                      Text(
                                        DateFormat('EEEE, dd MMM yyyy').format(
                                            DateTime.tryParse(
                                                data['startTime'])),
                                        style: TextStyle(
                                            fontFamily: 'SF_Pro_700',
                                            fontSize: 13.0,
                                            color: ColorList.colorDetails,
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.none),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Icon(
                                          Icons.arrow_drop_down_circle,
                                          size: 4,
                                          color: ColorList.colorDetails,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "${DateFormat('hh.mm a').format(DateTime.tryParse(data['startTime']))} - ${DateFormat('hh.mm a').format(DateTime.tryParse(data['endTime']))}",
                                          style: TextStyle(
                                              fontFamily: 'SF_Pro_700',
                                              fontSize: 13.0,
                                              color: ColorList.colorDetails,
                                              fontWeight: FontWeight.bold,
                                              decoration: TextDecoration.none),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            height * 0.012,
                                            0,
                                            height * 0.022,
                                            0),
                                        child: Image.asset(
                                          "assets/images/event_location.png",
                                          height: 20,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                              width: width - (height * 0.1),
                                              child: Text(
                                                address,
                                                style: TextStyle(
                                                    fontFamily: 'SF_Pro_700',
                                                    fontSize: 15.0,
                                                    color:
                                                        ColorList.colorDetails,
                                                    fontWeight: FontWeight.w700,
                                                    decoration:
                                                        TextDecoration.none),
                                              )),
                                          SizedBox(height: 3),
                                          SizedBox(
                                            width: width - (height * 0.1),
                                            child: Text(
                                              location,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontFamily: 'SF_Pro_400',
                                                  fontSize: 10.0,
                                                  color: ColorList.colorDetails,
                                                  fontWeight: FontWeight.bold,
                                                  decoration:
                                                      TextDecoration.none),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            height * 0.01,
                                            0,
                                            height * 0.015,
                                            0),
                                        child: Image.asset(
                                          "assets/images/event_ticket.png",
                                          height: 20,
                                        ),
                                      ),
                                      Text(
                                        "Starting from ${Methods.getLowestPrice(data['tickets'], false)}",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontFamily: 'SF_Pro_700',
                                            fontSize: 15.0,
                                            color: ColorList.colorDetails,
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.none),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            height * 0.01,
                                            0,
                                            height * 0.015,
                                            0),
                                        child: Image.asset(
                                          "assets/images/event_details.png",
                                          height: 20,
                                        ),
                                      ),
                                      Text(
                                        (data['organizers'] != null &&
                                                data['organizers'].length > 0)
                                            ? data['organizers'][0]['brandName']
                                            : "Brand name not available!",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontFamily: 'SF_Pro_700',
                                            fontSize: 15.0,
                                            color: ColorList.colorDetails,
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.none),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            height * 0.01,
                                            0,
                                            height * 0.015,
                                            0),
                                        child: Image.asset(
                                          "assets/images/event_details.png",
                                          height: 20,
                                        ),
                                      ),
                                      SizedBox(
                                          width: width - (height * 0.1),
                                          child: Text(
                                            getHashtags(),
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontFamily: 'SF_Pro_700',
                                                fontSize: 15.0,
                                                color: ColorList.colorDetails,
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.none),
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.05,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: width,
                              padding: EdgeInsets.all(height * 0.035),
                              decoration: const BoxDecoration(
                                color: ColorList.colorAccent,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Details",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontFamily: 'SF_Pro_900',
                                        fontSize: 18.0,
                                        color: ColorList.colorPrimary,
                                        fontWeight: FontWeight.w900,
                                        decoration: TextDecoration.none,
                                        letterSpacing: 0.35),
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        data['description'],
                                        maxLines: descTextShowFlag ? 15 : 2,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontFamily: 'SF_Pro_400',
                                            fontSize: 13.0,
                                            color: ColorList.colorPrimary
                                                .withOpacity(0.7),
                                            fontWeight: FontWeight.normal,
                                            decoration: TextDecoration.none),
                                      ),
                                      if (data['description'].length > 100)
                                        InkWell(
                                            onTap: () {
                                              setState(() {
                                                descTextShowFlag =
                                                    !descTextShowFlag;
                                              });
                                            },
                                            child: Padding(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  descTextShowFlag
                                                      ? Text(
                                                          "Read Less",
                                                          style: TextStyle(
                                                            color: ColorList
                                                                .colorSeeAll,
                                                            fontFamily:
                                                                'SF_Pro_900',
                                                            fontSize: 14.0,
                                                          ),
                                                        )
                                                      : Text("Read More",
                                                          style: TextStyle(
                                                            color: ColorList
                                                                .colorSeeAll,
                                                            fontFamily:
                                                                'SF_Pro_900',
                                                            fontSize: 14.0,
                                                          ))
                                                ],
                                              ),
                                              padding: EdgeInsets.only(
                                                  top: height * 0.01),
                                            )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.025,
                                  ),
                                  Container(
                                    //padding: EdgeInsets.only(top: 15.0),
                                    child:
                                        (performingArtists == null ||
                                                performingArtists.length == 0)
                                            ? Container()
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: width,
                                                    child: Text(
                                                      "Performing Artists",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'SF_Pro_900',
                                                          fontSize: 18.0,
                                                          color: ColorList
                                                              .colorPrimary,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          decoration:
                                                              TextDecoration
                                                                  .none),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.02,
                                                  ),
                                                  Container(
                                                    height: height * 0.085,
                                                    child: ListView.builder(
                                                        shrinkWrap: true,
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount:
                                                            performingArtists
                                                                .length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                        context,
                                                                    int item) =>
                                                                Column(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Container(
                                                                          margin:
                                                                              EdgeInsets.only(right: 15),
                                                                          width:
                                                                              height * 0.075,
                                                                          height:
                                                                              height * 0.075,
                                                                          child:
                                                                              CachedNetworkImage(
                                                                            imageUrl:
                                                                                performingArtists[item]['imgUrl'] ?? "",
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            imageBuilder: (context, imageProvider) =>
                                                                                Container(
                                                                              decoration: BoxDecoration(
                                                                                shape: BoxShape.circle,
                                                                                image: DecorationImage(image: imageProvider, fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
                                                                              ),
                                                                            ),
                                                                            placeholder: (context, url) =>
                                                                                CircularProgressIndicator(),
                                                                            errorWidget: (context, url, error) =>
                                                                                Image.asset('assets/images/profile.png'),
                                                                          ),
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              performingArtists[item]['name'],
                                                                              textAlign: TextAlign.start,
                                                                              style: TextStyle(fontFamily: 'SF_Pro_900', fontSize: 13.0, color: ColorList.colorPrimary, fontWeight: FontWeight.bold, decoration: TextDecoration.none),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              width * 0.075,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          height *
                                                                              0.01,
                                                                    ),
                                                                  ],
                                                                )),
                                                  )
                                                ],
                                              ),
                                  ),
                                  SizedBox(
                                    height: height * 0.03,
                                  ),
                                  (data['organizers'] != null &&
                                          data['organizers'].length > 0)
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                width: width,
                                                child: Text(
                                                  "Organizers",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      fontFamily: 'SF_Pro_900',
                                                      fontSize: 18.0,
                                                      color: ColorList
                                                          .colorPrimary,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      decoration:
                                                          TextDecoration.none,
                                                      letterSpacing: 0.35),
                                                )),
                                            SizedBox(
                                              height: height * 0.025,
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  width: 50,
                                                  height: 50,
                                                  margin: EdgeInsets.only(
                                                      right: 15),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        (data['organizers'] !=
                                                                    null &&
                                                                data['organizers']
                                                                        .length >
                                                                    0)
                                                            ? data['organizers']
                                                                [0]['imageUrl']
                                                            : null,
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit: BoxFit.cover,
                                                            colorFilter:
                                                                ColorFilter.mode(
                                                                    Colors.red,
                                                                    BlendMode
                                                                        .colorBurn)),
                                                      ),
                                                    ),
                                                    placeholder: (context,
                                                            url) =>
                                                        CircularProgressIndicator(),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        Image.asset(
                                                            'assets/images/profile.png'),
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      (data['organizers'] !=
                                                                  null &&
                                                              data['organizers']
                                                                      .length >
                                                                  0)
                                                          ? data['organizers']
                                                              [0]['brandName']
                                                          : "Brand name not available!",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'SF_Pro_900',
                                                          fontSize: 13.0,
                                                          color: ColorList
                                                              .colorPrimary,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          decoration:
                                                              TextDecoration
                                                                  .none),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  width: height * 0.02,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    if (data['organizers'] !=
                                                            null &&
                                                        data['organizers']
                                                                .length >
                                                            0)
                                                      Methods
                                                          .sendEmailToOrganizer(
                                                              data['organizers']
                                                                  [0]['email'],
                                                              data['link'],
                                                              data['organizers']
                                                                      [0][
                                                                  'brandName']);
                                                  },
                                                  child: Image.asset(
                                                    'assets/images/sms.png',
                                                    color:
                                                        ColorList.colorSeeAll,
                                                    height: 31,
                                                  ),
                                                )
                                              ],
                                            ),
                                            // Padding(
                                            //   padding: EdgeInsets.only(left: height * 0.07),
                                            //   child: Row(
                                            //     children: [
                                            //       Container(
                                            //         child: Card(
                                            //           color: Colors.transparent,
                                            //           elevation: 0.0,
                                            //           child: ClipRect(
                                            //             child: Container(
                                            //               //width: width * 0.3,
                                            //               height: 42.0,
                                            //               decoration: new BoxDecoration(
                                            //                 color: Colors.white,
                                            //                 border: new Border.all(color: ColorList.colorSplashBG, width: 1.0),
                                            //                 borderRadius: new BorderRadius.circular(10.0),
                                            //               ),
                                            //               child: InkWell(
                                            //                 onTap: (){
                                            //                   Methods.showComingSoon();
                                            //                   //Methods.showToast("Following the Organiser...");
                                            //                 },
                                            //                 child: Padding(
                                            //                   padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
                                            //                   child: Row(
                                            //                     children: [
                                            //                       Text(
                                            //                         'Follow',
                                            //                         textAlign: TextAlign.center,
                                            //                         style: TextStyle(
                                            //                           fontFamily: 'SF_Pro_600',
                                            //                           decoration: TextDecoration.none,
                                            //                           fontSize: 15.0,
                                            //                           fontWeight: FontWeight.w600,
                                            //                           color: ColorList.colorSplashBG,
                                            //                         ),
                                            //                       ),
                                            //                     ],
                                            //                   ),
                                            //                 ),
                                            //               ),
                                            //             ),
                                            //           ),
                                            //         ),
                                            //
                                            //       ),
                                            //       Container(
                                            //         width: height * 0.02,
                                            //       ),
                                            //       InkWell(
                                            //         onTap: (){
                                            //           Methods.showComingSoon();
                                            //           //Methods.showToast("Messaging the Organiser...");
                                            //         },
                                            //         child: Image.asset(
                                            //           'assets/images/sms.png',
                                            //           color: ColorList.colorSeeAll,
                                            //           height: 31,
                                            //         ),
                                            //       )
                                            //     ],
                                            //   ),
                                            // ),
                                          ],
                                        )
                                      : Container(),
                                  SizedBox(
                                    height: height * 0.07,
                                  ),
                                  Text(
                                    "Share Events",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontFamily: 'SF_Pro_900',
                                        fontSize: 18.0,
                                        color: ColorList.colorPrimary,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.35,
                                        decoration: TextDecoration.none),
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Row(
                                    children: [
                                      // Container(
                                      //   width: 50.0,
                                      //   height: 50.0,
                                      //   decoration: new BoxDecoration(
                                      //     color: Colors.white,
                                      //     borderRadius: new BorderRadius.circular(10.0),
                                      //     boxShadow: [
                                      //       BoxShadow(
                                      //         color: ColorList.colorPrimary.withOpacity(0.1),
                                      //         blurRadius: 12,
                                      //         offset: Offset(0,4)
                                      //       )
                                      //     ]
                                      //   ),
                                      //   child: InkWell(
                                      //     onTap: () async  {
                                      //       final pref = await SharedPreferences.getInstance();
                                      //       var email = pref.getString('email');
                                      //
                                      //       Methods.shareEmail(email, data['link']);
                                      //     },
                                      //     child: Image.asset(
                                      //       'assets/images/mail_share.png',
                                      //       width: 15.0,
                                      //       height: 15.0,
                                      //     ),
                                      //   ),
                                      // ),
                                      // SizedBox(
                                      //   width: width * 0.04,
                                      // ),
                                      // Container(
                                      //   width: 50.0,
                                      //   height: 50.0,
                                      //   decoration: new BoxDecoration(
                                      //     color: Colors.white,
                                      //       borderRadius: new BorderRadius.circular(10.0),
                                      //       boxShadow: [
                                      //         BoxShadow(
                                      //             color: ColorList.colorPrimary.withOpacity(0.1),
                                      //             blurRadius: 12,
                                      //             offset: Offset(0,4)
                                      //         )
                                      //       ]
                                      //   ),
                                      //   child: InkWell(
                                      //     onTap: (){
                                      //       Methods.shareEvent(data['link']);
                                      //     },
                                      //     child: Image.asset(
                                      //       'assets/images/fb_share.png',
                                      //       width: 15.0,
                                      //       height: 15.0,
                                      //     ),
                                      //   ),
                                      // ),
                                      // SizedBox(
                                      //   width: width * 0.04,
                                      // ),
                                      Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: new BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                new BorderRadius.circular(10.0),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: ColorList.colorPrimary
                                                      .withOpacity(0.1),
                                                  blurRadius: 12,
                                                  offset: Offset(0, 4))
                                            ]),
                                        child: InkWell(
                                          onTap: () {
                                            // Methods.shareTwitter(data['link']);
                                            Methods.shareEvent(data['link']);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Image.asset(
                                              'assets/images/ic_share.png',
                                              width: 15.0,
                                              height: 15.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * 0.04,
                                      ),
                                      Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: new BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                new BorderRadius.circular(10.0),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: ColorList.colorPrimary
                                                      .withOpacity(0.1),
                                                  blurRadius: 12,
                                                  offset: Offset(0, 4))
                                            ]),
                                        child: InkWell(
                                          onTap: () {
                                            Clipboard.setData(ClipboardData(
                                                text: data['link']));
                                            Methods.showToast(
                                                "Link copied to clipboard");
                                          },
                                          child: Image.asset(
                                            'assets/images/link_share.png',
                                            width: 15.0,
                                            height: 15.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.08,
                                  ),
                                  getSimilar(),
                                  SizedBox(
                                    height: height * 0.08,
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                    onRefresh: () {
                      return Future.delayed(
                        Duration(seconds: 1),
                        () {
                          getData();
                        },
                      );
                    },
                  ),
                  onWillPop: () {
                    Navigator.pop(context);
                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: Platform.isIOS ? 100 : 70,
                    decoration: BoxDecoration(
                      color: ColorList.colorAccent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.25),
                          spreadRadius: 5,
                          blurRadius: 8,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${Methods.getLowestPrice(data['tickets'], false)}${Methods.getHighestPrice(data['tickets'])}",
                                  style: TextStyle(
                                      fontFamily: 'SF_Pro_700',
                                      color: ColorList.colorGray,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                /*Text(
                                "Get ticket now on early bird",
                                style: TextStyle(
                                  fontFamily: 'SF_Pro_400',
                                  color: ColorList.colorGray,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10
                                ),
                              ),*/
                                const SizedBox(height: 5),
                                Text.rich(TextSpan(
                                    text: "Sales end: ",
                                    style: TextStyle(
                                        fontFamily: 'SF_Pro_400',
                                        color: ColorList.colorGray,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10),
                                    children: [
                                      TextSpan(
                                        text: "${getSaleEnd()}",
                                        style: TextStyle(
                                            fontFamily: 'SF_Pro_400',
                                            color: ColorList.colorGray,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 10),
                                      )
                                    ]))
                              ],
                            ),
                            Spacer(),
                            MaterialButton(
                              color: ColorList.colorSplashBG,
                              minWidth: width * 0.4,
                              height: 50.0,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                              elevation: 3.0,
                              onPressed: () {
                                Methods.getProfileCompleteStatus()
                                    .then((complete) {
                                  setState(() {
                                    if (complete) {
                                      var festEvent = FestEvents(
                                          data['_id'],
                                          data['startTime'],
                                          DateFormat('yyyy').format(DateTime.tryParse(data['startTime'])),
                                          DateFormat('MMM').format(DateTime.tryParse(data['startTime'])),
                                          DateFormat('dd').format(DateTime.tryParse(data['startTime'])),
                                          DateFormat('EEEE').format(DateTime.tryParse(data['startTime'])),
                                          DateFormat('hh.mm a')
                                              .format(DateTime.tryParse(data['startTime'])),
                                          data['location']['name'],
                                          data['location']['address'],
                                          Methods.getLowestPrice(data['tickets'], false));

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SelectTicket(
                                                  data["_id"],
                                                  data["title"],
                                                  "${(data['organizers'] != null && data['organizers'].length > 0) ? data['organizers'][0]['brandName'] : "Brand name not available!"}",
                                                  festEvent)));
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) =>
                                      //           MultipleDatesOptions(data)),
                                      // );
                                    } else {
                                      Methods.showCompleteDialog(
                                          context, height, width, true);
                                    }
                                  });
                                });
                              },
                              child: Text(
                                'Buy tickets',
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
                      ],
                    ),
                    padding: EdgeInsets.fromLTRB(
                        14.0, 10, 14, Platform.isIOS ? 15 : 5),
                  ),
                )
              ],
            ),
          );
  }

  Future<void> showPopup() async {
    var _selectedSettingsMenuOptions = await showMenu(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      position: RelativeRect.fromLTRB(width, posy, 0.0, 0.0),
      items: [
        PopupMenuItem(
          height: 35,
          value: 0,
          child: Text(
            "Add event to calendar",
            style: TextStyle(
                fontFamily: 'SF_Pro_400',
                color: ColorList.colorPrimary,
                fontWeight: FontWeight.normal,
                fontSize: 15),
          ),
        ),
        /*PopupMenuItem(
          height: 35,
          value: 1,
          child: Text(
            "Remove event from calendar",
            style: TextStyle(
              fontFamily: 'SF_Pro_400',
              color: ColorList.colorPrimary,
              fontWeight: FontWeight.normal,
              fontSize: 15
            ),
          ),
        ),*/
        PopupMenuItem(
          height: 35,
          value: 2,
          child: Text(
            "Report event",
            style: TextStyle(
                fontFamily: 'SF_Pro_400',
                color: ColorList.colorPrimary,
                fontWeight: FontWeight.normal,
                fontSize: 15),
          ),
        ),
      ],
      elevation: 8.0,
    );

    if (_selectedSettingsMenuOptions != null) {
      String msg;
      if (_selectedSettingsMenuOptions == 0) {
        msg = "Added event to calendar";
        final Event event = Event(
          title: data['title'],
          description: data['description'],
          location: '$address, $location',
          startDate: DateTime.tryParse(data['startTime']),
          endDate: DateTime.tryParse(data['endTime']),
          /*iosParams: IOSParams(
            reminder: Duration(/* Ex. hours:1 */), // on iOS, you can set alarm notification after your event.
          ),
          androidParams: AndroidParams(
            emailInvites: [], // on Android, you can add invite emails to your event.
          ),*/
        );
        Add2Calendar.addEvent2Cal(event);
      } else if (_selectedSettingsMenuOptions == 1) {
        msg = "Removed event from calendar";
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ReportEvent(widget.id)),
        );
      }
    }
  }

  getSaleEnd() {
    var tickets = data['tickets'];
    // debugPrint("Last ticket: ${tickets[tickets.length - 1]['salesEnd']}");
    debugPrint("ticket length: ${tickets.length}");
    debugPrint("tickets: ${data["_id"]}");

    return (tickets.length > 0 &&
            tickets[tickets.length - 1]['salesEnd'] != null)
        ? DateFormat('dd MMM yyyy')
            .format(DateTime.tryParse(tickets[tickets.length - 1]['salesEnd']))
        : 'N/A';
  }

  getGenres(int item) {
    String genres = '';
    var list = performingArtists[item]['genre'];

    for (int i = 0; i < list.length; i++) {
      genres += list[i] + ', ';
    }

    return genres.substring(0, genres.length - 2);
  }

  getSimilar() {
    if (more_data != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "More like this",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontFamily: 'SF_Pro_900',
              fontSize: 18.0,
              color: ColorList.colorPrimary,
              fontWeight: FontWeight.w900,
              decoration: TextDecoration.none,
              letterSpacing: 0.35,
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          Container(
            //padding: EdgeInsets.only(top: 15.0),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              // shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: more_data.length,
              itemBuilder: (BuildContext context, int item) => Card(
                  elevation: 0.0,
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Methods.openEventDetails(context, more_data[item]['_id']);
                    },
                    child: Container(
                        padding: EdgeInsets.only(left: 0.0),
                        margin: EdgeInsets.zero,
                        color: ColorList.colorAccent,
                        child: Container(
                          padding: (item == 2)
                              ? EdgeInsets.only(right: 10.0)
                              : EdgeInsets.zero,
                          child: ClipRRect(
                            child: Stack(
                              children: [
                                // Container(
                                //   width: width * 0.6,
                                //   height: width * 0.5,
                                //   child: Center(
                                //       child: CircularProgressIndicator(
                                //         color: ColorList.colorSplashBG,
                                //         strokeWidth: 3.0,
                                //       )
                                //   ),
                                //   decoration: BoxDecoration(
                                //     /*border: Border.all(color: ColorList.colorSplashBG, width: 2.0),
                                //     borderRadius: BorderRadius.all(Radius.circular(10.0),),*/
                                //       color: ColorList.colorMenuItem
                                //   ),
                                // ),
                                Container(
                                    width: width * 0.6,
                                    height: width * 0.7,
                                    child: Container(
                                      height: width * 0.5,
                                      color: ColorList.colorPrimary
                                          .withOpacity(0.7),
                                    ),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: Methods.getSmallEventCardImage(
                                            more_data[item]['banner'] ?? ""),
                                      ),
                                    )),
                                Container(
                                    width: width * 0.6,
                                    height: width * 0.7,
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
                                                                  (more_data[item]
                                                                              [
                                                                              'startTime'] ==
                                                                          null)
                                                                      ? '01'
                                                                      : DateFormat(
                                                                              'dd')
                                                                          .format(DateTime.tryParse(more_data[item]
                                                                              [
                                                                              'startTime'])),
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
                                                                    color: (more_data[item]['startTime'] ==
                                                                            null)
                                                                        ? ColorList
                                                                            .colorAccent
                                                                        : ColorList
                                                                            .colorPrimary,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  (more_data[item]
                                                                              [
                                                                              'startTime'] ==
                                                                          null)
                                                                      ? 'JAN'
                                                                      : DateFormat(
                                                                              'MMM')
                                                                          .format(DateTime.tryParse(more_data[item]
                                                                              [
                                                                              'startTime']))
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
                                                                    color: (more_data[item]['startTime'] ==
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
                                                      /*SizedBox(
                                                            width: width* 0.45,
                                                          ),
                                                          Card(
                                                              color: ColorList.colorPrimary,
                                                              elevation: 0.0,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(25.0),
                                                              ),
                                                              child: Padding(
                                                                child: Text(
                                                                  (more_data[item]['noOfRegistrations'] > 99) ? '99+' : '${more_data[item]['noOfRegistrations']}',
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                    fontFamily: 'SF_Pro_700',
                                                                    decoration: TextDecoration.none,
                                                                    fontSize: 20.0,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: ColorList.colorAccent,
                                                                  ),
                                                                ),
                                                                padding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
                                                              )
                                                          ),*/
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: width * 0.05,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 5.0),
                                                    child: Text(
                                                      more_data[item]
                                                          ['category']['name'],
                                                      textAlign:
                                                          TextAlign.center,
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
                                                    height: width * 0.005,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 5.0),
                                                    child: Text(
                                                      more_data[item]['title'],
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'SF_Pro_700',
                                                        decoration:
                                                            TextDecoration.none,
                                                        fontSize: 20.0,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                      '${(more_data[item]['location']['name'] != null) ? '${more_data[item]['location']['name']}, ' : ''}${more_data[item]['location']['city']}',
                                                      //textAlign: TextAlign.center,
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
                                                    height: width * 0.03,
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5.0),
                                                        child: Text(
                                                          Methods.getLowestPrice(
                                                              more_data[item]
                                                                  ['tickets'],
                                                              true),
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'SF_Pro_700',
                                                            decoration:
                                                                TextDecoration
                                                                    .none,
                                                            fontSize: 12.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: ColorList
                                                                .colorAccent,
                                                          ),
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      InkWell(
                                                        onTap: () {
                                                          Methods.shareEvent(
                                                              more_data[item]
                                                                  ['link']);
                                                        },
                                                        child: Icon(
                                                          Icons.share_outlined,
                                                          size: 20,
                                                          color: ColorList
                                                              .colorAccent,
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            more_data[item][
                                                                    'userLiked'] =
                                                                !more_data[item]
                                                                    [
                                                                    'userLiked'];
                                                          });
                                                        },
                                                        child: Icon(
                                                          (more_data[item]
                                                                  ['userLiked'])
                                                              ? Icons.favorite
                                                              : Icons
                                                                  .favorite_outline,
                                                          size: 20,
                                                          color: (more_data[
                                                                      item]
                                                                  ['userLiked'])
                                                              ? ColorList
                                                                  .colorRed
                                                              : ColorList
                                                                  .colorAccent,
                                                        ),
                                                      ),
                                                    ],
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
                        ) /*CachedNetworkImage(
                                              imageUrl: image[item],
                                              placeholder: (context, url) => Center(
                                                child: Container(
                                                  child: CircularProgressIndicator(
                                                    valueColor:
                                                    AlwaysStoppedAnimation<Color>(
                                                      ColorList.colorMenuItemChecked,
                                                    ),
                                                    strokeWidth: 2,
                                                  ),
                                                  height: 35,
                                                  width: 35,
                                                ),
                                              ),
                                              imageBuilder: (context, imageProvider) =>
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.fitWidth,
                                                      ),
                                                    ),
                                                  ),
                                              errorWidget: (context, url, error) =>
                                                  Icon(Icons.error),
                                            ),*/
                        ),
                  )),
            ),
            height: 200.0,
          ),
          Container(
            height: 50.0,
          )
        ],
      );
    } else {
      return Container(
        height: 50.0,
      );
    }
  }

  String getHashtags() {
    String hashtag = "";

    var tagsJson = data['hashtags'];
    List<String> tags = tagsJson != null ? List.from(tagsJson) : null;

    if (tags.length > 0) {
      hashtag = "#${tags.elementAt(0)}";
      for (int i = 1; i < tags.length; i++) {
        hashtag += ", #${tags.elementAt(i)}";
      }
    }
    return hashtag;
  }
}
