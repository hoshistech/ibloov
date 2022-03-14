import 'package:flutter/material.dart';

import 'package:ibloov/Constants/ColorList.dart';

import 'Login.dart';

var width, height, ratio;

class ForgetPasswordSuccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    ratio = MediaQuery.of(context).devicePixelRatio/2.625;

    return Scaffold(
      body: WillPopScope(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 200 * ratio,
              ),
              Padding(
                padding: EdgeInsets.only(top:20),
                child: Center(
                  child: Container(
                      width: height * 0.1,
                      height: height * 0.1,
                      child: Image.asset('assets/images/create_success.png')),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(top:20),
                child: SizedBox(
                  child: Container(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                              "New Password Created!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'SF_Pro_700',
                                decoration: TextDecoration.none,
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                                color: ColorList.colorPrimary,
                              )
                          ),
                          Container(
                            height: 15.0,
                          ),
                          Text(
                              "Your new password is now in effect.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'SF_Pro_400',
                                decoration: TextDecoration.none,
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal,
                                color: ColorList.colorPrimary,
                              )
                          ),
                          Text(
                              "Your May procced to log in",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'SF_Pro_400',
                                decoration: TextDecoration.none,
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal,
                                color: ColorList.colorPrimary,
                              )
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: width * 0.25,
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
                      MaterialPageRoute(builder: (context) => Login())
                  );
                },
                color: ColorList.colorSplashBG,
                child: Text(
                  'Proceed to Login',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'SF_Pro_700',
                    decoration: TextDecoration.none,
                    fontSize: 15.0,
                    fontWeight: FontWeight.normal,
                    color: ColorList.colorAccent,
                  ),
                ),
              )
            ],
          ),
        ),
        onWillPop: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Login())
          );
          return null;
        },
      )
    );
  }
}