import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:ibloov/Constants/ApiCalls.dart';
import 'package:ibloov/Constants/Methods.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Onboarding.dart';
import 'Home.dart';

var width, height;
bool isLoggedIn;

class Splash extends StatefulWidget {
  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> {
  PackageInfo _packageInfo = PackageInfo(version: 'Unknown');

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  getToken(){
    isLoggedIn
        ? ApiCalls.refreshToken(context)
              .then((value){
                if(value)
                  navigationToNextPage();
              })
        : navigationToNextPage();

  }

  void navigationToNextPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => isLoggedIn ? Home() : Onboarding()
      ),
    );
  }

  startSplashScreenTimer() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, getToken);
  }

  String getVersion() {
    String ver = 'Version: v${_packageInfo.version}';
    return ver;
  }

  @override
  void initState() {
    super.initState();

    _initPackageInfo();

    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startSplashScreenTimer();
    });

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: WillPopScope(
        child: Stack(
          children: [
            FutureBuilder(
              future: Methods.initializeFirebase(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print('Error initializing Firebase!');
                } else {
                  print('Firebase initialized successfully!');
                }
                return Container();
              },
            ),
            Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/splash.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                  child: Container(
                    width: width/2.5,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/logo.png'),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: width/3.5,
                        ),
                        Text(
                          'Fun awaits you!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'SF_Pro_700',
                            decoration: TextDecoration.none,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Container(
                  child: Text(getVersion(),
                      style: TextStyle(
                          fontFamily: 'SF_Pro_600',
                          decoration: TextDecoration.none,
                          fontSize: 12.0,
                          color: Colors.white
                      )),
                  color: Colors.transparent,
                ),
              ),
            )
          ],
        ),
        onWillPop: () {
          return Future.value(false);
        },
      )
    );
  }
}