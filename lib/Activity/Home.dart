import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ibloov/Activity/MyTickets.dart';
import 'package:ibloov/Activity/faq_webview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:ibloov/Constants/ApiCalls.dart';
import 'package:ibloov/Constants/ColorList.dart';
import 'package:ibloov/Constants/Methods.dart';
import 'package:ibloov/Utils/RatingDialog.dart';

import 'package:ibloov/Widget/HomeWidget.dart';
import 'package:ibloov/Widget/MessagesWidget.dart';
import 'package:ibloov/Widget/SearchWidget.dart';
import 'package:ibloov/Widget/MyIbloovWidget.dart';
import 'package:ibloov/Widget/SettingsWidget.dart';

import 'FAQ.dart';
import 'RatingFeedbackSuccess.dart';
import 'HelpSupport.dart';

class Home extends StatefulWidget {

  @override
  State<Home> createState() => _HomeState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _HomeState extends State<Home> {
  double height, width;
  Widget body;
  DateTime currentBackPressTime;

  var _selectedIndex = 0;
  var _selectedSettingsMenuOptions;

  final titleController = TextEditingController();
  final reviewController = TextEditingController();
  final nicknameController = TextEditingController();

  FocusNode titleFocusNode = new FocusNode();
  FocusNode reviewFocusNode = new FocusNode();
  FocusNode nicknameFocusNode = new FocusNode();

  List<dynamic> rating = [0, 0, 0, 0, 0];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      body = HomeWidget();

      Methods.getProfileCompleteStatus()
          .then((complete){
        setState(() {
          if(!complete){
            Methods.showCompleteDialog(context, height, width, false);
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
        extendBody: true,
        body: WillPopScope(
          child: body ?? SizedBox(),
          onWillPop: onWillPop
        ),
        bottomNavigationBar: CurvedNavigationBar(
          height: Platform.isIOS ? 60 : 56,
          animationDuration: Duration(milliseconds: 500),
          buttonBackgroundColor: ColorList.colorSplashBG, //button bg
          backgroundColor: ColorList.colorPrimary.withOpacity(0.1), //nav selected top
          //color: ColorList.colorCorousalIndicatorActive, //nav bg
          items: <Widget>[
            ImageIcon(AssetImage("assets/images/home.png"), size: 20, color: ColorList.colorNavButton),
            // ImageIcon(AssetImage("assets/images/sms.png"), size: 20, color: ColorList.colorNavButton),
            ImageIcon(AssetImage("assets/images/search.png"), size: 20, color: ColorList.colorNavButton),
            ImageIcon(AssetImage("assets/images/profile.png"), size: 20, color: ColorList.colorNavButton),
            ImageIcon(AssetImage("assets/images/more_vert.png"), size: 20, color: ColorList.colorNavButton)
          ],
          onTap: _onTap
        )
        /*bottomNavigationBar: CustomNavBar(
          onTap: _onTap,
          items: [
            CustomNavBarItem(
              icon: AssetImage("assets/images/home.png"), 
              title: "HOME",
              type: 0
              ),
               CustomNavBarItem(
              icon: AssetImage("assets/images/sms.png"),  
              title: "MESSAGES",
              type: 0),
               CustomNavBarItem(
              icon: AssetImage("assets/images/search.png"), 
              title: "SEARCH",
              type: 0),
               CustomNavBarItem(
              icon: NetworkImage('https://icon-library.com/images/avatar-icon-images/avatar-icon-images-4.jpg'),
              title: "MY IBLOOV",
              type: 1),
               CustomNavBarItem(
              icon: AssetImage("assets/images/more_vert.png"), 
              title: "MORE",
              type: 0)

          ],
        )*/
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: "You're one tap away from EXIT!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: ColorList.colorSplashBG,
        textColor: ColorList.colorAccent,
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  _onTap(int index) async {
    if (index == 3) {
      _selectedSettingsMenuOptions = await showMenu(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
        position: RelativeRect.fromLTRB(width, height-height * 0.37, 0.0, 60.0),
        items: [
          PopupMenuItem(
            value: 4,
            child: Text("MY TICKETS", style: TextStyle(fontSize: 12)),
          ),
          PopupMenuItem(
            value: 3,
            child: Text("FAQ", style: TextStyle(fontSize: 12)),
          ),
          PopupMenuItem(
            value: 2,
            child: Text("LEAVE FEEDBACK", style: TextStyle(fontSize: 12)),
          ),
          PopupMenuItem(
            value: 1,
            child: Text("HELP", style: TextStyle(fontSize: 12)),
          ),
          PopupMenuItem(
            value: 0,
            child: Text("SETTINGS", style: TextStyle(fontSize: 12)),
          ),
        ],
        elevation: 8.0,
      );
      if (_selectedSettingsMenuOptions != null) {
        if(_selectedSettingsMenuOptions == 0){
          setState(() {
            body = SettingsWidget();
          });
        } else if(_selectedSettingsMenuOptions == 1){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HelpSupport()
            ),
          );
        } else if(_selectedSettingsMenuOptions == 2){
          showRatingDialog(context);
        } else if(_selectedSettingsMenuOptions == 3){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FAQWebView()
            ),
          );
        } else if(_selectedSettingsMenuOptions == 4){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyTickets()
            ),
          );
        }
      }
    } else {
      setState(() {
        _selectedIndex = index;
        getBody();
      });
    }
  }

  Future<Null> showRatingDialog(BuildContext context) async {
    var _isStarTapped = false;
    return showDialog<Null>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          content: Column(
            children: [
              RatingDialog(
                height: height,
                width: width,
                onWriteReviewTap: () => showReviewDialog(context),
                onTap: () {
                  setState(() {
                    _isStarTapped = true;
                  });
                },
              ),
            ],
          ),
        )
    );
  }

  Future<void> showReviewDialog(BuildContext ctx) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    rating = json.decode(pref.getString('rating'));

    titleController.text = '';
    reviewController.text = '';

    showModalBottomSheet(
        isScrollControlled: true,
        elevation: 15,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))
        ),
        context: ctx,
        builder: (ctx) => StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  height: height * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(10),
                      topRight: const Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Cancel",
                              textScaleFactor: 1.2,
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                          Text("Write a review"),
                          InkWell(
                            onTap: () {
                              if(reviewController.text.isNotEmpty)
                                showNickNameDialog(context);
                              else{
                                Methods.showToast('Review cannot be empty!');
                                //SystemChannels.textInput.invokeMethod('TextInput.show');
                                //FocusScope.of(context).requestFocus(titleFocusNode);
                              }

                            },
                            child: Text(
                              "Send",
                              textScaleFactor: 1.2,
                              style: TextStyle(color: Colors.blue),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 50.0, right: 50, top: 50.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              for (int i = 0; i < 5; i++)
                                GestureDetector(
                                    onTap: () {
                                      // widget.onTap();
                                      setState(() {
                                        // _isStarTapped = true;
                                        for (int j = 0; j <= i; j++) rating[j] = 1;
                                        for (int j = i + 1; j < 5; j++) rating[j] = 0;
                                      });

                                      print(rating.toString());
                                    },
                                    child: Icon(
                                      (rating[i] == 1)
                                          ? Icons.star_rate_rounded
                                          : Icons.star_outline_rounded,
                                      color: Colors.blue,
                                    ))
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                              "Tap star to Rate",
                              textScaleFactor: 1.2,
                              style: TextStyle(color: Colors.grey[600]),
                            )),
                      ),
                      TextFormField(
                          cursorColor: ColorList.colorPrimary,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          controller: titleController,
                          maxLines: 1,
                          decoration: InputDecoration(
                            hintText: 'Title (Optional)',
                            hintStyle: TextStyle(color: ColorList.colorGrayHint),
                            // labelText: 'Title',
                          )),
                      TextFormField(
                          cursorColor: ColorList.colorPrimary,
                          minLines: 5,
                          maxLines: 10,
                          controller: reviewController,
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            hintText: 'Review',
                            hintStyle: TextStyle(color: ColorList.colorGrayHint),
                            // labelText: 'Title',
                          ))
                    ],
                  ),
                ),
              );
            }
        )
    );
  }

  Future<Null> showNickNameDialog(BuildContext context) async {

    nicknameController.text = '';

    return showDialog<Null>(
        context: context,
        builder: (BuildContext context) => Opacity(
          opacity:0.85,
          child: CupertinoAlertDialog(

            content: Column(

              children: [
                Text("Enter A Name",
                    textScaleFactor: 1.2,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Padding(
                  padding: EdgeInsets.only(top:8.0,bottom: 8.0),
                  child: Text(
                      "Your nickname will be displayed next to any reviews you write."),
                ),
                Material(
                  color: Colors.transparent,
                  child: TextFormField(
                    controller: nicknameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      hintText: 'nickname',
                      contentPadding: EdgeInsets.only(left:10),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide.none

                      ),filled: true,
                      fillColor: Colors.white,
                      // border: InputBorder.none
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                isDefaultAction: true,
                isDestructiveAction: false,
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoActionSheetAction(
                isDefaultAction: false,
                child: Text("OK",style: TextStyle(color:Colors.grey[800]),),
                onPressed: () {
                  ApiCalls.submitReview(context, false,
                      titleController.text, Methods.getRating(rating), reviewController.text, nicknameController.text)
                      .then((value){
                        if(value)
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RatingFeedbackSuccess()));
                  });
                },
              )
            ],
          ),
        ));
  }

  getBody() {
    setState(() {
      if(_selectedIndex == 0){
        body = HomeWidget();
      }
      // else if(_selectedIndex == 1){
      //   body = MessagesWidget();
      // }
      else if(_selectedIndex == 1) {
        body = SearchWidget();
      } else if(_selectedIndex == 2) {
        body = MyIbloovWidget();
      }
    });
  }
  
}