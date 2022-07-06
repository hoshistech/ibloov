import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ibloov/Activity/ForgetPasswordSuccess.dart';
import 'package:ibloov/Activity/SelectInterest.dart';
import 'package:ibloov/Activity/VerificationSuccess.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:ibloov/Activity/Home.dart';
import 'package:ibloov/Activity/VerifyOTP.dart';

import 'Methods.dart';

class ApiCalls{

  // static String urlMain = 'https://api.ibloov.com/';
  static String urlMain = 'https://ibloov-auth-staging-868mc.ondigitalocean.app/ibloov-auth2/';

  static String urlSignup = urlMain + 'auth/signup';
  static String urlVerifyAccount = urlMain + 'auth/verify-account';
  static String urlResendOTP = urlMain + 'auth/resend-verification';
  static String urlLogin = urlMain + 'auth/login';
  static String urlGoogle = urlMain + 'auth/google';
  static String urlApple = urlMain + 'auth/apple';
  static String urlResetPasswordOTP = urlMain + 'auth/password/forgot';
  static String urlResetPassword = urlMain + 'auth/password/reset';
  static String urlRefreshToken = urlMain + 'auth/refresh-token/';
  static String urlGetInterests = urlMain + 'interest';
  static String urlUserDetails = urlMain + 'user/';
  static String urlUserFollowerCount = urlMain + 'user/profile/';
  static String urlFeedback = urlMain + 'feedback';
  static String urlEventList = urlMain + 'event/explore?';
  static String urlGetCategories = urlMain + 'category';
  static String urlToggleLike = urlMain + 'event/';
  static String urlEventDetails = urlMain + 'event/';
  static String urlCreateOrder = urlMain + 'order';
  static String urlCreatePayment = urlMain + 'payment';
  static String urlSupport = urlMain + 'help';
  static String urlSearchEvent = urlMain + 'event?pageNumber=';
  static String urlSearchArtist = urlMain + 'artist?pageNumber=';
  static String urlSearchUser = urlMain + 'user/search?pageNumber=';
  static String urlSearchHashtag = urlMain + 'event?pageNumber=';
  static String urlInformation = urlMain + 'business?type=';
  static String urlUpload = urlMain + 'file/upload';
  static String urlUserTicket = urlMain + 'user-ticket?eventId=';

  static var headersJSON = {
    'Content-Type': 'application/json'
  };

  static doLogin(email, password, context, proceed) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    Methods.showLoaderDialog(context);

    try {
      var request = http.Request('POST', Uri.parse(urlLogin));
      request.body = json.encode({
        "email": email,
        "password": password,
        "profileType": "USER",
      });
      request.headers.addAll(headersJSON);

      http.StreamedResponse response = await request.send();
      final jsonBody = jsonDecode(await response.stream.bytesToString());

      debugPrint("Login Response: $jsonBody");

      if (response.statusCode == 200) {
        Navigator.pop(context);
        var responseLogin = jsonBody;

        pref.setString('token', responseLogin['data']['token']);
        pref.setBool('google', false);
        Methods.saveUserData(pref, responseLogin['data']['user']);

        if(proceed){
          Methods.showToast(responseLogin['message']);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home())
          );
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => VerificationSuccess())
          );
        }

      } else {
        Navigator.pop(context);
        if(response.statusCode == 400){
          Methods.showError(jsonBody['error']);
        } else
          Methods.showError("Login Failed");
      }
    } on Exception catch(e) {
      Navigator.pop(context);
      Methods.showError('$e');
    }
  }

  static doSignup(fullName, email, phoneNumber, password, gender, username, dob, context) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    Methods.showLoaderDialog(context);

    try {
      var request = http.Request('POST', Uri.parse(urlSignup));
      request.body = json.encode({
        "fullName": fullName,
        "email": email,
        "phoneNumber": phoneNumber,
        "password": password,
        "gender": gender,
        "username": username,
        "dob": dob,
        "type": "USER",
        "profileType": "USER",
      });
      request.headers.addAll(headersJSON);

      http.StreamedResponse response = await request.send();
      final jsonBody = jsonDecode(await response.stream.bytesToString());
      debugPrint("Signup Response: $jsonBody");

      if (response.statusCode == 201) {
        Navigator.pop(context);
        var responseLogin = jsonBody;

        //doLogin(email, password, context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => VerifyOTP(email, password, responseLogin['data']['OTPToken'])),
        );
      }
      else {
        Navigator.pop(context);
        if(jsonBody != null){
          Methods.showError(jsonBody["error"]);
        } else
          Methods.showError("Oops! an error occurred");
      }
    } on Exception catch(e) {
      Navigator.pop(context);
      Methods.showError('$e');
    }
  }

  static authGoogle(token, context, type) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Methods.showLoaderDialog(context);

    try {
      var request = http.Request('POST', Uri.parse(urlGoogle));
      request.body = json.encode({"token": token, "profileType": "USER"});
      request.headers.addAll(headersJSON);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        Navigator.pop(context);
        var responseLogin = json.decode(await response.stream.bytesToString());

        debugPrint('Social: $responseLogin');

        pref.setString('token', responseLogin['data']['token']);
        pref.setBool('google', true);
        Methods.saveUserData(pref, responseLogin['data']['user']);

        if(responseLogin['message'].toString().toLowerCase().contains('login'))
          Methods.showToast(responseLogin['message']);

        Navigator.pushReplacement(
            context,
            (responseLogin['message'].toString().toLowerCase().contains('login'))
                ? MaterialPageRoute(builder: (context) => Home())
                : MaterialPageRoute(builder: (context) => SelectInterest('Reg', null, null, null))
        );

      } else {
        Navigator.pop(context);
        var data = await response.stream.bytesToString();
        print('Login error: $data');
        if(response.statusCode == 400){
          Methods.showError(json.decode(data)['error']);
        } else
          Methods.showError("An error occurred.");
      }
    } on Exception catch(e) {
      Navigator.pop(context);
      print('Login exception: $e');
      Methods.showError('$e');
    }
  }

  static authApple(token, context, type) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Methods.showLoaderDialog(context);

    try {
      var request = http.Request('POST', Uri.parse(urlApple));
      request.body = json.encode({"token": token, "profileType": "USER",});
      request.headers.addAll(headersJSON);

      debugPrint('AppleSocialRequest: ${request.body}');

      http.StreamedResponse response = await request.send();
      final jsonResponse = json.decode(await response.stream.bytesToString());
      debugPrint('AppleSocialResponse: $jsonResponse');

      if (response.statusCode == 201 || response.statusCode == 200) {
        Navigator.pop(context);
        var responseLogin = jsonResponse;

        pref.setString('token', responseLogin['data']['token']);
        pref.setBool('apple', true);
        Methods.saveUserData(pref, responseLogin['data']['user']);

        if(responseLogin['message'].toString().toLowerCase().contains('login'))
          Methods.showToast(responseLogin['message']);

        Navigator.pushReplacement(
            context,
            (responseLogin['message'].toString().toLowerCase().contains('login'))
                ? MaterialPageRoute(builder: (context) => Home())
                : MaterialPageRoute(builder: (context) => SelectInterest('Reg', null, null, null))
        );

      } else {
        Navigator.pop(context);
        debugPrint('Login error: $jsonResponse');
        if(response.statusCode == 400){
          Methods.showError(jsonResponse['error']);
        } else
          Methods.showError("An error occurred");
      }
    } on Exception catch(e) {
      Navigator.pop(context);
      debugPrint('Login exception: $e');
      Methods.showError('$e');
    }
  }

  static void verifyAccount(context, email, password, token, otp, controllerOTP) async {

    Methods.showLoaderDialog(context);

    try{
      var request = http.Request('POST', Uri.parse(urlVerifyAccount));
      request.body = json.encode({
        "OTPCode": int.parse(otp),
        "OTPToken": token,
        "email": email
      });
      request.headers.addAll(headersJSON);

      http.StreamedResponse response = await request.send();
      final jsonBody = json.decode(await response.stream.bytesToString());

      if (response.statusCode == 200) {
        Navigator.pop(context);
        doLogin(email, password, context, false);
      } else {
        Navigator.pop(context);
        Methods.showError('${jsonBody["error"] ?? "Verification failed"}');
        controllerOTP.clear();
      }

    } on Exception catch(e) {
      Navigator.pop(context);
      Methods.showError('Verification failed due to $e');
      controllerOTP.clear();
    }
  }

  static Future<String> resendOTP(email) async {

    try{
      var request = http.Request('POST', Uri.parse(urlResendOTP));

      request.body = json.encode({
        "email": email
      });
      request.headers.addAll(headersJSON);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var responseData = json.decode(await response.stream.bytesToString());
        Methods.showError(responseData['message']);
        return responseData['data']['OTPToken'];
      }
      else {
        Methods.showError('Can\'t send new OTP');
        return null;
      }

    }  on Exception catch(e) {
      Methods.showError('$e');
      return null;
    }
  }

  static Future<String> resetPasswordOTP(email) async {

    try{
      var request = http.Request('POST', Uri.parse(urlResetPasswordOTP));

      request.body = json.encode({
        "email": email
      });
      request.headers.addAll(headersJSON);

      http.StreamedResponse response = await request.send();
      final jsonBody = jsonDecode(await response.stream.bytesToString());
      debugPrint("resetPasswordOtp: $jsonBody");

      if (response.statusCode == 200) {
        var responseData = jsonBody;
        //Methods.showError(responseData['message']);
        //Methods.showError("$responseData");
        return responseData['data'];
      }
      else {
        Methods.showError('${jsonBody["error"] ?? "Error sending otp"}');
        return null;
      }

    }  on Exception catch(e) {
      Methods.showError('$e');
      return null;
    }
  }

  static void resetPassword(context, otp, token, password) async {
    Methods.showLoaderDialog(context);

    try{
      var request = http.Request('POST', Uri.parse(urlResetPassword));

      request.body = json.encode({
        "password": password,
        "code": otp,
        "codeToken": token,
        "profileType": "USER",
      });
      request.headers.addAll(headersJSON);

      http.StreamedResponse response = await request.send();
      final jsonBody = jsonDecode(await response.stream.bytesToString());
      debugPrint("resetPassword: $jsonBody");

      if (response.statusCode == 200) {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ForgetPasswordSuccess()),
        );
      }
      else {
        Navigator.pop(context);
        Methods.showError('${jsonBody["error"] ?? "Error setting new Password"}');
      }

    }  on Exception catch(e) {
      Navigator.pop(context);
      Methods.showError('$e');
    }
  }

  static Future<bool> refreshToken(context) async {

    SharedPreferences pref = await SharedPreferences.getInstance();

    try{
      var request = http.Request('GET', Uri.parse('$urlRefreshToken${pref.getString('_id')}'));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var responseToken = json.decode(await response.stream.bytesToString());
        pref.setString('token', responseToken['data']['token']);
        return true;
      }
      else if(response.statusCode == 404){
        Methods.showError('User not found!');
        Methods.logoutUser(context);
        return false;
      }
      else {
        Methods.showError('Session expired! Please login to continue...');
        Methods.logoutUser(context);
        return false;
      }

    } on SocketException {
      Methods.showError('Please check your internet connection');
    }
    on Exception catch(e) {
      refreshToken(context);
      Methods.showError('$e');
      return false;
    }
  }

  static Future<String> getInterests(context) async {

    Methods.showLoaderDialog(context);
    try{
      var request = http.Request('GET', Uri.parse(urlGetInterests));

      http.StreamedResponse response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        Navigator.pop(context);
        return responseData;
      }
      else {
        Navigator.pop(context);
        Methods.showError('${json.decode(await response.stream.bytesToString())["error"] ?? "Can\'t fetch categories"}');
        return null;
      }
    } on Exception catch(e) {
      Navigator.pop(context);
      Methods.showError('$e');
      return null;
    }

  }

  static Future<String> updateProfile(context, data) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    Methods.showLoaderDialog(context);

    try{
      var headers = {
        'Authorization': 'Bearer ${pref.getString('token')}',
        'Content-Type': 'application/json'
      };
      var request = http.Request('PATCH', Uri.parse(urlUserDetails + pref.getString('_id')));
      request.body = json.encode(data);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      print('Request url: $request');
      print('Request header: ${request.headers}');
      print('Request body: ${request.body}');

      var jsonBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        debugPrint('Response: $jsonBody');
        Navigator.pop(context);
        return jsonBody;
      }
      else {
        Navigator.pop(context);
        var jsonResponse = json.decode(jsonBody);
        Methods.showError(jsonResponse["error"]);
        return null;
      }

    } on Exception catch(e) {
      Navigator.pop(context);
      Methods.showError('$e');
      return null;
    }
  }

  static Future<bool> submitReview(context, isRating, title, rating, review, nickname) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    Methods.showLoaderDialog(context);

    try{
      var headers = {
        'Authorization': 'Bearer ${pref.getString('token')}',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse(urlFeedback));
      if(isRating){
        request.body = json.encode({
          "stars": rating
        });
      } else {
        request.body = json.encode({
          "stars": rating,
          "title": title,
          "review": review,
          "nickname": nickname
        });
      }
      request.headers.addAll(headers);

      debugPrint("Request: ${request.body}");

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        return true;
      }
      else {
        Navigator.pop(context);
        Methods.showError('Can\'t submit ${isRating ? 'Rating' : 'Review'}');
        print('Response: ${await response.stream.bytesToString()}');
        return false;
      }
    } on Exception catch(e) {
      Navigator.pop(context);
      Methods.showError('$e');
      print('Error: $e');
      return false;
    }
  }

  static Future<String> fetchEvents(context, latitude, longitude) async {

    //Methods.showLoaderDialog(context);

    try{
      var request = http.Request('GET', Uri.parse(urlEventList + 'longitude=$longitude&latitude=$latitude'));

      http.StreamedResponse response = await request.send();

      debugPrint('Request header: $request');
      final jsonString = await response.stream.bytesToString();

      debugPrint('exploreEvent: $jsonString');

      if (response.statusCode == 200) {
        var data = jsonString;

        print('Events: $data');

        return data;

      }
      else {
        Methods.showError("${json.decode(jsonString)["error"]}");
        return null;
      }

    } on Exception catch(e) {
      //Navigator.pop(context);
      Methods.showError('$e');
      print('Error: $e');
      return null;
    }
  }

  static Future<String> fetchCategories() async {

    try{
      var request = http.Request('GET', Uri.parse(urlGetCategories));

      http.StreamedResponse response = await request.send();

      print('Request header: $request');
      final jsonString = await response.stream.bytesToString();

      debugPrint('eventCategories: $jsonString');

      if (response.statusCode == 200) {
        return jsonString;
      }
      else {
        Methods.showError("${json.decode(jsonString)["error"] ?? "We couldn't fetch categories"}");
        return null;
      }

    } on Exception catch(e) {
      Methods.showError('$e');
      print('Error: $e');
      return null;
    }
  }

  static Future<bool> toggleLike(eventID) async {

    SharedPreferences pref = await SharedPreferences.getInstance();

    try{
      var headers = {
        'Authorization': 'Bearer ${pref.getString('token')}',
      };

      var request = http.Request('POST', Uri.parse('$urlToggleLike$eventID/toggle-like/'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        return true;
      }
      else {
        final jsonResponse = json.decode(await response.stream.bytesToString());
        Methods.showError('${jsonResponse["error"]}');

        debugPrint('Response: $jsonResponse');

        return false;
      }
    } on Exception catch(e) {
      Methods.showError('$e');
      print('Error: $e');
      return false;
    }
  }

  static Future<String> fetchEventDetails(context, id) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    Methods.showLoaderDialog(context);

    try{
      var headers = {
        'Authorization': 'Bearer ${pref.getString('token')}',
      };

      var request = http.Request('GET', Uri.parse('$urlEventDetails$id/details'));

      request.headers.addAll(headers);

      print('Request header: ${request.headers}');
      print('Request: $request');

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          Navigator.pop(context);
        });
        var data = await response.stream.bytesToString();
        print('Response: $data');
        return data;
      }
      else {
        Future.delayed(const Duration(milliseconds: 1000), () {
          Navigator.pop(context);
        });
        var data = json.decode(await response.stream.bytesToString());
        Methods.showError(data["error"]);

        return null;
      }

    } on Exception catch(e) {
      Navigator.pop(context);
      Methods.showError('$e');
      print('Error: $e');
      return null;
    }

  }

  static Future<String> fetchMoreEvents(context, id) async {

    SharedPreferences pref = await SharedPreferences.getInstance();

    try{
      var headers = {
        'Authorization': 'Bearer ${pref.getString('token')}',
      };

      var request = http.Request('GET', Uri.parse('$urlEventDetails$id/more'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        return await response.stream.bytesToString();
      }
      else {
        var data = json.decode(await response.stream.bytesToString());
        Methods.showError(data);
        return null;
      }

    } on Exception catch(e) {
      Methods.showError('$e');
      print('Error: $e');
      return null;
    }

  }

  static Future<String> fetchEventTickets(context, id) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    Methods.showLoaderDialog(context);

    try{
      var headers = {
        'Authorization': 'Bearer ${pref.getString('token')}',
      };

      var request = http.Request('GET', Uri.parse('$urlMain$id/ticket'));

      print('Ticket request: ${request.body}');

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          Navigator.pop(context);
        });
        var data = await response.stream.bytesToString();

        print('Ticket data: $data');

        return data;
      }
      else {
        Navigator.pop(context);
        var data = json.decode(await response.stream.bytesToString());
        Methods.showError(data["error"]);

        return null;
      }

    } on Exception catch(e) {
      Navigator.pop(context);
      Methods.showError('$e');
      print('Error: $e');
      return null;
    }

  }

  static Future<String> createOrder(context, data) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    Methods.showLoaderDialog(context);

    try {

      var headers = {
        'Authorization': 'Bearer ${pref.getString('token')}',
        'Content-Type': 'application/json'
      };

      var request = http.Request('POST', Uri.parse(urlCreateOrder));

      request.headers.addAll(headers);
      request.body = jsonEncode(data);

      debugPrint("createOrderRequest: ${request.body}");

      http.StreamedResponse response = await request.send();

      final jsonResponse = await response.stream.bytesToString();

      debugPrint("createOrderResponse: $jsonResponse");

      if (response.statusCode == 201) {
        Navigator.pop(context);
        // var responseData = await response.stream.bytesToString();
        return jsonResponse;

      } else {
        Navigator.pop(context);
        Methods.showError("${json.decode(jsonResponse)["error"]}");
        debugPrint("createOrderError: $jsonResponse");

        return null;
      }

    } on Exception catch(e) {
      Navigator.pop(context);
      Methods.showError('$e');
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<String> createFreeOrder(context, orderId) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    Methods.showLoaderDialog(context);

    try {

      var headers = {
        'Authorization': 'Bearer ${pref.getString('token')}',
        'Content-Type': 'application/json'
      };

      var request = http.Request('POST', Uri.parse('$urlCreatePayment/free-order'));

      request.headers.addAll(headers);
      request.body = json.encode({
        "orderId": orderId
      });

      debugPrint("FreeOrderRequest: ${request.body}");

      http.StreamedResponse response = await request.send();
      final jsonResponse = await response.stream.bytesToString();
      debugPrint("FreeOrderResponse: $jsonResponse");

      if (response.statusCode == 201) {
        Navigator.pop(context);
        var responseData = jsonResponse;
        return responseData;

      } else {
        Navigator.pop(context);
        var data = json.decode(jsonResponse);
        Methods.showError(data["error"]);

        return null;
      }
    } on Exception catch(e) {
      Navigator.pop(context);
      Methods.showError('$e');
      print('Error: $e');
      return null;
    }
  }

  static Future<String> createPayment(context, data) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    Methods.showLoaderDialog(context);

    try {

      var headers = {
        'Authorization': 'Bearer ${pref.getString('token')}',
        'Content-Type': 'application/json'
      };

      var request = http.Request('POST', Uri.parse(urlCreatePayment));

      request.headers.addAll(headers);
      request.body = jsonEncode(data);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        Navigator.pop(context);
        var responseData = await response.stream.bytesToString();
        print(responseData);
        return responseData;

      } else {
        Navigator.pop(context);
        var data = json.decode(await response.stream.bytesToString());
        Methods.showError(data["error"]);

        debugPrint(data);
        return null;

      }

    } on Exception catch(e) {
      Navigator.pop(context);
      Methods.showError('$e');
      print('Error: $e');
      return null;
    }
  }

  static Future<String> chargeOTP(context, data) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    Methods.showLoaderDialog(context);

    try {

      var headers = {
        'Authorization': 'Bearer ${pref.getString('token')}',
        'Content-Type': 'application/json'
      };

      var request = http.Request('POST', Uri.parse('$urlCreatePayment/charge-otp'));

      request.headers.addAll(headers);
      request.body = jsonEncode(data);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        Navigator.pop(context);
        var responseData = await response.stream.bytesToString();
        print(responseData);
        return responseData;

      } else {
        Navigator.pop(context);
        var data = json.decode(await response.stream.bytesToString());
        Methods.showError(data["error"]);

        debugPrint(data);
        return null;

      }

    } on Exception catch(e) {
      Navigator.pop(context);
      Methods.showError('$e');
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<bool> submitHelpRequest(helpSubject, helpDescription, context, {fullName, mail, phone}) async {

    SharedPreferences pref = await SharedPreferences.getInstance();

    Methods.showLoaderDialog(context);

    try{
      var headers = {
        'Authorization': 'Bearer ${pref.getString('token')}',
        'Content-Type': 'application/json'
      };

      var request = http.Request('POST', Uri.parse(urlSupport));

      request.body = json.encode({
        "subject": helpSubject,
        "description": helpDescription,
        "fullName": fullName,
        "mail": mail,
        "phone": phone
      });

      request.headers.addAll(headers);
      debugPrint('Help Request: ${request.body}');

      http.StreamedResponse response = await request.send();

      debugPrint('Help Response: ${await response.stream.bytesToString()}');

      if (response.statusCode == 201) {
        Navigator.pop(context);
        return true;
      }
      else {
        Navigator.pop(context);
        Methods.showError('Error submitting help request');
        return false;
      }
    } on Exception catch(e) {
      Navigator.pop(context);
      Methods.showError('$e');
      debugPrint('Error: $e');
      return false;
    }
  }

  static Future<String> searchEvents(query, page) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    try{
      var headers = {
        'Authorization': 'Bearer ${pref.getString('token')}',
      };
      var request = http.Request('GET', Uri.parse('$urlSearchEvent$page&perPage=10&query=$query'));

      request.headers.addAll(headers);
      debugPrint("headers: ${request.headers}");
      debugPrint("url: ${request.url}");

      http.StreamedResponse response = await request.send();
      final jsonString = await response.stream.bytesToString();

      debugPrint("search query: $query");
      debugPrint("Response: $jsonString");

      if (response.statusCode == 200) {
        String data = jsonString;
        return data;
      }
      else {
        var data = json.decode(jsonString);
        Methods.showError(data["error"]);

        debugPrint(data);
        return null;
      }
    } on Exception catch(e) {
      Methods.showError('$e');
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<String> searchArtists(query, page) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    try{
      var headers = {
        'Authorization': 'Bearer ${pref.getString('token')}',
      };
      var request = http.Request('GET', Uri.parse('$urlSearchArtist$page&perPage=10&query=$query'));

      request.headers.addAll(headers);

      print('$urlSearchArtist$page&perPage=10&query=$query');

      http.StreamedResponse response = await request.send();
      String data = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return data;
      } else {
        debugPrint(json.decode(data));
        return null;
      }
    } on Exception catch(e) {
      Methods.showError('$e');
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<String> searchUsers(query, page) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    try{
      var headers = {
        'Authorization': 'Bearer ${pref.getString('token')}',
      };
      var request = http.Request('GET', Uri.parse('$urlSearchUser$page&perPage=10&query=$query'));

      request.headers.addAll(headers);

      print('$urlSearchUser$page&perPage=10&query=$query');

      http.StreamedResponse response = await request.send();
      String data = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return data;
      }
      else {
        debugPrint(json.decode(data));
        return null;
      }
    } on Exception catch(e) {
      Methods.showError('$e');
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<String> searchHashtags(query, page) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    try{
      var headers = {
        'Authorization': 'Bearer ${pref.getString('token')}',
      };
      var request = http.Request('GET', Uri.parse('$urlSearchHashtag$page&perPage=10&hashtag=$query'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String data = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return data;
      }
      else {
        debugPrint(data);
        return null;
      }
    } on Exception catch(e) {
      Methods.showError('$e');
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<String> getInformation(keyword) async {
    try{
      var request = http.Request('GET', Uri.parse('$urlInformation$keyword'));

      http.StreamedResponse response = await request.send();

      String data = await response.stream.bytesToString();
      debugPrint(data);

      if (response.statusCode == 200) {
        return data;
      }
      else {
        return null;
      }

    } on Exception catch(e){
      Methods.showError('$e');
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<String> uploadFile(context, filetype, filePath) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    Methods.showLoaderDialog(context);

    try{
      var headers = {
        'Authorization': 'Bearer ${pref.getString('token')}',
        'Content-Type': 'application/json'
      };
      var request = http.MultipartRequest('POST', Uri.parse(urlUpload));
      request.fields.addAll({
        'fileType': filetype,
        'meta': '{ "userId": "${pref.getString('_id')}" }'
      });
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var data = await response.stream.bytesToString();
      debugPrint(data);

      if (response.statusCode == 201) {
        Navigator.pop(context);
        return data;
      }
      else {
        Navigator.pop(context);
        Methods.showError(json.decode(data)["error"]);
        return null;
      }
    } on Exception catch(e){
      Navigator.pop(context);
      Methods.showError('$e');
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<String> getTickets(id) async {

    SharedPreferences pref = await SharedPreferences.getInstance();

    try{
      var headers = {
        'Authorization': 'Bearer ${pref.getString('token')}',
      };

      var request = http.Request('GET', Uri.parse('$urlUserTicket$id'));
      //print('$urlUserTicket$id');

      request.headers.addAll(headers);
      //print('$headers');

      http.StreamedResponse response = await request.send();
      var data = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return data;
      }
      else {
        Methods.showError(json.decode(data)["error"]);
        debugPrint(data);
        return null;
      }

    } on Exception catch(e) {
      Methods.showError('$e');
      debugPrint('Error: $e');
      return null;
    }

  }

  static Future<String> reportEvent(reportSubject, reportDescription, context, id) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    Methods.showLoaderDialog(context);

    try{
      var headers = {
        'Authorization': 'Bearer ${pref.getString('token')}',
        'Content-Type': 'application/json'
      };

      var request = http.Request('POST', Uri.parse('$urlEventDetails$id/report'));

      request.body = json.encode({
        "title": reportSubject,
        "description": reportDescription
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var data = await response.stream.bytesToString();
      debugPrint(data);

      if (response.statusCode == 201) {
        Navigator.pop(context);
        return data;
      }
      else {
        Navigator.pop(context);
        Methods.showError('${json.decode(data)}');
        return null;
      }
    } on Exception catch(e) {
      Navigator.pop(context);
      Methods.showError('$e');
      debugPrint('Error: $e');
      return null;
    }
  }

  static Future<String> getProfileData() async {

    SharedPreferences pref = await SharedPreferences.getInstance();

    try{
      var headers = {
        'Authorization': 'Bearer ${pref.getString('token')}',
        'Content-Type': 'application/json'
      };
      var request = http.Request('GET', Uri.parse(urlUserFollowerCount + pref.getString('_id')));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var data = await response.stream.bytesToString();
      debugPrint(data);

      if (response.statusCode == 200) {
        return data;
      }
      else {
        print(await response.stream.bytesToString());
        Methods.showError("${json.decode(data)["error"]}");
        return null;
      }

    } on Exception catch(e) {
      Methods.showError('$e');
      return null;
    }
  }
}