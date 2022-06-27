import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:ibloov/Activity/event_terms.dart';
import 'package:ibloov/Constants/ApiCalls.dart';

import 'package:ibloov/Constants/ColorList.dart';
import 'package:ibloov/Constants/Methods.dart';

import 'package:ibloov/Utils/FestEvents.dart';
import 'package:ibloov/Utils/PaymentFrame.dart';

import 'ExtraTicketRegistration.dart';

class SelectTicket extends StatefulWidget {
  final String festId, festName, organiser;
  final FestEvents event;
  final Map<String, dynamic> eventData;

  const SelectTicket(this.festId, this.festName, this.organiser, this.event,
      {this.eventData});

  @override
  _SelectTicketState createState() => _SelectTicketState();
}

class _SelectTicketState extends State<SelectTicket> {
  var height, width;
  var festName;
  var organiser;
  var festId;
  var data;
  var colors = [Colors.blue[100], Colors.red[100], Colors.green[100]];
  var colorsBlend = [Colors.blue, Colors.red, Colors.green];
  var ticket = [], user = {};
  var unescape = HtmlUnescape();
  int totalTickets = 0;
  num totalAmount = 0.0;
  bool accept = false;
  FestEvents event;

  @override
  void initState() {
    festId = widget.festId;
    festName = widget.festName;
    organiser = widget.organiser;
    event = widget.event;
    if (!(widget.eventData["terms"] != null &&
        widget.eventData["terms"].toString().isNotEmpty)) {
      accept = true;
    }

    accept = widget.eventData["terms"] == null ||
        widget.eventData["terms"].toString().isEmpty;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ApiCalls.fetchEventTickets(context, festId).then((value) {
        setState(() {
          if (value != null) {
            data = json.decode(value)['data'];
            for (int i = 0; i < data.length; i++) {
              ticket.add([data[i]['_id'], data[i]['name'], 0, data[i]['type']]);
            }
          } else {
            Navigator.pop(context);
          }
        });
      });

      Methods.getCurrentUserData(context).then((value) {
        setState(() {
          user = value;
        });
      });
    });

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

    if (data != null) {
      return Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 75),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(top: 20),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Colors.black,
                                    size: 30,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: height * 0.1,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Container(
                          width: width * 0.12,
                          height: width * 0.12,
                          child: Image(
                            image: AssetImage("assets/images/ticket.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Container(
                            child: Text(
                          festName,
                          style: TextStyle(
                              fontSize: 45, fontWeight: FontWeight.bold),
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Container(
                            child: Text(
                          event.day.toString() +
                              ", " +
                              event.date +
                              " " +
                              event.month +
                              " " +
                              event.year +
                              "\t\t" +
                              event.time,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[500]),
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 20),
                        child: Container(
                            child: Text(
                          "Tickets",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        )),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 20.0, bottom: height * 0.11),
                        child: ListView.builder(
                            // physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int item) {
                              if (data.length == 0) {
                                return Center(
                                    child: Text(
                                        "No available tickets for this event."));
                              } else {
                                return Row(
                                  children: [
                                    Container(
                                      height: height * 0.075,
                                    ),
                                    Container(
                                      width: width * 0.10,
                                      height: width * 0.10,
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: colors[item % 3]),
                                      child: Image(
                                          image: AssetImage(
                                              "assets/images/ticket.png"),
                                          color: colorsBlend[item % 3],
                                          colorBlendMode: BlendMode.srcIn,
                                          fit: BoxFit.cover),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data[item]['name'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[800]),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                '${data[item]['currency'] != null ? unescape.convert(data[item]['currency']['htmlCode']) : ""}${Methods.formattedAmount(data[item]['price'])}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey[700]),
                                              ),
                                              Text(
                                                " per person",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey[400]),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: EdgeInsets.only(left: 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  shape: CircleBorder(),
                                                  shadowColor: Colors.black,
                                                  primary: Colors.white,
                                                  onPrimary: Colors.grey),
                                              onPressed: () {
                                                setState(() {
                                                  if (ticket[item][2] > 0) {
                                                    ticket[item][2]--;
                                                    if (totalTickets != 0)
                                                      totalTickets--;
                                                    totalAmount = totalAmount - data[item]['price'];
                                                  }
                                                });
                                              },
                                              child: Text("-",
                                                  style: TextStyle(
                                                      color: Colors.black))),
                                          Text(
                                            ticket[item][2].toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[700]),
                                          ),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  shape: CircleBorder(),
                                                  shadowColor: Colors.black,
                                                  primary: Colors.white,
                                                  onPrimary: Colors.grey),
                                              onPressed: () {
                                                setState(() {
                                                  if ((ticket[item][3]
                                                              ?.toString()
                                                              ?.toLowerCase() ==
                                                          "free") &&
                                                      ticket[item][2] < 2) {
                                                    if (((widget.eventData[
                                                                    "plusOne"] ??
                                                                false) &&
                                                            ticket[item][2] <
                                                                2) ||
                                                        ticket[item][2] < 1) {
                                                      ticket[item][2]++;
                                                      totalTickets++;
                                                      totalAmount = totalAmount + data[item]['price'];
                                                    } else
                                                      Methods.showToast(
                                                          "You have reached your limit for this ticket");
                                                  } else if ((widget.eventData[
                                                              "visibility"] ==
                                                          "PRIVATE") &&
                                                      ticket[item][2] < 2) {
                                                    if (((widget.eventData[
                                                                    "plusOne"] ??
                                                                false) &&
                                                            ticket[item][2] <
                                                                2) ||
                                                        ticket[item][2] < 1) {
                                                      ticket[item][2]++;
                                                      totalTickets++;
                                                    } else
                                                      Methods.showToast(
                                                          "You have reached your limit for this ticket");
                                                  } else {
                                                    ticket[item][2]++;
                                                    totalTickets++;
                                                    totalAmount = totalAmount + data[item]['price'];
                                                  }
                                                });
                                              },
                                              child: Text("+",
                                                  style: TextStyle(
                                                      color: Colors.black)))
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 75,
              left: 0,
              right: 0,
              child: (widget.eventData["terms"] != null &&
                      widget.eventData["terms"].toString().isNotEmpty)
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (!accept)
                                  accept = true;
                                else
                                  accept = false;
                              });
                            },
                            child: Image.asset(
                              !accept
                                  ? 'assets/images/accept_agreement_select.png'
                                  : 'assets/images/accept_agreement.png',
                              width: width * 0.075,
                              height: width * 0.075,
                            ),
                          ),
                          Container(
                            width: width * 0.03,
                          ),
                          Flexible(
                            child: RichText(
                              text: TextSpan(
                                  text: 'I agree to abide by all the ',
                                  style: TextStyle(
                                    fontFamily: 'SF_Pro_400',
                                    decoration: TextDecoration.none,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: ColorList.colorGray,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Terms and Conditions',
                                        style: TextStyle(
                                          fontFamily: 'SF_Pro_400',
                                          decoration: TextDecoration.none,
                                          decorationColor:
                                              ColorList.colorBlueOnBlack,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          color: ColorList.colorSplashBG,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            showTermsAndConditions(
                                                context,
                                                widget.eventData["terms"]
                                                    .toString());
                                          }),
                                    TextSpan(
                                      text:
                                          ' of the event and by the organizers ',
                                      style: TextStyle(
                                        fontFamily: 'SF_Pro_400',
                                        decoration: TextDecoration.none,
                                        decorationColor:
                                            ColorList.colorGrayText,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                        color: ColorList.colorGray,
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
            ),
          ],
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: width * 0.05,
                        height: width * 0.05,
                        child: Image(
                          image: AssetImage("assets/images/ticket.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(" $totalTickets",
                          style: TextStyle(
                              fontFamily: 'SF_Pro_700',
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold,
                              fontSize: 14)),
                      Text(" for ", style: TextStyle(
                          fontFamily: 'SF_Pro_700',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                      Text(
                        "${data[0]['currency'] != null ? unescape.convert(data[0]['currency']['htmlCode']) : ""}${Methods.formattedAmount(totalAmount)}", //${Methods.getLowestPrice(data, false)}${Methods.getHighestPrice(data)}
                        style: TextStyle(
                            fontFamily: 'SF_Pro_700',
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  // Text(
                  //   "Get ticket now on early bird",
                  //   style: TextStyle(fontSize: 11),
                  // )
                ],
              ),
              MaterialButton(
                onPressed: () {
                  if (!accept) {
                    Methods.showToast("Accept terms and conditions");
                    return;
                  }
                  var extraTicketNumber = 0;
                  List _tickets = [];

                  for (int i = 0; i < data.length; i++) {
                    extraTicketNumber += ticket[i][2];
                    if (ticket[i][2] > 0) {
                      var ticketData = {};
                      ticketData['id'] = "${ticket[i][0]}";
                      ticketData['name'] = "${ticket[i][1]}";
                      ticketData['quantity'] = ticket[i][2];
                      _tickets.add(ticketData);
                    }
                  }

                  debugPrint("extraTicket: $extraTicketNumber");

                  // if (extraTicketNumber > 1) {
                  //   debugPrint("Going to ExtraTicket");
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => ExtraTicketRegistration(
                  //               festId,
                  //               festName,
                  //               extraTicketNumber,
                  //               _tickets,
                  //               event,
                  //               "${Methods.getLowestPrice(data, false)}${Methods.getHighestPrice(data)}")));
                  // } else
                  if (extraTicketNumber > 0) {
                    debugPrint("Going to PaymentFrame");
                    List userData = [];
                    userData.add(user);
                    PaymentFrame(context, _tickets, event, userData);
                  } else if (extraTicketNumber == 0) {
                    Methods.showError('Please select a ticket!');
                  }
                },
                child: Text(
                  'Pay for Ticket',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'SF_Pro_600',
                    decoration: TextDecoration.none,
                    fontSize: 15.0,
                    fontWeight: FontWeight.normal,
                    color: ColorList.colorAccent,
                  ),
                ),
                color: ColorList.colorSplashBG,
                minWidth: width * 0.4,
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
    } else {
      return Container(
        color: ColorList.colorAccent,
      );
    }
  }

  showTermsAndConditions(BuildContext context, String terms) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return EventTerms(terms ?? "");
        });
  }
}
