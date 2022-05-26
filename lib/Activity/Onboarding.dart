import 'dart:io';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ibloov/Constants/ApiCalls.dart';

import 'package:ibloov/Constants/ColorList.dart';
import 'package:ibloov/Constants/Methods.dart';

import 'Signup.dart';
import 'Login.dart';
import 'GuestUser.dart';

var width, height;

class Onboarding extends StatefulWidget {
  @override
  OnboardingState createState() => OnboardingState();
}

class OnboardingState extends State<Onboarding> {

  int currentPos = 0;
  List<String> banner_slider = [
    //"assets/images/onboarding_1.png",
    "assets/images/onboarding_1.png",
    "assets/images/onboarding.png",
    "assets/images/splash.png",
  ];

  @override
  Widget build(BuildContext context) {

    /*Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => TicketQRCode()),
    );*/

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
          child: Stack(
              children: [
                CarouselSlider.builder(
                  itemCount: banner_slider.length,
                  options: CarouselOptions(
                      height: height,
                      autoPlayInterval: Duration(seconds: 30),
                      viewportFraction: 1.0,
                      autoPlay: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          currentPos = index;
                        });
                      }
                  ),
                  itemBuilder: (context,index){
                    return BannerImages(banner_slider[index]);
                  },
                ),
                Container(
                  height: height,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      gradient: LinearGradient(
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.0),
                            Colors.black,
                          ],
                          stops: [
                            0.0,
                            1.0
                          ])),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: height * 0.09,
                        child: Stack(
                          children: <Widget>[
                            ClipRect(
                              child: new BackdropFilter(
                                filter: new ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                                child: new Container(
                                  width: width,
                                  height: height * 0.09,
                                  decoration: new BoxDecoration(
                                      color: Colors.white.withOpacity(0.0)
                                  ),
                                  child: Container(
                                    color: ColorList.colorHeaderOpaque,
                                    height: height * 0.09,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 10.0),
                                  child: Row(
                                    children: <Widget>[
                                      /*Container(
                                        width: width * 0.4,
                                        child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0),
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                onTap: () => {
                                                  //ColorList.showToast("Language Settings"),
                                                },
                                                child: Row(
                                                  children: [
                                                    Image(
                                                      //image: AssetImage('assets/images/globe.png'),
                                                      image: AssetImage(''),
                                                      height: 22.0,
                                                      width: 22.0,
                                                    ),
                                                    Container(
                                                      height: 1.0,
                                                      width: 6.0,
                                                    ),
                                                    Text('EN',
                                                        style: TextStyle(
                                                            fontFamily: 'SF_Pro_600',
                                                            decoration: TextDecoration.none,
                                                            fontSize: 17.0,
                                                            color: Colors.transparent
                                                        )
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),*/
                                      Spacer(),
                                      Container(
                                        width: width * 0.5,
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(15.0, 0, 0.0, 2.0),
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                onTap: () => {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => GuestUser(null, null, null)),
                                                  ),
                                                },
                                                child: Text('Skip',
                                                    style: TextStyle(
                                                        fontFamily: 'SF_Pro_700',
                                                        decoration: TextDecoration.none,
                                                        fontSize: 15.0,
                                                        color: Colors.white
                                                    )
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: height * 0.13),
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Image.asset(
                        'assets/images/onboarding_logo.png',
                        width: width/7,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(
                        height: height * 0.018,
                      ),
                      Text(
                        'Fun awaits you!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'SF_Pro_700',
                          decoration: TextDecoration.none,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: banner_slider.map((url) {
                          int index = banner_slider.indexOf(url);
                          return Container(
                            width: 7.0,
                            height: 7.0,
                            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: currentPos == index
                                  ? ColorList.colorCorousalIndicatorActive
                                  : ColorList.colorCorousalIndicatorInactive,
                            ),
                          );
                        }).toList(),
                      ),
                      Container(
                        height: height * 0.015,
                      ),
                      Container(
                        width: width * 0.9,
                        height: 60.0,
                        child: Card(
                          color: ColorList.colorSplashBG,
                          elevation: 3.0,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          child: InkWell(
                            onTap: (){
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => Signup()),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(27.0, 15.0, 25.0, 15.0),
                              child: Row(
                                children: [
                                  Text(
                                    'Sign up with Email',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: 'SF_Pro_600',
                                      decoration: TextDecoration.none,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.normal,
                                      color: ColorList.colorAccent,
                                    ),
                                  ),
                                  Spacer(),
                                  Image.asset(
                                    'assets/images/email.png',
                                    width: 25.0,
                                    height: 25.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: height * 0.01,
                      ),
                      Container(
                        child: Card(
                          color: Colors.transparent,
                          elevation: 3.0,
                          child: ClipRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                              child: Container(
                                width: width * 0.9,
                                height: 50.0,
                                decoration: new BoxDecoration(
                                  color: Colors.white.withOpacity(0.0),
                                  border: new Border.all(color: Colors.white, width: 2.0),
                                  borderRadius: new BorderRadius.circular(10.0),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Methods.authGoogle(context, 'signup');
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Sign up with Google',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontFamily: 'SF_Pro_600',
                                            decoration: TextDecoration.none,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.normal,
                                            color: ColorList.colorAccent,
                                          ),
                                        ),
                                        Spacer(),
                                        Image.asset(
                                          'assets/images/google.png',
                                          width: 25.0,
                                          height: 25.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                      ),
                      Container(
                        height: height * 0.01,
                      ),
                      Container(
                        child: Card(
                          color: Colors.transparent,
                          elevation: 3.0,
                          child: ClipRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                              child: Container(
                                width: width * 0.9,
                                height: 50.0,
                                decoration: new BoxDecoration(
                                  color: Colors.white.withOpacity(0.0),
                                  border: new Border.all(color: Colors.white, width: 2.0),
                                  borderRadius: new BorderRadius.circular(10.0),
                                ),
                                child: InkWell(
                                  onTap: (){
                                    Methods.showComingSoon();
                                    //Methods.showToast("Sign up with Facebook");
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Sign up with Facebook',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontFamily: 'SF_Pro_600',
                                            decoration: TextDecoration.none,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.normal,
                                            color: ColorList.colorAccent,
                                          ),
                                        ),
                                        Spacer(),
                                        Image.asset(
                                          'assets/images/fb.png',
                                          width: 25.0,
                                          height: 25.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                      ),
                      if(Platform.isIOS)
                        Container(
                        height: height * 0.01,
                      ),
                      if(Platform.isIOS)
                        Container(
                        child: Card(
                          color: Colors.transparent,
                          elevation: 3.0,
                          child: ClipRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                              child: Container(
                                width: width * 0.9,
                                height: 50.0,
                                decoration: new BoxDecoration(
                                  color: Colors.white.withOpacity(0.0),
                                  border: new Border.all(color: Colors.white, width: 2.0),
                                  borderRadius: new BorderRadius.circular(10.0),
                                ),
                                child: InkWell(
                                  onTap: (){
                                    // Methods.showComingSoon();
                                    Methods.authApple(context, 'signup');
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Sign up with Apple',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontFamily: 'SF_Pro_600',
                                            decoration: TextDecoration.none,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.normal,
                                            color: ColorList.colorAccent,
                                          ),
                                        ),
                                        Spacer(),
                                        Image.asset(
                                          'assets/images/apple.png',
                                          width: 25.0,
                                          height: 25.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                      ),
                      Container(
                        height: height * 0.005,
                      ),
                      Container(
                        width: width * 0.9,
                        height: height * 0.05,
                        alignment: Alignment.center,
                        child: Card(
                          elevation: 0.0,
                          color: Colors.transparent,
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () => {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => Login()),
                              )
                            },
                            child: Row(
                              children: [
                                Spacer(),
                                Text(
                                  'Already have an Account?   ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'SF_Pro_600',
                                    decoration: TextDecoration.none,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.normal,
                                    color: ColorList.colorAccent,
                                  ),
                                ),
                                Text(
                                  'Sign in',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'SF_Pro_600',
                                    decoration: TextDecoration.none,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: ColorList.colorAccent,
                                  ),
                                ),
                                Spacer()
                              ],
                            ),
                          ),
                        )
                      ),
                      Container(
                        height: height * 0.03,
                      )
                    ],
                  ),
                ),
              ]
          )
      ),
    );
  }
}

class BannerImages extends StatelessWidget{

  String imgPath;

  BannerImages(this.imgPath);

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imgPath),
            fit: BoxFit.cover,
          ),
        )
    );
  }

}