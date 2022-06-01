import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html_unescape/html_unescape.dart';

import 'package:ibloov/Activity/TicketPurchasedSuccess.dart';
import 'package:ibloov/Activity/payment_checkout.dart';
import 'package:ibloov/Constants/ApiCalls.dart';

import 'package:ibloov/Constants/ColorList.dart';
import 'package:ibloov/Constants/Methods.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'FestEvents.dart';

class PaymentFrame {
  BuildContext context;
  String userEmail = "", totalCost = "";
  List tickets = [], userData = [];
  FestEvents events;
  var responseOrder;

  TextEditingController controllerCard = new TextEditingController();
  TextEditingController controllerExpiry = new TextEditingController();
  TextEditingController controllerCVV = new TextEditingController();
  TextEditingController controllerPIN = new TextEditingController();

  TextEditingController OTPController = new TextEditingController();

  FocusNode focusCard = new FocusNode();
  FocusNode focusExpiry = new FocusNode();
  FocusNode focusCVV = new FocusNode();
  FocusNode focusPIN = new FocusNode();

  PaymentFrame(this.context, List tickets, this.events, this.userData) {
    getEmail();

    var jsonObject = {};
    jsonObject['resource'] = 'ticket';
    jsonObject['resourceData'] = tickets;
    jsonObject['users'] = userData;

    ApiCalls.createOrder(context, jsonObject).then((value) {
      if (value != null) {
        responseOrder = json.decode(value)['data'];
        getCost();
        if (responseOrder['price'] != null && responseOrder['price'] > 0) {
          // slideSheet();
          debugPrint("goingToPayStackLink");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PaymentCheckout(responseOrder['paymentLink'])));
        } else {
          debugPrint("creatingFreeOrders");
          ApiCalls.createFreeOrder(context, responseOrder['_id']).then((value) {
            if (value != null) {
              print(json.decode(value)['data']);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TicketPurchasedSuccess(
                          json.encode(json.decode(value)['data']))));
            }
          });
        }
      }
    });
  }

  void slideSheet() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    controllerCard.text = '5531886652142950';
    controllerCVV.text = '564';
    controllerPIN.text = '3312';
    controllerExpiry.text = '9/32';

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              color: ColorList.colorBottomSheetBG,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: ColorList.colorAccent,
                ),
                child: Padding(
                    padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                    child: Wrap(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: width * 0.3,
                                    child: Image(
                                      image:
                                          AssetImage("assets/images/logo.png"),
                                      fit: BoxFit.cover,
                                      color: ColorList.colorSplashBG,
                                      colorBlendMode: BlendMode.modulate,
                                    ),
                                  ),
                                  Container(
                                    child: InkWell(
                                      child: Icon(
                                        Icons.close_rounded,
                                        color: Colors.white,
                                      ),
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red),
                                  )
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              child: Container(
                                width: width * 0.8,
                                // height: height * 2,
                                color: ColorList.colorAccent,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            totalCost,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            userEmail,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                      Container(
                                        height: height * 0.02,
                                      ),
                                      TextFormField(
                                        controller: controllerCard,
                                        focusNode: focusCard,
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        cursorColor: ColorList.colorPrimary,
                                        maxLines: 1,
                                        maxLength: 16,
                                        decoration: InputDecoration(
                                            fillColor: Colors.white,
                                            filled: true,
                                            hintText: 'CARD NUMBER',
                                            alignLabelWithHint: true,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1, color: Colors.grey),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1, color: Colors.blue),
                                            )),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              controller: controllerExpiry,
                                              focusNode: focusExpiry,
                                              keyboardType:
                                                  TextInputType.datetime,
                                              textInputAction:
                                                  TextInputAction.next,
                                              cursorColor:
                                                  ColorList.colorPrimary,
                                              maxLines: 1,
                                              maxLength: 5,
                                              decoration: InputDecoration(
                                                  fillColor: Colors.white,
                                                  filled: true,
                                                  hintText: 'MM/YY',
                                                  alignLabelWithHint: true,
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: Colors.grey),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: Colors.blue),
                                                  )),
                                            ),
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              controller: controllerCVV,
                                              focusNode: focusCVV,
                                              keyboardType:
                                                  TextInputType.number,
                                              textInputAction:
                                                  TextInputAction.next,
                                              cursorColor:
                                                  ColorList.colorPrimary,
                                              maxLines: 1,
                                              maxLength: 3,
                                              decoration: InputDecoration(
                                                  fillColor: Colors.white,
                                                  filled: true,
                                                  hintText: 'CVV',
                                                  alignLabelWithHint: true,
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: Colors.grey),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: Colors.blue),
                                                  )),
                                            ),
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              controller: controllerPIN,
                                              focusNode: focusPIN,
                                              keyboardType:
                                                  TextInputType.number,
                                              textInputAction:
                                                  TextInputAction.done,
                                              cursorColor:
                                                  ColorList.colorPrimary,
                                              maxLines: 1,
                                              maxLength: 4,
                                              decoration: InputDecoration(
                                                  fillColor: Colors.white,
                                                  filled: true,
                                                  hintText: 'PIN',
                                                  alignLabelWithHint: true,
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: Colors.grey),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: Colors.blue),
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: height * 0.02,
                                      ),
                                      SizedBox(
                                        width: width * 0.8,
                                        //height: height * 0.09,
                                        child: MaterialButton(
                                          onPressed: () {
                                            String card = controllerCard.text;
                                            String expiry =
                                                controllerExpiry.text;
                                            String cvv = controllerCVV.text;
                                            String pin = controllerPIN.text;

                                            if (card == null || card.isEmpty) {
                                              Methods.showToast(
                                                  'Card number field is empty!');
                                              SystemChannels.textInput
                                                  .invokeMethod(
                                                      'TextInput.show');
                                              FocusScope.of(context)
                                                  .requestFocus(focusCard);
                                            } else if (expiry == null ||
                                                expiry.isEmpty) {
                                              Methods.showToast(
                                                  'Expiry date field is empty!');
                                              SystemChannels.textInput
                                                  .invokeMethod(
                                                      'TextInput.show');
                                              FocusScope.of(context)
                                                  .requestFocus(focusExpiry);
                                            } else if (cvv == null ||
                                                cvv.isEmpty) {
                                              Methods.showToast(
                                                  'CVV field is empty!');
                                              SystemChannels.textInput
                                                  .invokeMethod(
                                                      'TextInput.show');
                                              FocusScope.of(context)
                                                  .requestFocus(focusCVV);
                                            } else if (pin == null ||
                                                pin.isEmpty) {
                                              Methods.showToast(
                                                  'PIN field is empty!');
                                              SystemChannels.textInput
                                                  .invokeMethod(
                                                      'TextInput.show');
                                              FocusScope.of(context)
                                                  .requestFocus(focusPIN);
                                            } else {
                                              int month = int.parse(
                                                  expiry.split("/")[0]);
                                              int year = int.parse(
                                                  expiry.split("/")[1]);

                                              var now = new DateTime.now();
                                              var formatterMonth =
                                                  new DateFormat('MM');
                                              int monthString = int.parse(
                                                  formatterMonth.format(now));
                                              var formatterYear =
                                                  new DateFormat('yy');
                                              int yearString = int.parse(
                                                  formatterYear.format(now));

                                              if (expiry.contains(new RegExp(
                                                      r'^(0[1-9]|1[0-2])[- /.](2[1-9]|3[1-9])$')) ||
                                                  expiry.contains(new RegExp(
                                                      r'^([1-9])[- /.](2[1-9]|3[1-9])$'))) {
                                                if (month < monthString &&
                                                    year <= yearString) {
                                                  Methods.showToast(
                                                      'Card is expired already!');
                                                  SystemChannels.textInput
                                                      .invokeMethod(
                                                          'TextInput.show');
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          focusExpiry);
                                                } else if (month > 12) {
                                                  Methods.showToast(
                                                      'Please provide a valid expiry month!');
                                                  SystemChannels.textInput
                                                      .invokeMethod(
                                                          'TextInput.show');
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          focusExpiry);
                                                } else {
                                                  var jsonObject = {};
                                                  jsonObject['orderId'] =
                                                      responseOrder['_id'];
                                                  jsonObject['cardNumber'] =
                                                      card;
                                                  jsonObject['cvv'] = cvv;
                                                  jsonObject['expiryMonth'] =
                                                      month;
                                                  jsonObject['expiryYear'] =
                                                      year;
                                                  jsonObject['pin'] =
                                                      int.parse(pin);

                                                  ApiCalls.createPayment(
                                                          context, jsonObject)
                                                      .then((value) {
                                                    if (value != null) {
                                                      var jsonObject = {};
                                                      jsonObject['paymentId'] =
                                                          json.decode(value)[
                                                                      'data']
                                                                  ['payment']
                                                              ['_id'];
                                                      showOTPDialog(
                                                          context, jsonObject);
                                                    }
                                                  });
                                                }
                                              } else {
                                                Methods.showToast(
                                                    'Expiry date format is wrong!\nIt must be in DD/MM format!');
                                                SystemChannels.textInput
                                                    .invokeMethod(
                                                        'TextInput.show');
                                                FocusScope.of(context)
                                                    .requestFocus(focusExpiry);
                                              }
                                            }
                                          },
                                          child: Text(
                                            "Pay $totalCost",
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
                                            borderRadius:
                                                new BorderRadius.circular(10.0),
                                          ),
                                          elevation: 5.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    )),
              ),
            ),
          );
        });
  }

  Future<void> getEmail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    userEmail = pref.getString('email');
  }

  void getCost() {
    var unescape = HtmlUnescape();
    // totalCost = "${unescape.convert(responseOrder['currency']['htmlCode'])}${Methods.formattedAmount(responseOrder['price'])}";
    totalCost =
        "${unescape.convert("&#8358;")}${Methods.formattedAmount(responseOrder['price'])}";
  }

  Future<Null> showOTPDialog(BuildContext context, Map jsonObject) async {
    OTPController.text = '12345';

    return showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CupertinoAlertDialog(
              content: Column(
                children: [
                  Text("Enter OTP",
                      textScaleFactor: 1.2,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text(
                        "Please enter the OTP set to your Registered number"),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: TextFormField(
                      controller: OTPController,
                      maxLength: 5,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: 'OTP',
                        contentPadding: EdgeInsets.only(left: 10),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                CupertinoActionSheetAction(
                  isDefaultAction: true,
                  isDestructiveAction: false,
                  child: Text(
                    "Cancel",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CupertinoActionSheetAction(
                  isDefaultAction: false,
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.grey[800], fontSize: 16.0),
                  ),
                  onPressed: () async {
                    String otp = OTPController.text;
                    if (otp.isNotEmpty || otp != null) {
                      jsonObject['otp'] = int.parse(otp);
                      ApiCalls.chargeOTP(context, jsonObject).then((value) {
                        if (value != null) {
                          print(json.decode(value)['data']);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TicketPurchasedSuccess(
                                      json.encode(
                                          json.decode(value)['data']))));
                        }
                      });
                    }
                  },
                )
              ],
            ));
  }
}
