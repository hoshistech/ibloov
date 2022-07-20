import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ibloov/Activity/CreateEvents.dart';
import 'package:ibloov/Utils/FilterFrame.dart';
import 'package:ibloov/model/ticket.dart';
import 'package:location/location.dart' as location;
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
  static const passwordAlert =
      "Password must contain:\n- 6 characters\n- at least one number\n- at least one uppercase letter\n- at least one special character from =.!&@#%";
  static const Pattern patternEmail =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  static var unescape = HtmlUnescape();
  static var data;
  static int locationIndex = 0, conditionIndex = 0, dateIndex = 0;
  static RangeValues rangeValues = const RangeValues(0, 0);
  static Position currentPosition;
  static String currentAddress = 'Fetching location...',
      conditionString,
      startDateString,
      endDateString,
      priceString = '';

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

  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    location.Location _location = location.Location();
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      Methods.showToast("Please enable location services in settings");

      serviceEnabled = await _location.requestService();

      if (!serviceEnabled) {
        Future.error('Location services are disabled.');
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        Methods.showToast("Please, enable location services");

        serviceEnabled = await _location.requestService();

        if (!serviceEnabled) {
          return Future.error('Location permissions are denied');
        }
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      Methods.showToast("Please, enable location services");

      serviceEnabled = await _location.requestService();

      if (!serviceEnabled) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
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

  static showLoaderDialog(BuildContext context) {
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
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static void saveUserData(SharedPreferences pref, responseData) {
    debugPrint("profileDetails: $responseData");

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
      final GoogleSignInAccount googleSignInAccount =
          await GoogleSignIn().signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        ApiCalls.authGoogle(googleSignInAuthentication.idToken, context, type);
      }
    } catch (e) {
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

      debugPrint("Credential: ${credential.authorizationCode}");
      ApiCalls.authApple(credential.identityToken, context, type);

      // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
      // after they have been validated with Apple (see `Integration` section for more information on how to do this)
    } catch (e) {
      debugPrint("Apple signAuth Error: ${e.toString()}");
    }
  }

  static int getRating(rating) {
    int rate = 0;
    for (int i = 0; i < rating.length; i++) rate += rating[i];
    return rate;
  }

  static openSearch(context, searchController) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchResult(searchController)),
    );
  }

  static shareEvent(url) async {
    await Share.share(
        'Hey, check out the event in the following link \n\n $url',
        subject: 'Share Event');
  }

  static shareEmail(email, url) async {
    var _url =
        "mailto:$email?subject=ShareEvent&body=Hey,%20check%20out%20the%20event%20in%20the%20following%20link%20%20$url";
    if (!await launchUrl(Uri.parse(_url))) throw 'Could not launch $_url';
  }

  static sendEmailToOrganizer(email, url, name, {String eventName}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var phoneNumber = pref.get("phoneNumber");

    String encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: '$email',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Event Enquiry',
        'body':
            "Hey $name, \n\nI want to enquire about the event $eventName.\n\nAccess with this link: $url \n\n\n${phoneNumber != null ? "My contact number is $phoneNumber" : ""}"
      }),
    );

    launchUrl(emailLaunchUri).catchError((error) {
      debugPrint("Unable to launch!");
    });

    // var _url = "mailto:$email?subject=ShareEvent&body=Hey,%20check%20out%20the%20event%20in%20the%20following%20link%20%20$url";
  }

  static shareTwitter(url) async {
    SocialShare.shareTwitter(
        "Hey, check out the event in the following link \n\n $url");
  }

  static getImage(url, String placeholder) {
    if (url == null || url == '')
      return AssetImage('assets/images/$placeholder.png');
    else
      return NetworkImage(url);
  }

  static Widget getSmallEventCardImage(url, {width, height}) {
    String img = url;
    if (url != null && url.contains("default_banner")) img = null;

    return Container(
      width: width,
      height: height,
      color: ColorList.colorPrimary.withOpacity(0.6),
      child: CachedNetworkImage(
        imageUrl: img ?? "",
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            // color: ColorList.colorPrimary.withOpacity(0.6),
            image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    ColorList.colorPrimary.withOpacity(0.6), BlendMode.darken)),
          ),
        ),
        placeholder: (context, url) => Center(
            child: SizedBox(
                height: 60, width: 60, child: CircularProgressIndicator())),
        errorWidget: (context, url, error) => Image.asset(
          'assets/images/event_small.png',
          fit: BoxFit.cover,
          color: ColorList.colorPrimary.withOpacity(0.1),
          colorBlendMode: BlendMode.darken,
        ),
      ),
    );
    // if(url == null || url == '')
    //   return AssetImage('assets/images/event_small.png');
    // else
    //   return NetworkImage(url);
  }

  static Widget getLargeeEventCardImage(String url, {width, height}) {
    String img = url;
    if (url != null && url.contains("default_banner")) img = null;

    return Container(
      width: width,
      height: height,
      color: ColorList.colorPrimary.withOpacity(0.6),
      child: CachedNetworkImage(
        imageUrl: img ?? "",
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            color: ColorList.colorPrimary.withOpacity(0.6),
            image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.fill,
                colorFilter: ColorFilter.mode(
                    ColorList.colorPrimary.withOpacity(0.6), BlendMode.dstOut)),
          ),
        ),
        placeholder: (context, url) => Center(
            child: SizedBox(
                height: 60, width: 60, child: CircularProgressIndicator())),
        errorWidget: (context, url, error) => Image.asset(
          'assets/images/event_large.png',
          fit: BoxFit.cover,
          color: ColorList.colorPrimary.withOpacity(0.6),
          colorBlendMode: BlendMode.darken,
        ),
      ),
    );
  }

  static getLargeEventCardImage(url) {
    if (url == null || url == '')
      return AssetImage('assets/images/event_large.png');
    else
      return NetworkImage(url);
  }

  static openEventDetails(BuildContext context, String id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventDetails(id)),
    );
  }

  static openUserDetails(BuildContext context, String id) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateEvents(),
        ));
  }

  static openArtistDetails(BuildContext context, String id) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateEvents(),
        ));
  }

  static Future<List> getSuggestion(String input, String _sessionToken) async {
    List<dynamic> _placeList = [];

    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    Uri request = Uri.parse(
        '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken');

    var response = await http.get(request);
    if (response.statusCode == 200) {
      _placeList = json.decode(response.body)['predictions'];
      print(
          '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken');
    } else {
      showError('Failed to load predictions!');
    }

    return _placeList;
  }

  static Future<Position> getPlaceDetails(String input) async {
    Position _selectedPosition;

    String baseURL = 'https://maps.googleapis.com/maps/api/place/details/json';
    Uri request =
        Uri.parse('$baseURL?input=bar&placeid=$input&key=$kPLACES_API_KEY');

    var response = await http.get(request);
    if (response.statusCode == 200) {
      var lat =
          json.decode(response.body)['result']['geometry']['location']['lat'];
      var lng =
          json.decode(response.body)['result']['geometry']['location']['lng'];
      _selectedPosition = new Position(latitude: lat, longitude: lng);
      print('$baseURL?input=bar&placeid=$input&key=$kPLACES_API_KEY');
    } else {
      showError('Failed to load predictions!');
    }

    print('SelectedPosition: $_selectedPosition');
    return _selectedPosition;
  }

  static getLowestPrice(tickets, free, {int multiplier = 1}) {
    int lowest = 0;
    String currency = '';

    if (tickets != null) {
      if (tickets is List<Tickets>) {
        if (tickets.length > 0) {
          if (tickets[0].price != null)
            lowest = tickets[0].price;
          else
            lowest = 0;
          currency = tickets[0]?.currency?.htmlCode ?? "";
        }

        for (int i = 0; i < tickets.length; i++) {
          if (tickets[i]?.price != null && lowest > tickets[i]?.price) {
            lowest = tickets[i].price;
            currency = tickets[i]?.currency?.htmlCode ?? "";
          }
        }
      } else {
        if (tickets.length > 0) {
          if (tickets[0]['price'] != null)
            lowest = tickets[0]['price'];
          else
            lowest = 0;
          currency = tickets[0]['currency'] != null
              ? tickets[0]['currency']['htmlCode']
              : "";
        }

        for (int i = 0; i < tickets.length; i++) {
          if (tickets[i]['price'] != null && lowest > tickets[i]['price']) {
            lowest = tickets[i]['price'];
            currency = tickets[i]['currency'] != null ? tickets[i]['currency']['htmlCode'] : "";
          }
        }
      }
    }
    //return (lowest == 0 && free) ? 'Free' : "${unescape.convert(currency)}${formattedAmount(lowest)}";
    return "${unescape.convert(currency)}${formattedAmount(lowest * multiplier)}";
  }

  static getHighestPrice(tickets, {int multiplier = 1}) {
    int highest = 0;
    String currency;

    if (tickets is List<Tickets>) {
      if (tickets.length > 0) {
        if (tickets[0].price != null)
          highest = tickets[0].price;
        else
          highest = 0;
        currency = tickets[0]?.currency?.htmlCode ?? "";
      }

      for (int i = 0; i < tickets.length; i++) {
        if (tickets[i]?.price != null && highest < tickets[i]?.price) {
          highest = tickets[i].price;
          currency = tickets[i]?.currency?.htmlCode ?? "";
        }
      }
    } else {
      if (tickets.length > 0) {
        if (tickets[0]['price'] != null)
          highest = tickets[0]['price'];
        else
          highest = 0;
        if (tickets[0]['currency'] != null)
          currency = tickets[0]['currency']['htmlCode'];
      }
      for (int i = 0; i < tickets.length; i++) {
        if (tickets[i]['price'] != null && (highest < tickets[i]['price'])) {
          highest = tickets[i]['price'];
          if (tickets[i]['currency'] != null)
            currency = tickets[i]['currency']['htmlCode'];
        }
      }
    }

    return tickets.length > 1
        ? "  -  ${unescape.convert(currency ?? "")}${formattedAmount(highest * multiplier)}"
        : "";
  }

  static getCurrentUserData(context) async {
    var userData = {};

    SharedPreferences pref = await SharedPreferences.getInstance();
    userData['fullName'] = pref.getString('fullName');
    userData['email'] = pref.getString('email');

    return userData;
  }

  static formattedAmount(amount) {
    final value = new NumberFormat.currency(decimalDigits: 2, name: "");
    debugPrint("amount to format: $amount");
    if (amount == null) {
      return "0.00";
    }
    return value.format(amount);
  }

  static Future<void> logoutUser(context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (pref.getBool('isLoggedIn') ?? false) {
      GoogleSignIn().disconnect();
    }

    await pref.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  static getComingSoon(height, width) {
    return Container(
        height: height,
        alignment: Alignment.center,
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
                width: 120,
                height: 120,
                child: Image.asset('assets/images/coming_soon.png')),
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
                )),
            Container(
                padding: EdgeInsets.only(
                    top: 20, left: width * 0.15, right: width * 0.15),
                child: Center(
                  child: Text(
                    'We are launching this section very soon. Please come back later.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'SF_Pro_600',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: ColorList.colorPrimary.withOpacity(0.6),
                        decoration: TextDecoration.none),
                  ),
                ))
          ],
        ));
  }

  static openSearchFilter(context, height, width, focusNode, VoidCallback onApply) {
    FocusScope.of(context).requestFocus(focusNode);
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    showModalBottomSheet(
        isScrollControlled: true,
        elevation: 15,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(50.0))),
        context: context,
        builder: (context) => FilterFrame(context, height, width, onApply));
  }

  static getProfileCompleteStatus() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    bool completeProfile = true;

    completeProfile = !((preference?.getString('dob') == null ||
            preference?.getString('dob')?.length == 0) &&
        (!(preference.getString('phoneNumber')?.contains('+') ?? false) ||
            preference.getString('phoneNumber') == 'N/A'));

    return completeProfile;
  }

  static showCompleteDialog(context, height, width, buyTicket) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                            : AssetImage(
                                "assets/images/complete_profile_signup.png"),
                        width: width * (buyTicket ? 0.1 : 0.125),
                      ),
                      SizedBox(
                        height: height * 0.025,
                      ),
                      Text(
                        buyTicket ? "Complete Profile" : "Awesome!",
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
                      )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static showSignInSignUpDialog(context, height, width) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                        image: AssetImage("assets/images/icon_error.png"),
                        width: width * 0.125,
                      ),
                      SizedBox(
                        height: height * 0.025,
                      ),
                      Text(
                        "You are not signed in",
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
                        "Kindly sign in or Sign up to complete your ticket purchase",
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
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  child: Container(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        "Sign up/Log in",
                        style: TextStyle(
                          fontFamily: 'SF_Pro_600',
                          decoration: TextDecoration.none,
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          color: ColorList.colorSearchListMore,
                        ),
                      )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static showDeleteAccountDialog(context, height, width) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: ColorList.colorPopUpBG,
          elevation: 20,
          child: Container(
            // height: height * 0.4,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(35),
                    child: Column(
                      children: [
                        Image(
                          image: AssetImage("assets/images/icon_error.png"),
                          width: width * 0.125,
                        ),
                        SizedBox(
                          height: height * 0.025,
                        ),
                        Text(
                          "You are about to delete your account?",
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
                          "Deleting your account will delete your data from our systems and you won't be able to sign in again.",
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
                  Container(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              showLoaderDialog(context);

                              final result = await ApiCalls.deleteAccount()
                                  .whenComplete(() => Navigator.pop(context))
                                  .onError((error, stackTrace) {
                                return false;
                              });

                              if (result) {
                                showToast("Account successfully deleted.");

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()),
                                );
                              }
                            },
                            child: Text(
                              "Delete",
                              style: TextStyle(
                                fontFamily: 'SF_Pro_600',
                                decoration: TextDecoration.none,
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                                color: ColorList.colorRed,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontFamily: 'SF_Pro_600',
                                decoration: TextDecoration.none,
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                                color: ColorList.colorSearchListMore,
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
