import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ibloov/Constants/ApiCalls.dart';

import 'package:ibloov/Constants/ColorList.dart';
import 'package:ibloov/Constants/Methods.dart';

import 'package:ibloov/Utils/FestEvents.dart';
import 'package:intl/intl.dart';

import 'SelectTicket.dart';

class MultipleDatesOptions extends StatefulWidget {
  var data;

  MultipleDatesOptions(this.data);

  @override
  _MultipleDatesOptionsState createState() => _MultipleDatesOptionsState();
}

class _MultipleDatesOptionsState extends State<MultipleDatesOptions> {
  var height, width;

  bool saved = false;

  var festName = '';
  var organiser = '';

  List<FestEvents> events = [];

  @override
  void initState() {
    festName = widget.data['title'];
    organiser = (widget.data['organizers'] != null &&
            widget.data['organizers'].length > 0)
        ? widget.data['organizers'][0]['brandName']
        : "Brand name not available!";

    events.add(FestEvents(
        widget.data['_id'],
        widget.data['startTime'],
        DateFormat('yyyy').format(DateTime.tryParse(widget.data['startTime'])),
        DateFormat('MMM').format(DateTime.tryParse(widget.data['startTime'])),
        DateFormat('dd').format(DateTime.tryParse(widget.data['startTime'])),
        DateFormat('EEEE').format(DateTime.tryParse(widget.data['startTime'])),
        DateFormat('hh.mm a')
            .format(DateTime.tryParse(widget.data['startTime'])),
        widget.data['location']['name'],
        widget.data['location']['address'],
        Methods.getLowestPrice(widget.data['tickets'], false)));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    var orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.landscape) {
      height = 2.15 * height;
    }
    return Scaffold(
      backgroundColor: ColorList.colorPrimary,
      body: WillPopScope(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: height * 0.45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: Methods.getImage(
                              widget.data['banner'], 'placeholder'),
                          //NetworkImage(.data['banner']),
                          fit: BoxFit.cover)),
                  //padding: EdgeInsets.only(top: 10),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: height * 0.45,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                              ColorList.colorPrimary.withOpacity(0.5),
                              ColorList.colorPrimary.withOpacity(0.98)
                            ])),
                      ),
                      Column(
                        children: [
                          Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Padding(
                                          child: Icon(Icons.arrow_back,
                                              color: ColorList.colorAccent,
                                              size: 30),
                                          padding: EdgeInsets.all(0.0),
                                        )),
                                    Spacer(),
                                    InkWell(
                                        splashColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        onTap: () {
                                          setState(() {
                                            widget.data['userLiked'] =
                                                !widget.data['userLiked'];
                                          });

                                          ApiCalls.toggleLike(
                                                  widget.data['_id'])
                                              .then((value) {
                                            if (!value)
                                              setState(() {
                                                widget.data['userLiked'] =
                                                    !widget.data['userLiked'];
                                              });
                                          });
                                        },
                                        child: Icon(
                                          (widget.data['userLiked'])
                                              ? Icons.favorite
                                              : Icons.favorite_outline,
                                          size: 30,
                                          color: (widget.data['userLiked'])
                                              ? ColorList.colorRed
                                              : ColorList.colorAccent,
                                        ))
                                  ],
                                ),
                              ],
                            ),
                            padding: EdgeInsets.fromLTRB(
                                height * 0.02 + 5.0,
                                MediaQuery.of(context).padding.top + 12,
                                height * 0.02 + 5.0,
                                height * 0.01),
                          ),
                          Container(
                            height: height * 0.2,
                          ),
                          Container(
                              padding: EdgeInsets.only(left: 25),
                              alignment: Alignment.topLeft,
                              // padding: EdgeInsets.only(top:10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    festName,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30),
                                  ),
                                  Container(
                                    height: height * 0.01,
                                  ),
                                  Text(
                                    organiser,
                                    style: TextStyle(
                                        color: Colors.white60, fontSize: 10),
                                  ),
                                  Container(
                                    height: height * 0.01,
                                  ),
                                  ratingWidget(3.6, 2500)
                                ],
                              )),
                        ],
                      )
                    ],
                  )),
              SizedBox(height: height * 0.02),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text("Select day(s) to purchase ticket for",
                    style: TextStyle(
                        color: ColorList.colorDetails,
                        fontWeight: FontWeight.w700,
                        fontSize: 13)),
              ),
              SizedBox(height: height * 0.01),
              Container(
                height: height * 0.33 + 20,
                padding: EdgeInsets.only(top: 15, bottom: 5),
                color: Colors.black,
                child: horizontalScroll(),
              ),
              SizedBox(height: height * 0.04),
            ],
          ),
        ),
        onWillPop: () {
          Navigator.pop(context);
          return null;
        },
      ),
    );
  }

  Widget horizontalScroll() {
    var _width = width * 0.6;
    var _height = height * 0.33;

    return ListView.separated(
      shrinkWrap: false,
      addRepaintBoundaries: false,
      physics: BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder:(context) =>
                        SelectTicket(
                            events[index].id,
                            festName,
                            organiser,
                            events[index]
                        )
                )
            );
          },
          child: ClipPath(
            clipper:
                TicketClipper(right: _width * 0.45, holeRadius: _width * 0.1),
            child: Container(
              width: _width,
              height: _height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(children: [
                Container(
                  height: _height * 0.8,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 15.0, left: 15, right: 15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              alignment: Alignment.center,
                              // padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.grey[350],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(events[index].month,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey[500])),
                                    Flexible(
                                      child: Text(events[index].date,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                  ]),
                            ),
                            Container(
                              width: _width * 0.05,
                            ),
                            Flexible(
                              child: Text(
                                events[index].day,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Divider(),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image(
                              image: AssetImage(
                                "assets/images/calendar.png",
                              ),
                              width: 20,
                              height: 20,
                              fit: BoxFit.fitWidth,
                            ),
                            Text("   "),
                            Text(events[index].time,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600]))
                          ],
                        ),
                        Container(
                          height: height * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.where_to_vote,
                              color: Colors.grey[500],
                              size: 24,
                            ),
                            Text("  "),
                            Expanded(
                              child: Text(events[index].address1,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600])),
                            ),
                          ],
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: [
                        //     Container(
                        //       width: _width * 0.10,
                        //     ),
                        //     Text("   "),
                        //     Expanded(
                        //       child: Text(events[index].address2,
                        //           style: TextStyle(
                        //               fontSize: 8,
                        //               fontWeight: FontWeight.bold,
                        //               color: Colors.grey[600])),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: _height * 0.2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      gradient: LinearGradient(
                          begin: const Alignment(0.0, 0.9),
                          end: const Alignment(0.6, 0.0),
                          colors: [Color(0xFF00237B), Color(0xFF4272ED)])),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Start from ",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      Text(events[index].rate,
                          style: TextStyle(
                              fontFamily: 'SF_Pro_700',
                              color: Colors.white,
                              fontSize: 12)),
                      Text(" "),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        );
      },
      // separatorBuilder: separatorBuilder,
      itemCount: events.length,
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: 25, right: 25),

      separatorBuilder: (BuildContext context, int index) {
        return Container(
          width: 15,
        );
      },
    );
  }

  Widget ratingWidget(double rating, int totalReviews) {
    return Row(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RatingBarIndicator(
              rating: rating,
              itemBuilder: (context, index) => Icon(
                Icons.star,
                color: Colors.white,
              ),
              itemCount: 5,
              itemSize: 20.0,
              unratedColor: Colors.amber.withAlpha(100),
              direction: Axis.horizontal,
            ),
          ],
        ),
        Container(
          width: width * 0.05,
        ),
        Row(
          children: [
            Text(
              totalReviews.toString(),
              style: TextStyle(color: Colors.white60),
            ),
            Text(
              " Reviews",
              style:
                  TextStyle(color: Colors.white60, fontWeight: FontWeight.bold),
            )
          ],
        )
      ],
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  TicketClipper({@required this.right, @required this.holeRadius});

  final double right;
  final double holeRadius;

  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width - right - holeRadius, 0.0)
      ..arcToPoint(Offset(size.width - right, 0),
          clockwise: false, radius: Radius.circular(1))
      ..lineTo(size.width, 0.0)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width - right, size.height)
      ..arcToPoint(Offset(size.width - right - holeRadius, size.height),
          clockwise: false, radius: Radius.circular(1));
    path.lineTo(0.0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
