import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:ibloov/Constants/ColorList.dart';

import 'Home.dart';

var width, height;

class SignupSuccess extends StatefulWidget{
  @override
  SignupSuccessState createState() => SignupSuccessState();
}

class SignupSuccessState extends State<SignupSuccess> {
  @override
  Widget build(BuildContext context) {

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        height: height,
        width: width,
        color: ColorList.colorAccent,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: height * 0.35,
              ),
              Container(
                  width: height * 0.1,
                  height: height * 0.1,
                  child: Image.asset('assets/images/create_success.png')),
              SizedBox(
                height: height * 0.03,
              ),
              SizedBox(
                width: width * 0.5,
                child: Container(
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          "Account created successfully!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'SF_Pro_700',
                              decoration: TextDecoration.none,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
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
                      MaterialPageRoute(builder: (context) => Home())
                  );
                },
                color: ColorList.colorSplashBG,
                child: Text(
                  'Proceed to Home',
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
      )
    );
  }
}