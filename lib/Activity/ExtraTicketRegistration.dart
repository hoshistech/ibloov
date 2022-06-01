import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:ibloov/Constants/ColorList.dart';
import 'package:ibloov/Constants/Methods.dart';

import 'package:ibloov/Utils/FestEvents.dart';
import 'package:ibloov/Utils/PaymentFrame.dart';

final fullnameController = TextEditingController();
final emailController = TextEditingController();

FocusNode fullnameFocusNode = new FocusNode();
FocusNode emailFocusNode = new FocusNode();

class ExtraTicketRegistration extends StatefulWidget {
  final String festId, festName, priceRange;
  final int extraTicketNumber;
  final List tickets;
  final FestEvents event;

  const ExtraTicketRegistration(this.festId, this.festName, this.extraTicketNumber, this.tickets, this.event, this.priceRange);

  @override
  _ExtraTicketRegistrationState createState() =>
      _ExtraTicketRegistrationState();
}

class _ExtraTicketRegistrationState extends State<ExtraTicketRegistration> {
  var height, width;
  var festName = "Marlin Fest";
  var organiser = "Naira Marley";
  var regularCount = 0;
  var vipCount = 0;
  var vvipCount = 0;
  var regularPrice = 20;

  var festId;
  FestEvents event;
  var user = [], userData = {};
  var extraTicketNumber;
  var fullnameControllers = [];
  var fullnameFocusNodes = [];
  var emailControllers = [];
  var emailFocusNodes = [];
  List tickets;
  int ticketCount = 0;

  @override
  void initState() {

    extraTicketNumber = widget.extraTicketNumber;
    tickets = widget.tickets;
    event = widget.event;
    festId = widget.festId;
    festName = widget.festName;
    //ticketCount = extraTicketNumber;

    Methods.getCurrentUserData(context)
        .then((value){
      setState(() {
        userData = value;
      });
    });

    debugPrint("extra ticket: $extraTicketNumber");
    for (int i = 0; i < extraTicketNumber; i++) {
      fullnameControllers.add(new TextEditingController());
      fullnameFocusNodes.add(new FocusNode());

      emailControllers.add(new TextEditingController());
      emailFocusNodes.add(new FocusNode());
      ticketCount++;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isError = false;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    var orientation=MediaQuery.of(context).orientation;
    if(orientation==Orientation.landscape){
      height=2.15*height;
    } 

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Text(
              '\nBack',
              style: TextStyle(
                  fontFamily: 'SF_Pro_700',
                  fontSize: 15,
                  color: ColorList.colorPrimary,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none
              ),
            ),
          ),
        ),
      ),
      body: Container(
        height: height * 0.9,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: height * 0.05,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
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
                padding: const EdgeInsets.only(left: 25.0, top: 10),
                child: Container(
                    child: Text(
                  festName,
                  style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0, top: 10),
                child: Container(
                    child: Text(
                  event.day.toString() +
                      "," +
                      event.date +
                      " " +
                      event.month +
                      " " +
                      event.year +
                      " " +
                      event.time,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[500]),
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  // height: width * 0.15,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Color.fromRGBO(66, 114, 237, 0.1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 15),
                    child: Center(
                      child: Text(
                          "Before proceeding, we noticed you are purchasing more than 1 ticket, kindly provide details of others attendees",
                      style: TextStyle(color: ColorList.colorGray, fontSize: 12, fontWeight: FontWeight.w700, height: 1.2),),
                    ),
                  ),
                ),
              ),
              Wrap(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: height * 0.15),
                    width: width,
                    // height: height*0.7,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: generateExtraTicketsField(),
                  )
                ],
              ),
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
                    Text("  "),
                    Text(
                      widget.priceRange,
                      style: TextStyle(
                          fontFamily: 'SF_Pro_700',
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 12
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: 5,),
                // Text(
                //   "Get ticket now on early bird",
                //   style: TextStyle(fontSize: 11),
                // )
              ],
            ),
            MaterialButton(
              onPressed: (){
                user.clear();
                //user.add(userData);

                for(int i=0; i<extraTicketNumber; i++){
                  var userData = {};

                  var controllerName = fullnameControllers[i];
                  var focusNodeName = fullnameFocusNodes[i];
                  var controllerEmail = emailControllers[i];
                  var focusNodeEmail = emailFocusNodes[i];

                  if(controllerName.text.isEmpty || controllerEmail.text.isEmpty){
                    if(controllerName.text.isEmpty){
                      Methods.showToast('Name field is empty!');
                      SystemChannels.textInput.invokeMethod('TextInput.show');
                      FocusScope.of(context).requestFocus(focusNodeName);

                      setState(() {
                        isError = true;
                      });
                    } else if(controllerEmail.text.isEmpty){
                      Methods.showToast('Email field is empty!');
                      SystemChannels.textInput.invokeMethod('TextInput.show');
                      FocusScope.of(context).requestFocus(focusNodeEmail);

                      setState(() {
                        isError = true;
                      });
                    }
                  } else {
                    userData['fullName'] = controllerName.text;
                    userData['email'] = controllerEmail.text;
                    user.add(userData);
                  }
                }

                debugPrint(jsonEncode(user));

                if(!isError)
                  PaymentFrame(
                      context,
                      widget.tickets,
                      event,
                      user
                  );
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
  }

  Widget generateExtraTicketsField() {
    debugPrint("tickets count: ${tickets.length}");

    return Column(
      children: [
        for (int i = 0; i < tickets.length; i++)
          Container(
            padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color.fromRGBO(66, 114, 237, 0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      tickets.elementAt(i)['name'],
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontFamily: 'SF_Pro_900',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: ColorList.colorGray
                      ),
                    ),
                    Spacer(),
                    Text(
                      "",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontFamily: 'SF_Pro_900',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: ColorList.colorGray
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  child: getInputFields(i),
                )
              ],
            ),
          ),
      ],
    );
  }

  getInputFields(int index) {

    int quantity = tickets.elementAt(index)['quantity'];
    debugPrint("quantity: $quantity");

    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: quantity, //>= 2 ? quantity - 1 : quantity,
        itemBuilder: (BuildContext context, int item) =>
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: height * 0.02),
                Text(
                  "Ticket " + (item + 1).toString(),
                  style: TextStyle(
                      fontFamily: 'SF_Pro_400',
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      color: ColorList.colorGray
                  ),
                ),
                Container(
                  height: height * 0.015,
                ),
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: fullnameControllers[(index * 1) + item],
                  focusNode: fullnameFocusNodes[(index * 1) + item],
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  cursorColor: ColorList.colorPrimary,
                  maxLines: 1,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Full Name',
                    hintStyle: TextStyle(color: ColorList.colorGrayHint),
                    labelText: 'Full Name',
                    labelStyle: TextStyle(color: ColorList.colorGrayHint),
                    alignLabelWithHint: true,
                    prefixIcon: Image.asset('assets/images/fullname_logo.png',
                        height: 5.0, width: 5.0),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                          color: ColorList.colorGrayBorder, width: 2),
                    ),
                  ),
                ),
                Container(
                  height: height * 0.015,
                ),
                TextFormField(
                  controller: emailControllers[(index * 1) + item],
                  focusNode: emailFocusNodes[(index * 1) + item],
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  cursorColor: ColorList.colorPrimary,
                  maxLines: 1,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Email address',
                    hintStyle: TextStyle(color: ColorList.colorGrayHint),
                    labelText: 'Email address',
                    labelStyle: TextStyle(color: ColorList.colorGrayHint),
                    alignLabelWithHint: true,
                    prefixIcon: Image.asset('assets/images/email_logo.png',
                        height: 5.0, width: 5.0),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                          color: ColorList.colorGrayBorder, width: 2),
                    ),
                  ),
                )
              ],
            )
    );
  }
  
}
