import 'dart:convert';

import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/material.dart';
import 'package:ibloov/Constants/ApiCalls.dart';

import 'package:ibloov/Constants/ColorList.dart';
import 'package:ibloov/Constants/Methods.dart';

import 'FeedbackSuccess.dart';

class ReportEvent extends StatefulWidget {
  String id;
  ReportEvent(this.id);

  @override
  ReportEventState createState() => ReportEventState();
}

class ReportEventState extends State<ReportEvent> {
  var width, height;
  var _selectedValue;
  Icon _icon;
  bool buttonEnabled;
  TextEditingController descriptionController;
  FocusNode descriptionFocusNode = new FocusNode();

  List<DropdownMenuItem> _dropdownTestItems = [];

  List listOfValue = [
    {'key': 1, 'text': 'It\'s inaccurate or incorrect'},
    {'key': 2, 'text': 'Event is a scam'},
    {'key': 3, 'text': 'It\'s offensive'},
    {'key': 4, 'text': 'It\'s racist'},
    {'key': 5, 'text': 'It\'s not what is advertised'},
    {'key': 6, 'text': 'Others'},
  ];

  @override
  void initState() {
    descriptionController = TextEditingController();
    descriptionController.addListener(() {
      setState(() {
        (descriptionController.text.length > 0 && _selectedValue > 0) ? buttonEnabled = true : buttonEnabled = false;
      });
    });
    super.initState();

    buttonEnabled = false;
    _icon = Icon(
      Icons.keyboard_arrow_down_sharp,
      color: Colors.black,
    );
    _dropdownTestItems = buildDropdownTestItems(listOfValue);
    super.initState();
  }

  List<DropdownMenuItem> buildDropdownTestItems(List _testList) {
    List<DropdownMenuItem> items = [];
    for (var i in _testList) {
      items.add(
        DropdownMenuItem(
          value: i['key'],
          child: Text(i['text']),
        ),
      );
    }
    return items;
  }

  onChangeDropdownTests(selectedValue) {
    print(selectedValue);
    setState(() {
      _selectedValue = selectedValue;
      (descriptionController.text.length > 0 && _selectedValue > 0) ? buttonEnabled = true : buttonEnabled = false;

      _icon = Icon(
        Icons.keyboard_arrow_down_sharp,
        color: Colors.black,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text(
              'Report Event',
              style: TextStyle(
                fontFamily: 'SF_Pro_700',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorList.colorPrimary,
              ),
            ),
            flexibleSpace: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Back',
                  style: TextStyle(
                    fontFamily: 'SF_Pro_400',
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: ColorList.colorPrimary,
                  ),
                ),
              ),
            ),
          ),
          body: Container(
            height: height,
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    "Why are you reporting this event?",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: 'SF_Pro_700',
                        color: ColorList.colorPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    "This won’t be shared with the event organizers.",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: 'SF_Pro_400',
                        color: ColorList.colorPrimary,
                        fontWeight: FontWeight.normal,
                        fontSize: 13
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[500], width: 1.5),
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        width: width,
                        child: GestureDetector(
                          onTapDown: (details) {
                            descriptionFocusNode.unfocus();
                            setState(() {
                              _icon = Icon(
                                Icons.keyboard_arrow_up_sharp,
                                color: Colors.black,
                              );
                            });
                          },
                          child: DropdownBelow(
                            itemWidth: width * 0.9,
                            itemTextstyle: TextStyle(
                                fontFamily: 'SF_Pro_400',
                                color: ColorList.colorPrimary,
                                fontWeight: FontWeight.normal,
                                fontSize: 16
                            ),
                            boxTextstyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black
                            ),
                            boxPadding: EdgeInsets.fromLTRB(13, 12, 13, 12),
                            boxWidth: width,
                            boxHeight: 45,
                            boxDecoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(width: 1, color: Colors.white54)
                            ),
                            icon: _icon,
                            hint: Text(
                              'Select your reason',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontFamily: 'SF_Pro_400',
                                  color: ColorList.colorPrimary,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18
                              ),
                            ),
                            value: _selectedValue,
                            items: _dropdownTestItems,
                            onChanged: onChangeDropdownTests,
                          ),
                        )
                    )
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Text(
                    "Describe your reason",
                    style: TextStyle(
                        fontFamily: 'SF_Pro_700',
                        color: ColorList.colorPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: TextFormField(
                    controller: descriptionController,
                    focusNode: descriptionFocusNode,
                    textInputAction: TextInputAction.next,
                    cursorColor: ColorList.colorPrimary,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: null,
                    minLines: 5,
                    onTap: () {

                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Type here",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide:
                        BorderSide(color: ColorList.colorGrayBorder, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide:
                        BorderSide(color: ColorList.colorGrayBorder, width: 2),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: height * 0.03),
                  child: Center(
                    child: SizedBox(
                      width: width * 0.9,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: buttonEnabled
                            ? () {
                                ApiCalls.reportEvent(listOfValue[_selectedValue-1]['text'], descriptionController.text, context, widget.id)
                                    .then((value){
                                  if(value != null) {
                                    Methods.showToast(json.decode(value)['message']);
                                    Navigator.pop(context);
                                  }
                                });
                              }
                            : null,
                        child: Text(
                          "Report Event",
                          style: TextStyle(
                              fontFamily: 'SF_Pro_600',
                              color: ColorList.colorAccent,
                              fontWeight: FontWeight.normal,
                              fontSize: 15
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: buttonEnabled ? ColorList.colorSplashBG : ColorList.colorPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}
