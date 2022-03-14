import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ibloov/Activity/Splash.dart';

import 'Constants/Methods.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // navigation bar color
    statusBarColor: Colors.transparent, // status bar color
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ibloov',
      //theme: ThemeData(fontFamily: 'SF_Pro'),
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}

