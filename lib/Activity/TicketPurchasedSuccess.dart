import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';

import 'package:ibloov/Constants/ColorList.dart';
import 'package:ibloov/Constants/Methods.dart';

import 'package:ibloov/Utils/FestEvents.dart';
import 'package:intl/intl.dart';

import 'Home.dart';
import 'TicketQRCode.dart';

final fullnameController = TextEditingController();
final emailController = TextEditingController();

FocusNode fullnameFocusNode = new FocusNode();
FocusNode emailFocusNode = new FocusNode();

class TicketPurchasedSuccess extends StatefulWidget {
  final String data;
  List tickets;
  FestEvents events;

  TicketPurchasedSuccess(this.data);

  @override
  _TicketPurchasedSuccessState createState() => _TicketPurchasedSuccessState();
}

class _TicketPurchasedSuccessState extends State<TicketPurchasedSuccess> {
  var height, width;
  var festId;
  var regularCount = 2;
  var vipCount = 2;
  var vvipCount = 2;
  String transactionId, totalCost;
  var colors = [Colors.blue, Colors.red, Colors.green];

  @override
  void initState() {
    transactionId = json.decode(widget.data)['transactionId'];
    getCost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    var orientation=MediaQuery.of(context).orientation;
    if(orientation==Orientation.landscape){
      height=2.15*height;
    } 

    print('Purchased data: ${json.decode(widget.data)}');

    return Scaffold(
      body: Container(
        height: height * 0.9,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: height * 0.1,
              ),
              Container(
                width: width * 0.15,
                child: Image(
                    image: AssetImage("assets/images/check.png"),
                    fit: BoxFit.cover),
              ),
              Container(
                //width: width * 0.3,
                padding: EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    Text(
                      "Ticket purchased\nsuccessfully",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'SF_Pro_900',
                        decoration: TextDecoration.none,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: ColorList.colorPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Wrap(
                  children: [
                    Container(
                    // height: height * 0.6,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: ColorList.colorTicketBG,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 20.0, left: 20, right: 20,bottom: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Transactional ID",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.grey[700]),
                                  ),
                                  Text(
                                    transactionId,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.black),
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Total Paid",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.grey[700]),
                                  ),
                                  Text(
                                    totalCost,
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.black),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Container(
                            height: height * 0.05,
                          ),
                          Text(
                            "Tickets",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.grey[700]),
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: json.decode(widget.data)['tickets'].length,
                              itemBuilder: (BuildContext context, int item) =>
                                  generateMyTickets(
                                      json.decode(widget.data)['tickets'][item]['name'],
                                      json.decode(widget.data)['tickets'][item]['quantity'],
                                      colors[item % 3]
                                  )
                          ),
                          Container(
                            height: height * 0.02,
                          ),
                          Text(
                            "Event Details",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.grey[700]),
                          ),
                          Text(
                            json.decode(widget.data)['event']['title'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 28),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, height * 0.01, 0),
                                child: Image.asset(
                                  "assets/images/calendar.png",
                                  height: 15,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                DateFormat('EEEE, dd MMM yyyy').format(DateTime.tryParse(json.decode(widget.data)['event']['startTime'])),
                                style: TextStyle(
                                    fontFamily: 'SF_Pro_700',
                                    fontSize: 12.0,
                                    color: ColorList.colorDetails,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Icon(
                                  Icons.arrow_drop_down_circle,
                                  size: 4,
                                  color: ColorList.colorDetails,
                                ),
                              ),
                              Text(
                                DateFormat('hh.mm a').format(DateTime.tryParse(json.decode(widget.data)['event']['startTime'])),
                                style: TextStyle(
                                    fontFamily: 'SF_Pro_700',
                                    fontSize: 12.0,
                                    color: ColorList.colorDetails,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.where_to_vote,
                                  color: Colors.grey[600],
                                  size: 15,
                                ),
                                SizedBox(
                                  width: height * 0.01,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      json.decode(widget.data)['event']['location']['name'],
                                      style: TextStyle(
                                          fontFamily: 'SF_Pro_700',
                                          fontSize: 12.0,
                                          color: ColorList.colorDetails,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.none
                                      ),
                                    ),
                                    Text(
                                      json.decode(widget.data)['event']['location']['address'],
                                      style: TextStyle(
                                          fontFamily: 'SF_Pro_400',
                                          fontSize: 8.0,
                                          color: ColorList.colorDetails,
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.none
                                      ),
                                    ),
                                  ],
                                ),
                               
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),]
                ),
                
              ),
              Container( height: height * 0.1,)
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        height: height * 0.1,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
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
                "Done",
                style: TextStyle(
                  color: ColorList.colorSplashBG,
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TicketQRCode(
                                json.decode(widget.data)['event']['_id'],
                                false
                            )
                    )
                );
              },
              child: Text(
                'View Ticket',
                style: TextStyle(
                  fontFamily: 'SF_Pro_600',
                  decoration: TextDecoration.none,
                  fontSize: 15.0,
                  fontWeight: FontWeight.normal,
                  color: ColorList.colorAccent,
                ),
              ),
              color: ColorList.colorSplashBG,
              minWidth: width * 0.5,
              height: 50.0,
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0),
              ),
              elevation: 5.0,
            )
          ],
        ),
      ),
    );
  }

  Widget generateMyTickets(ticketType, ticketCount, color) {
    return Column(
      children: [
        Container(
          height: height * 0.06,
          width: width * 0.9,
          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  color[50],
                  color[100],
                  color[50],
                ],
                stops: [
                  0.2,
                  0.5,
                  1,
                ]
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              children: [
                Container(
                  width: width * 0.09,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color[100],
                  ),
                  child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Image(
                        image: AssetImage("assets/images/ticket.png"),
                        color: color,
                        colorBlendMode: BlendMode.srcIn,
                        fit: BoxFit.cover,
                      )),
                ),
                SizedBox(width: 10,),
                Text(
                  ticketType,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey[700]),
                ),
                Spacer(),
                Text(
                  '$ticketCount',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ),
        Container(height: 10,)
      ],
    );
  }

  void getCost() {
    var unescape = HtmlUnescape();

    totalCost = "${unescape.convert(json.decode(widget.data)['currency']['htmlCode'])}${Methods.formattedAmount(json.decode(widget.data)['amount'])}";
  }
}
