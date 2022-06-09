import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/material.dart';
import 'package:ibloov/Constants/ApiCalls.dart';

import 'package:ibloov/Constants/ColorList.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'FeedbackSuccess.dart';

class HelpSupport extends StatefulWidget {
  @override
  _HelpSupportState createState() => _HelpSupportState();
}

class _HelpSupportState extends State<HelpSupport> {
  var width, height;
  var _selectedValue;
  Icon _icon;
  bool buttonenabled;
  TextEditingController descriptionController;
  FocusNode descriptionFocusNode = new FocusNode();

  List<DropdownMenuItem> _dropdownTestItems = [];

  List listOfValue = [
    {'key': 1, 'text': 'General enquiry'},
    {'key': 2, 'text': 'Can’t Purchase a Ticket'},
    {'key': 3, 'text': 'Payment not processing'},
    {'key': 4, 'text': 'Others'},
  ];

  @override
  void initState() {
    descriptionController = TextEditingController();
    descriptionController.addListener(() {
      setState(() {
        (descriptionController.text.length > 0 && _selectedValue > 0)
            ? buttonenabled = true
            : buttonenabled = false;
      });
    });
    super.initState();

    buttonenabled = false;
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
          child: Text(
            i['text'],
            style: TextStyle(
                fontFamily: 'SF_Pro_400',
                fontSize: 14.0,
                color: ColorList.colorPrimary,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none),
          ),
        ),
      );
    }
    return items;
  }

  onChangeDropdownTests(selectedValue) {
    print(selectedValue);
    setState(() {
      _selectedValue = selectedValue;
      (descriptionController.text.length > 0 && _selectedValue > 0)
          ? buttonenabled = true
          : buttonenabled = false;

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

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(height * 0.025, height * 0.05,
                  height * 0.025, height * 0.025),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Back",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontFamily: 'SF_Pro_700',
                          fontSize: 17.0,
                          color: ColorList.colorBack,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none),
                    ),
                  ),
                  Spacer(),
                  Text(
                    "Help & Support",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Spacer(),
                  Spacer()
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 0),
              child: Center(
                child: Container(
                  width: width * 0.75,
                  alignment: Alignment.center,
                  child: Image(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      "assets/images/help_header.png",
                    ),
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, top: 0),
              child: Text(
                "Let us know how we can help. Send a message",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 15,
                  // fontWeight: FontWeight.bold
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, top: 20),
              child: Text(
                "Subject",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 15,
                  // fontWeight: FontWeight.bold
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[500], width: 1.5),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
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
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                        boxTextstyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                        boxPadding: EdgeInsets.fromLTRB(13, 12, 13, 12),
                        boxWidth: width,
                        boxHeight: 45,
                        boxDecoration: BoxDecoration(
                            color: Colors.transparent,
                            border:
                                Border.all(width: 1, color: Colors.white54)),
                        icon: _icon,
                        hint: Text(
                          'Choose a subject',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontFamily: 'SF_Pro_400',
                              fontSize: 14.0,
                              color: ColorList.colorPrimary,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none),
                        ),
                        value: _selectedValue,
                        items: _dropdownTestItems,
                        onChanged: onChangeDropdownTests,
                      ),
                    ))),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20),
              child: Text(
                "Description",
                style: TextStyle(fontSize: 15),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: TextFormField(
                controller: descriptionController,
                focusNode: descriptionFocusNode,
                textInputAction: TextInputAction.next,
                cursorColor: ColorList.colorPrimary,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                maxLines: null,
                minLines: 5,
                onTap: () {},
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Type your message",
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
            Stack(
              children: [
                // Padding(
                //   padding: EdgeInsets.only(top: height * 0.03),
                //   child: Center(
                //     child: SizedBox(
                //       width: width * 0.9,
                //       height: 50,
                //       child: MaterialButton(
                //         shape: new RoundedRectangleBorder(
                //           borderRadius: new BorderRadius.circular(10.0),
                //         ),
                //         onPressed: () {},
                //         child: Text(
                //           "Send a Message",
                //           style: TextStyle(
                //             fontFamily: 'SF_Pro_700',
                //             decoration: TextDecoration.none,
                //             fontSize: 15.0,
                //             fontWeight: FontWeight.normal,
                //             color: ColorList.colorAccent,
                //           ),
                //         ),
                //         color: ColorList.colorSplashBG.withOpacity(0.5),
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.only(top: height * 0.03),
                  child: Center(
                    child: SizedBox(
                      width: width * 0.9,
                      height: 50,
                      child: MaterialButton(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        onPressed: buttonenabled
                            ? () async {
                                var prefs =
                                    await SharedPreferences.getInstance();
                                var fullName =
                                    prefs.getString('fullName').split(" ")[0];
                                var email = prefs.getString('email');
                                var phone = prefs.getString('phoneNumber');
                                if(phone.contains("+234")) {
                                  phone = phone.substring(4);
                                  phone = "0"+phone;


                                ApiCalls.submitHelpRequest(
                                        listOfValue[_selectedValue - 1]['text'],
                                        descriptionController.text,
                                        context,
                                        fullName: fullName,
                                        mail: email,
                                        phone: phone)
                                    .then((value) {
                                  if (value)
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FeedbackSuccess()));
                                });
                              }
                            : null,
                        child: Text(
                          "Send a Message",
                          style: TextStyle(
                            fontFamily: 'SF_Pro_700',
                            decoration: TextDecoration.none,
                            fontSize: 15.0,
                            fontWeight: FontWeight.normal,
                            color: ColorList.colorAccent,
                          ),
                        ),
                        color: ColorList.colorSplashBG,
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
