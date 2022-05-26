import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ibloov/Activity/CreateEvents.dart';
import 'package:ibloov/Utils/FilterFrame.dart';
import 'package:share/share.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'package:ibloov/Activity/EventDetails.dart';
import 'package:ibloov/Activity/Login.dart';
import 'package:ibloov/Activity/SearchResult.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:social_share/social_share.dart';

import '../Activity/EditProfile.dart';
import 'ApiCalls.dart';
import 'ColorList.dart';

class Methods {

  static const kPLACES_API_KEY = "AIzaSyBVBEgcPYSJ-C7jNasP1xCXlhw-pJN-pJw";
  static const passwordAlert = "Password must contain:\n- 6 characters\n- at least one number\n- at least one uppercase letter\n- at least one special character from =.!&@#%";
  static const Pattern patternEmail = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  static var unescape = HtmlUnescape();
  static var data;
  static int locationIndex = 0, conditionIndex = 0, dateIndex = 0;
  static RangeValues rangeValues = const RangeValues(0, 0);
  static Position currentPosition;
  static String currentAddress = 'Fetching location...', conditionString, startDateString, endDateString, priceString = '';

  static void showError(msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      timeInSecForIosWeb: 2,
      backgroundColor: ColorList.colorPrimary,
      textColor: ColorList.colorAccent,
    );
  }

  static void showToast(msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
      backgroundColor: ColorList.colorPrimary,
      textColor: ColorList.colorAccent,
    );
  }

  static void showComingSoon() {
    Fluttertoast.showToast(
      msg: 'Feature coming soon!',
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
      backgroundColor: ColorList.colorPrimary,
      textColor: ColorList.colorAccent,
    );
  }

  static String allWordsCapitalize(str) {
    return str.toLowerCase().split(' ').map((word) {
      String leftText = (word.length > 1) ? word.substring(1, word.length) : '';
      return word[0].toUpperCase() + leftText;
    }).join(' ');
  }

  static showLoaderDialog(BuildContext context){
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        child: Center(
          child: CircularProgressIndicator(
            color: ColorList.colorAccent,
          ),
        ),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  static void saveUserData(SharedPreferences pref, responseData) {
    pref.setBool('isLoggedIn', true);
    pref.setString('_id', responseData['_id']);
    pref.setBool('isPhoneVerified', responseData['isVerified']);
    pref.setString('interests', responseData['interests'].toString());
    pref.setString('fullName', responseData['fullName']);
    pref.setString('email', responseData['email']);
    pref.setString('phoneNumber', responseData['phoneNumber']);
    pref.setString('gender', responseData['gender']);
    pref.setString('username', responseData['username']);
    pref.setString('dob', responseData['dob']);
    pref.setString('bio', responseData['bio']);
    pref.setString('imageUrl', responseData['imageUrl']);
    pref.setString('backgroundImage', responseData['backgroundImage']);
    pref.setString('referralCode', responseData['referralCode']);
    pref.setString('qrcode', responseData['qrcode']);
    pref.setString('currentAddress', 'Fetching location...');
    pref.setInt('categoriesCount', 0);
  }

  static Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  static authGoogle(context, type) async {
    try {
      final GoogleSignInAccount googleSignInAccount = await GoogleSignIn().signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        ApiCalls.authGoogle(googleSignInAuthentication.idToken, context, type);
      }
    } catch(e) {
      debugPrint("Google signAuth Error: ${e.toString()}");
    }
  }

  static authApple(context, type) async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      debugPrint("$credential");
      ApiCalls.authApple(credential.authorizationCode, context, type);

      // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
      // after they have been validated with Apple (see `Integration` section for more information on how to do this)
    } catch(e) {
      debugPrint("Apple signAuth Error: ${e.toString()}");
    }
  }

  static getRating(rating) {
    int rate = 0;
    for(int i=0; i<rating.length; i++)
      rate += rating[i];
    return rate;
  }

  static openSearch(context, searchController) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SearchResult(searchController)
      ),
    );
  }

  static shareEvent(url) async {
    await Share.share(
        'Hey, check out the event in the following link \n\n $url',
        subject: 'Share Event'
    );
  }

  static shareEmail(url) async {
    var _url = "mailto:?subject=Share Event&body=Hey,%20check%20out%20the%20event%20in%20the%20following%20link%20\n\n%20$url";
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  static shareTwitter(url) async {
    SocialShare.shareTwitter(
        "Hey, check out the event in the following link \n\n $url"
    );
  }

  static getImage(url, String placeholder) {
    if(url == null || url == '')
      return AssetImage('assets/images/$placeholder.png');
    else
      return NetworkImage(url);
  }

  static openEventDetails(BuildContext context, String id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventDetails(id)
      ),
    );
  }

  static openUserDetails(BuildContext context, String id) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateEvents(),
        )
    );
  }

  static openArtistDetails(BuildContext context, String id) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateEvents(),
        )
    );
  }

  static Future<List> getSuggestion(String input, String _sessionToken) async {

    List<dynamic>_placeList = [];

    String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    Uri request = Uri.parse('$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken');

    var response = await http.get(request);
    if (response.statusCode == 200) {
      _placeList = json.decode(response.body)['predictions'];
      print('$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken');
    } else {
      showError('Failed to load predictions!');
    }

    return _placeList;
  }

  static Future<Position> getPlaceDetails(String input) async {

    Position _selectedPosition;

    String baseURL = 'https://maps.googleapis.com/maps/api/place/details/json';
    Uri request = Uri.parse('$baseURL?input=bar&placeid=$input&key=$kPLACES_API_KEY');

    var response = await http.get(request);
    if (response.statusCode == 200) {
      var lat = json.decode(response.body)['result']['geometry']['location']['lat'];
      var lng = json.decode(response.body)['result']['geometry']['location']['lng'];
      _selectedPosition = new Position(latitude: lat, longitude: lng);
      print('$baseURL?input=bar&placeid=$input&key=$kPLACES_API_KEY');
    } else {
      showError('Failed to load predictions!');
    }

    print('SelectedPosition: $_selectedPosition');
    return _selectedPosition;
  }

  static getLowestPrice(data, free, {int multiplier = 1}) {
    int lowest = 0;
    String currency = '';

    if(data != null){
      if(data.length > 0) {
        if(data[0]['price'] != null)
          lowest = data[0]['price'];
        else
          lowest = 0;
        currency = data[0]['currency']['htmlCode'];
      }

      for(int i=0; i<data.length; i++){
        if(data[i]['price'] != null && lowest > data[i]['price']) {
          lowest = data[i]['price'];
          currency = data[i]['currency']['htmlCode'];
        }
      }
    }
    //return (lowest == 0 && free) ? 'Free' : "${unescape.convert(currency)}${formattedAmount(lowest)}";
    return "${unescape.convert(currency)}${formattedAmount(lowest * multiplier)}";
  }

  static getHighestPrice(data, {int multiplier = 1}) {
    int highest = 0;
    String currency;

    if(data.length > 0) {
      if(data[0]['price'] != null)
        highest = data[0]['price'];
      else
        highest = 0;
      currency = data[0]['currency']['htmlCode'];
    }
    for(int i=0; i<data.length; i++){
      if(data[i]['price'] != null && (highest < data[i]['price'])) {
        highest = data[i]['price'];
        currency = data[i]['currency']['htmlCode'];
      }
    }
    return data.length > 1 ? "  -  ${unescape.convert(currency)}${formattedAmount(highest * multiplier)}" : "";
  }

  static getCurrentUserData(context) async {
    var userData = {};

    SharedPreferences pref = await SharedPreferences.getInstance();
    userData['fullName'] = pref.getString('fullName');
    userData['email'] = pref.getString('email');

    return userData;
  }

  static formattedAmount(amount) {
    final value = new NumberFormat("#,##0", "en_US");
    return value.format(amount);
  }

  static Future<void> logoutUser(context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if(pref.getBool('isLoggedIn')){
      GoogleSignIn().disconnect();
    }

    await pref.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  static getComingSoon(height, width){
    return Container(
        height: height,
        alignment: Alignment.center,
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
                width: 120,
                height: 120,
                child: Image.asset('assets/images/coming_soon.png')
            ),
            Container(
                padding: EdgeInsets.only(top: 20),
                child: Center(
                  child: Text(
                    'COMING SOON',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'SF_Pro_700',
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      //color: ColorList.colorPrimary,
                      decoration: TextDecoration.none,
                      foreground: Paint()
                        ..shader = LinearGradient(
                          colors: <Color>[
                            Colors.black,
                            Colors.black.withOpacity(0.4)
                          ],
                        ).createShader(Rect.fromLTWH(100, 0, 200, 0)),
                      letterSpacing: width * 0.04,
                    ),
                  ),
                )
            ),
            Container(
                padding: EdgeInsets.only(top: 20, left: width * 0.15, right: width * 0.15),
                child: Center(
                  child: Text(
                    'We are launching this section very soon. Please come back later.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'SF_Pro_600',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: ColorList.colorPrimary.withOpacity(0.6),
                        decoration: TextDecoration.none
                    ),
                  ),
                )
            )
          ],
        )
    );
  }

  static openSearchFilter(context, height, width, focusNode){
    FocusScope.of(context).requestFocus(focusNode);
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    showModalBottomSheet(
        isScrollControlled: true,
        elevation: 15,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(50.0))),
        context: context,
        builder: (context) => FilterFrame(context, height, width)
    );
    //FilterFrame(context, height, width).slideSheet();
  }

  static getProfileCompleteStatus() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    bool completeProfile = true;

    completeProfile = !((preference?.getString('dob') == null || preference?.getString('dob')?.length == 0)
        && (!preference.getString('phoneNumber').contains('+') || preference.getString('phoneNumber') == 'N/A'));

    return completeProfile;
  }

  static showCompleteDialog(context, height, width, buyTicket) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: ColorList.colorPopUpBG,
          elevation: 20,
          child: Container(
            height: height * 0.35,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(35),
                  child: Column(
                    children: [
                      Image(
                        image: buyTicket
                            ? AssetImage("assets/images/complete_profile.png")
                            : AssetImage("assets/images/complete_profile_signup.png"),
                        width: width * (buyTicket ? 0.1 : 0.125),
                      ),
                      SizedBox(
                        height: height * 0.025,
                      ),
                      Text(
                        buyTicket
                            ? "Complete Profile"
                            : "Awesome!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'SF_Pro_700',
                          decoration: TextDecoration.none,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: ColorList.colorPrimary,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Text(
                        buyTicket
                            ? "Kindly fill out the rest of your info to enable your ticket purchase"
                            : "Congratulation and welcome to iBloov.\nKindly complete your profile setup",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'SF_Pro_400',
                          decoration: TextDecoration.none,
                          fontSize: 13.0,
                          fontWeight: FontWeight.normal,
                          color: ColorList.colorPrimary,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 1,
                  color: ColorList.colorHeaderOpaque,
                ),
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfile()),
                    );
                  },
                  child: Container(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        "Go to Profile",
                        style: TextStyle(
                          fontFamily: 'SF_Pro_600',
                          decoration: TextDecoration.none,
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          color: ColorList.colorSearchListMore,
                        ),
                      )
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

//https://www.whatsappprofiledpimages.com/wp-content/uploads/2021/08/Profile-Photo-Wallpaper.jpg