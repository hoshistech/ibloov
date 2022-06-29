import 'dart:convert';

import 'package:fdottedline/fdottedline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ibloov/Constants/ApiCalls.dart';
import 'package:ibloov/Constants/Methods.dart';
import 'package:intl/intl.dart';

import 'package:ibloov/Constants/ColorList.dart';

import 'Home.dart';

class TicketQRCode extends StatefulWidget {
  String _id;
  bool purchase;
  TicketQRCode(this._id, this.purchase);


  @override
  _TicketQRCodeState createState() => _TicketQRCodeState();
}

class _TicketQRCodeState extends State<TicketQRCode> {
  var height, width;
  bool isLoading = true;
  var data, tickets;
  var terms =
      "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";

  @override
  void initState() {
    /*festId=widget.festId;
    orderID=widget.transactionId;
    tickets = widget.tickets;
    events[1] = FestEvents(1, "2021", "Jan", "01", "Saturday", "6:30pm",
        "Eko Hotel Convention Hall", "Victoria Island,Lagos,Nigeria", "20");
    events[2] = FestEvents(2, "2021", "Jan", "02", "Saturday", "7:30pm",
        "Eko Hotel Convention Hall", "Victoria Island,Lagos,Nigeria", "20");
    events[3] = FestEvents(3, "2021", "Jan", "03", "Sunday", "7:30pm",
        "Federal Palace Hotel", "Victoria Island,Lagos,Nigeria", "30");*/

    ApiCalls.getTickets(widget._id)
        .then((value){
      if(value != null){
        print('Fetch Event Tickets: $value');
        data = json.decode(value)['data'][0];
        tickets = data['tickets'];
        print('Fetch Event Tickets Data: ${tickets[0]['ticket']}');
        print('Fetch Event Tickets Data Length: ${tickets.length}');

        setState(() {
          isLoading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    print("Event ID: ${widget._id}");
    print("purchase: ${widget.purchase}");

    return  (isLoading)
        ? Container(
            color: ColorList.colorAccent,
            child: Center(
              child: CircularProgressIndicator(
                color: ColorList.colorSeeAll,
              ),
            ),
          )
        : SafeArea(
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                backgroundColor: Colors.transparent,
                centerTitle: true,
                flexibleSpace: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: height * 0.04, left: height * 0.03),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back, color: ColorList.colorBack),
                        )
                      ),
                    ),
                    Spacer(),
                    (!widget.purchase)
                        ? Container(width: 0)
                        : GestureDetector(
                            onTap: () {
                              Methods.openEventDetails(context, widget._id);
                            },
                            child: Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(top: height * 0.04, right: height * 0.03),
                              child: Text(
                                "See the Event",
                                style: TextStyle(
                                  fontFamily: 'SF_Pro_700',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: ColorList.colorSearchListMore,
                                ),
                              ),
                            ),
                          ),
                  ],
                )
              ),
              body: Container(
                height: (!widget.purchase) ? height * 0.75 : height * 0.9,
                color: ColorList.colorAccent,
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(left: 15),
                margin: EdgeInsets.symmetric(vertical: height * 0.03),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: (!widget.purchase) ? height * 0.75 : height * 0.8,
                        child: ListView.builder(
                          physics: ClampingScrollPhysics(),
                          // shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: tickets.length,
                          itemBuilder: (BuildContext context, int item) =>
                              SingleChildScrollView(
                                child: Container(
                                  margin: EdgeInsets.all(height * 0.015),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: ColorList.colorTicketBG,
                                    borderRadius: BorderRadius.circular(height * 0.015),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        //height: 1000,
                                        width: width * 0.85,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: Padding(
                                                padding: EdgeInsets.only(top: height * 0.02),
                                                child: Container(
                                                  width: height * 0.15,
                                                  height: height * 0.15,
                                                  decoration: BoxDecoration(color: ColorList.colorAccent),
                                                  child: Image.memory(base64Decode(tickets[item]['qrcode'].split(',')[1]))
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(vertical: height * 0.02, horizontal: 15),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "Order ID",
                                                          style: TextStyle(
                                                            fontFamily: 'SF_Pro_600',
                                                            fontSize: 14.0,
                                                            fontWeight: FontWeight.normal,
                                                            color: ColorList.colorGray
                                                          ),
                                                        ),
                                                        Text(
                                                          tickets[item]['orderRef'],
                                                          style: TextStyle(
                                                            fontFamily: 'SF_Pro_900',
                                                            fontSize: 14.0,
                                                            fontWeight: FontWeight.bold,
                                                            color: ColorList.colorPrimary
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "Ticket Type",
                                                          style: TextStyle(
                                                            fontFamily: 'SF_Pro_600',
                                                            fontSize: 14.0,
                                                            fontWeight: FontWeight.normal,
                                                            color: ColorList.colorGray
                                                          ),
                                                        ),
                                                        Text(
                                                          Methods.allWordsCapitalize(tickets[item]['ticket']['type']),
                                                          style: TextStyle(
                                                            fontFamily: 'SF_Pro_900',
                                                            fontSize: 14.0,
                                                            fontWeight: FontWeight.bold,
                                                            color: ColorList.colorPrimary
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "Status",
                                                          style: TextStyle(
                                                            fontFamily: 'SF_Pro_600',
                                                            fontSize: 14.0,
                                                            fontWeight: FontWeight.normal,
                                                            color: ColorList.colorGray
                                                          ),
                                                        ),
                                                        Text(
                                                          Methods.allWordsCapitalize(tickets[item]['status'].replaceAll('_', ' ')),
                                                          style: TextStyle(
                                                            fontFamily: 'SF_Pro_900',
                                                            fontSize: 14.0,
                                                            fontWeight: FontWeight.bold,
                                                            color: ColorList.colorPrimary
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.symmetric(vertical: height * 0.025),
                                              height: height * 0.075,
                                              child: Stack(
                                                children: [
                                                  Center(
                                                    child: FDottedLine(
                                                      color: ColorList.colorHeaderOpaque,
                                                      width: width * 0.85,
                                                      strokeWidth: 2.0,
                                                      dottedLength: 8.0,
                                                      space: 2.0,
                                                    ),
                                                  ),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                                    children: [
                                                      Container(
                                                        height: height * 0.075,
                                                        width: height * 0.04,
                                                        decoration: BoxDecoration(
                                                          color: ColorList.colorAccent,
                                                          shape: BoxShape.rectangle,
                                                          borderRadius: BorderRadius.horizontal(
                                                            right: Radius.circular(height * 0.075),
                                                          ),
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Container(
                                                        height: height * 0.075,
                                                        width: height * 0.04,
                                                        decoration: BoxDecoration(
                                                          color: ColorList.colorAccent,
                                                          shape: BoxShape.rectangle,
                                                          borderRadius: BorderRadius.horizontal(
                                                            left: Radius.circular(height * 0.075),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              )
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(height * 0.02),
                                              child: Text(
                                                data['title'],
                                                style: TextStyle(
                                                  fontFamily: 'SF_Pro_900',
                                                  fontSize: 27.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: ColorList.colorGray
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: width * 0.85,
                                              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                                              margin: EdgeInsets.only(top: height * 0.02),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Container(
                                                    width: width * 0.85 * 0.6,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "Date",
                                                          style: TextStyle(
                                                              fontFamily: 'SF_Pro_700',
                                                              fontSize: 13.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: ColorList.colorPrimary
                                                          ),
                                                        ),
                                                        Text(
                                                          DateFormat('EEEE, dd MMM yyyy').format(DateTime.tryParse(data['startTime'])),
                                                          style: TextStyle(
                                                              fontFamily: 'SF_Pro_700',
                                                              fontSize: 13.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: ColorList.colorDetails
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: width * 0.85 * 0.3,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "Time",
                                                          style: TextStyle(
                                                            fontFamily: 'SF_Pro_700',
                                                            fontSize: 13.0,
                                                            fontWeight: FontWeight.bold,
                                                            color: ColorList.colorPrimary
                                                          ),
                                                        ),
                                                        Text(
                                                          DateFormat('hh.mm a').format(DateTime.tryParse(data['startTime'])),
                                                          style: TextStyle(
                                                            fontFamily: 'SF_Pro_700',
                                                            fontSize: 13.0,
                                                            fontWeight: FontWeight.bold,
                                                            color: ColorList.colorDetails
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: height * 0.02),
                                            Container(
                                              width: width * 0.85,
                                              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                                              margin: EdgeInsets.only(bottom: height * 0.02),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: width * 0.85 * 0.6,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "Location",
                                                          style: TextStyle(
                                                            fontFamily: 'SF_Pro_700',
                                                            fontSize: 13.0,
                                                            fontWeight: FontWeight.bold,
                                                            color: ColorList.colorPrimary
                                                          ),
                                                        ),
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              data['location']['name'],
                                                              textAlign: TextAlign.start,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                fontFamily: 'SF_Pro_700',
                                                                fontSize: 15.0,
                                                                fontWeight: FontWeight.bold,
                                                                color: ColorList.colorDetails
                                                              ),
                                                            ),
                                                            Text(
                                                              data['location']['address'],
                                                              textAlign: TextAlign.start,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                fontFamily: 'SF_Pro_400',
                                                                fontSize: 11.0,
                                                                fontWeight: FontWeight.bold,
                                                                color: ColorList.colorDetails
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: width * 0.85 * 0.3,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          width: width * 0.06,
                                                          child: Image(
                                                            image: AssetImage("assets/images/ticket.png"),
                                                            fit: BoxFit.cover,
                                                            color: Colors.black,
                                                            colorBlendMode:
                                                            BlendMode.modulate,
                                                          ),
                                                        ),
                                                        SizedBox(height: height * 0.01),
                                                        Text(
                                                          tickets[item]['ticket']['name'],
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            fontFamily: 'SF_Pro_700',
                                                            fontSize: 13.0,
                                                            fontWeight: FontWeight.bold,
                                                            color: ColorList.colorDetails
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: width * 0.85,
                                              padding: EdgeInsets.all(height * 0.02),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Terms & Conditions",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15
                                                    )
                                                  ),
                                                  Text(
                                                    //terms,
                                                    data['terms'],
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.grey[600],
                                                      fontSize: 12
                                                    )
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                        ),
                      ),
                    ],
                  ),
                )
              ),
              bottomSheet: getBottomSheet(),
            ),
          );
  }

  getBottomSheet() {
    Widget bottomSheet = new Container(height: 0);

    if(!widget.purchase){
      bottomSheet = Container(
        height: height * 0.1,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: ColorList.colorAccent,
          boxShadow: [
            BoxShadow(
              color: ColorList.colorHeaderOpaque,
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: width * 0.8,
              height: height * 0.07,
              child: MaterialButton(
                color: ColorList.colorSplashBG,
                height: 50.0,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                elevation: 5.0,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Home()
                      ),
                      ModalRoute.withName("/Home")
                  );
                },
                child: Text(
                  "Back to Events List",
                  style: TextStyle(
                    fontFamily: 'SF_Pro_600',
                    decoration: TextDecoration.none,
                    fontSize: 15.0,
                    fontWeight: FontWeight.normal,
                    color: ColorList.colorAccent,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }

    return bottomSheet;
  }

  /*String getTotalTicketCount() {
    var ticket = json.decode(widget.data)['tickets'];
    var count = 0;

    for(int i=0; i<ticket.length; i++){
      count += json.decode(widget.data)['tickets'][i]['quantity'];
    }

    return '$count';
  }*/
}

class CustomRect extends CustomClipper<Rect>{
  @override
  Rect getClip(Size size) {
    Rect rect = Rect.fromLTRB(0.0, 0.0, -size.width, size.height);
    return rect;
  }

  @override
  bool shouldReclip(CustomRect oldClipper) {
    return false;
  }
}

class PurchasedTicketClipper extends CustomClipper<Path> {
  PurchasedTicketClipper({@required this.top, @required this.holeRadius});
  final double top;
  final double holeRadius;

  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(0.0, size.height - top - holeRadius)
      ..arcToPoint(
          Offset(
              0,
              size.height - top
          ),
          clockwise: true,
          radius: Radius.circular(1)
      )
      ..lineTo(0.0, size.height)
      ..lineTo(
        size.width,
        size.height,
      )
      ..lineTo(size.width, size.height - top)
      ..arcToPoint(
          Offset(
            size.width,
            size.height - top - holeRadius,
          ),
          clockwise: true,
          radius: Radius.circular(1)
      );

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
