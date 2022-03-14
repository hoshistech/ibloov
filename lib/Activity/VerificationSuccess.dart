import 'package:flutter/material.dart';

import 'package:ibloov/Constants/ColorList.dart';

import 'SelectInterest.dart';

var width,height;

class VerificationSuccess extends StatefulWidget {
  @override
  VerificationSuccessState createState() => VerificationSuccessState();
}

class VerificationSuccessState extends State<VerificationSuccess>{

  @override
  Widget build(BuildContext context) {

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: WillPopScope(
        child: Container(
          height: height,
          width: width,
          color: ColorList.colorAccent,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: height * 0.2,
                ),
                Container(
                    width: 120,
                    height: 120,
                    child: Image.asset('assets/images/phone_verified.png')
                ),
                Padding(
                  padding: EdgeInsets.only(top:height * 0.05),
                  child: Text(
                    "Great!",
                    style: TextStyle(
                        fontFamily: 'SF_Pro_700',
                        decoration: TextDecoration.none,
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10.0, height * 0.01, 10.0, height * 0.005),
                  child: Center(
                    child: Text(
                      "Your Email has been Verified",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          height: 1.75,
                          fontFamily: 'SF_Pro_700',
                          decoration: TextDecoration.none,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
                Container(
                  height: height * 0.15,
                ),
                MaterialButton(
                  minWidth: width * 0.9,
                  height: 50.0,
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SelectInterest('Reg', null, null, null)),
                    );
                  },
                  color: ColorList.colorSplashBG,
                  child: Text(
                    'Next',
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
              ],
            ),
          ),
        ),
        onWillPop: () {
          return Future.value(false);
        },
      )
    );
  }
}