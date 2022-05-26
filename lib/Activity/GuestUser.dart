import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import 'package:ibloov/Constants/ColorList.dart';
import 'package:ibloov/Constants/Methods.dart';
import 'package:uuid/uuid.dart';

import 'CreateEvents.dart';
import 'SelectInterest.dart';
import 'TermsCondition.dart';

var sampleText = "We need some information to customize your event experience.";
var terms = "By continuing, you agree that you are 13+ years old and you";
var accept = "accept our";
var termsOfService = "Terms of Service";
var privacy = "Privacy Policy";

class GuestUser extends StatefulWidget {
  Position _currentPosition;
  String _currentAddress, _dob;
  GuestUser(this._currentPosition, this._currentAddress, this._dob);

  @override
  GuestUserState createState() => GuestUserState();
}

class GuestUserState extends State<GuestUser> {
  var uuid = new Uuid();
  String _sessionToken;
  List<dynamic>_placeList = [];
  bool tapped = false;

  final dobController = TextEditingController();
  final locationController = TextEditingController();

  FocusNode dobFocusNode = new FocusNode();
  FocusNode locationFocusNode = new FocusNode();

  var height, width, location = '';

  _getCurrentLocation() {
    Methods.determinePosition().then((Position position) {
      setState(() {
        widget._currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          widget._currentPosition.latitude, widget._currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        var placeData = json.decode(json.encode(place.toJson()));
        String subLocality = placeData["subLocality"].length > 0 ? '${placeData["subLocality"]}, ' : "";
        String locality = placeData["locality"].length > 0 ? '${placeData["locality"]}, ' : "";
        String country = placeData["country"].length > 0 ? placeData["country"] : "";
        widget._currentAddress = '$subLocality$locality$country';
        locationController.text = widget._currentAddress;
        locationController.selection = TextSelection.fromPosition(TextPosition(offset: locationController.text.length));
      });

    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {

    if(widget._currentAddress == null)
      _getCurrentLocation();
    else {
      setState(() {
        locationController.text = widget._currentAddress;
        dobController.text = widget._dob;
      });
    }
    locationController.addListener(() {
      _onChanged();
    });

    super.initState();
  }

  void _onChanged() {
    if(tapped){
      if (_sessionToken == null) {
        setState(() {
          _sessionToken = uuid.v4();
        });
      }
      Methods.getSuggestion(
          locationController.text,
          _sessionToken
      ).then((value) {
        setState(() {
          _placeList = value;
        });
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ColorList.colorAccent,
      appBar:AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        flexibleSpace: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Padding(
              child: Text(
                "Back",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontFamily: 'SF_Pro_700',
                    fontSize: 17.0,
                    color: ColorList.colorBack,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none
                ),
              ),
              padding: EdgeInsets.only(top: 50.0, left: 20.0),
            )
        ),
      ),
      body: SingleChildScrollView(
        child: WillPopScope(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: width,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Not ready\nto Sign Up?",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 35,
                        color: ColorList.colorSplashBG,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      height: height * 0.02,
                    ),
                    Text(
                      sampleText,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    Container(
                      height: height * 0.025,
                    ),
                  ],
                ),
                Container(
                  height: height * 0.015,
                ),
                Card(
                  elevation: 0.0,
                  child: Container(
                      width: width,
                      child: TextFormField(
                        onTap: (){
                          FocusScope.of(context).requestFocus(new FocusNode());
                          DatePicker.showDatePicker(
                              context,
                              showTitleActions: true,
                              maxTime: DateTime(DateTime.now().year - 18, DateTime.now().month, DateTime.now().day - 1),
                              onConfirm: (date) {
                                dobController.text = DateFormat('dd/MM/yyyy').format(date);
                              },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en
                          );
                        },
                        controller: dobController,
                        focusNode: dobFocusNode,
                        enableInteractiveSelection: false,
                        textInputAction: TextInputAction.next,
                        cursorColor: ColorList.colorPrimary,
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: 'Date of Birth',
                          hintStyle: TextStyle(color: ColorList.colorGrayHint),
                          labelText: 'Date of Birth',
                          labelStyle: TextStyle(color: ColorList.colorGrayHint),
                          alignLabelWithHint: true,
                          prefixIcon: Image.asset('assets/images/dob_logo.png', height: 5.0, width: 5.0),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: ColorList.colorGrayBorder, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: ColorList.colorGrayBorder, width: 2),
                          ),
                        ),
                      )
                  ),
                ),
                Container(
                  height: height * 0.01,
                ),
                Card(
                  elevation: 0.0,
                  child: Container(
                      width: width,
                      child: TextFormField(
                        onTap: (){
                          setState(() {
                            if(!tapped){
                              tapped = true;
                              locationController.text = '';
                            }
                          });
                        },
                        controller: locationController,
                        focusNode: locationFocusNode,
                        textInputAction: TextInputAction.done,
                        cursorColor: ColorList.colorPrimary,
                        enableInteractiveSelection: false,
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: 'Location',
                          hintStyle: TextStyle(color: ColorList.colorGrayHint),
                          labelText: 'Location',
                          labelStyle: TextStyle(color: ColorList.colorGrayHint),
                          alignLabelWithHint: true,
                          prefixIcon: Image.asset('assets/images/location_logo.png', height: 5.0, width: 5.0),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: ColorList.colorGrayBorder, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: ColorList.colorGrayBorder, width: 2),
                          ),
                        ),
                      )
                  ),
                ),
                Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          height: width * 0.4,
                        ),
                        MaterialButton(
                          minWidth: width * 0.9,
                          height: 50.0,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          onPressed: () {

                            SystemChannels.textInput.invokeMethod('TextInput.hide');

                            setState(() {
                              widget._dob = dobController.text;
                              location = locationController.text;
                            });

                            if(widget._dob == null || widget._dob.isEmpty){
                              Methods.showToast('DOB field is empty!');
                              DatePicker.showDatePicker(
                                  context,
                                  showTitleActions: true,
                                  maxTime: DateTime(DateTime.now().year - 18, DateTime.now().month, DateTime.now().day - 1),
                                  onConfirm: (date) {
                                    dobController.text = DateFormat('dd/MM/yyyy').format(date);
                                  },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.en
                              );
                            } else if(location == null || location.isEmpty){
                              Methods.showToast('Location field is empty!');
                              _getCurrentLocation();
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SelectInterest('Guest', widget._currentPosition, widget._currentAddress, widget._dob)),
                              );
                            }
                          },
                          color: ColorList.colorSplashBG,
                          child: Text(
                            'Continue',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: 'SF_Pro_700',
                              decoration: TextDecoration.none,
                              fontSize: 15.0,
                              fontWeight: FontWeight.normal,
                              color: ColorList.colorAccent,
                            ),
                          ),
                        ),
                        Container(
                          height: height * 0.05,
                        ),
                        Container(
                            width: width * 0.88,
                            child: Column(
                              children: [
                                Center(
                                  child: Text(
                                    terms,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontFamily: 'SF_Pro_400',
                                    ),
                                  ),
                                ),
                                Container(
                                  width: width * 0.88,
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Spacer(),
                                      Text(
                                        accept,
                                        style: TextStyle(
                                          fontFamily: 'SF_Pro_400',
                                          decoration: TextDecoration.none,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                      Card(
                                        elevation: 0.0,
                                        child: InkWell(
                                          focusColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: (){
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => TermsCondition(),
                                                )
                                            );
                                          },
                                          child: Text(
                                            termsOfService,
                                            style: TextStyle(
                                              fontFamily: 'SF_Pro_400',
                                              decoration: TextDecoration.underline,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'and',
                                        style: TextStyle(
                                          fontFamily: 'SF_Pro_400',
                                          decoration: TextDecoration.none,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                      Card(
                                        elevation: 0.0,
                                        child: InkWell(
                                          focusColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: (){
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => CreateEvents(),
                                                )
                                            );
                                          },
                                          child: Text(
                                            privacy,
                                            style: TextStyle(
                                              fontFamily: 'SF_Pro_400',
                                              decoration: TextDecoration.underline,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                              ],
                            )
                        )
                      ],
                    ),
                    (tapped)
                        ? Container(
                            margin: EdgeInsets.only(left: 5.0, right: 5.0),
                            decoration: new BoxDecoration(
                              color: ColorList.colorAccent,
                              border: Border.all(color: Colors.black, width: 1.0),
                            ),
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _placeList.length + 1,
                              itemBuilder: (context, index) {
                                return (index == _placeList.length)
                                    ? Column(
                                        children: [
                                          Divider(color: Colors.black, height: 2.0,),
                                          Container(
                                            padding: EdgeInsets.all(10.0),
                                            alignment: Alignment.center,
                                            child: InkWell(
                                              onTap: (){
                                                setState(() {
                                                  _getCurrentLocation();
                                                  tapped = false;
                                                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                                                });
                                              },
                                              child: Text(
                                                'Use Current Location',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: ColorList.colorBlue
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    : Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(8.0),
                                            alignment: Alignment.center,
                                            child: InkWell(
                                              onTap: (){
                                                Methods.getPlaceDetails(_placeList[index]["place_id"])
                                                    .then((value) {
                                                      setState(() {
                                                        widget._currentAddress = locationController.text = _placeList[index]["description"];
                                                        widget._currentPosition = value;
                                                        locationController.selection = TextSelection.fromPosition(TextPosition(offset: locationController.text.length));
                                                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                                                        _placeList = [];
                                                        tapped = false;
                                                      });
                                                    });
                                              },
                                              child: Text(
                                                _placeList[index]["description"],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: ColorList.colorPrimary
                                                ),
                                              )
                                            ),
                                          ),
                                          Divider(color: Colors.black, height: 1.0,)
                                        ],
                                      );
                              },
                            ),
                          )
                        : Container()
                  ],
                ),
              ],
            ),
          ),
          onWillPop: (){
            Navigator.pop(context);
            return Future.value(true);
          },
        )
      )
    );
  }

}