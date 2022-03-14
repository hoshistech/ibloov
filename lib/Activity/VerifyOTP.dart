import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ibloov/Constants/ApiCalls.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

import 'package:ibloov/Constants/ColorList.dart';
import 'package:ibloov/Constants/Methods.dart';

import 'Signup.dart';

double width, height, ratio;

class VerifyOTP extends StatefulWidget {

  String email, password, token;

  VerifyOTP(this.email, this.password, this.token);

  @override
  VerifyOTPState createState() => VerifyOTPState();
}

class VerifyOTPState extends State<VerifyOTP>{
  TextEditingController controllerOTP = TextEditingController(text: "");
  int pinLength = 4;
  bool hasError = false;
  Timer _timer;
  int _start = 59;
  String time = '00:59';

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
            if(_start > 9)
              time = '00:$_start';
            else
              time = '00:0$_start';
          });
        }
      },
    );
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    controllerOTP.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    ratio = MediaQuery.of(context).devicePixelRatio/2.625;

    return Scaffold(
      body: WillPopScope(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                child: Stack(
                  children: [
                    InkWell(
                        onTap: (){
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Signup()),
                          );
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
                          padding: EdgeInsets.only(top: 8.0),
                        )
                    ),
                    Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        color: ColorList.colorSplashBG,
                        colorBlendMode: BlendMode.modulate,
                        width: width * 0.25,
                      ),
                    )
                  ],
                ),
                padding: EdgeInsets.fromLTRB(5.0, height * 0.05, 5.0, height * 0.05),
              ),
              Container(
                height: height * 0.01,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: height * 0.05,
                    width: width * 0.05,
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/verify.png',
                      width: width * 0.05,
                    ),
                  ),
                  Container(
                    width: 10,
                  ),
                  Container(
                    child: Text(
                      //'Enter the code to\nverify your phone',
                      'Verify your email',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'SF_Pro_700',
                        decoration: TextDecoration.none,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: ColorList.colorPrimary,
                      ),
                    ),
                  ),
                  Spacer(),
                  Column(
                    children: [
                      Text(
                        'Step   ',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'SF_Pro_700',
                          decoration: TextDecoration.none,
                          fontSize: 15.0,
                          fontWeight: FontWeight.normal,
                          color: ColorList.colorGrayText,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '2',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: 'SF_Pro_700',
                              decoration: TextDecoration.none,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: ColorList.colorPrimary,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 0.6),
                            child: Text(' of 3',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: 'SF_Pro_700',
                                decoration: TextDecoration.none,
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal,
                                color: ColorList.colorGrayText,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Container(
                    width: width * 0.01,
                  )
                ],
              ),
              Container(
                height: height * 0.015,
              ),
              Container(
                child: RichText(
                  text: TextSpan(
                      text: 'Enter the code sent via email to ',
                      style: TextStyle(
                        fontFamily: 'SF_Pro_400',
                        decoration: TextDecoration.none,
                        fontSize: 15.0,
                        fontWeight: FontWeight.normal,
                        color: ColorList.colorPrimary,
                      ),
                      children: <TextSpan>[
                        TextSpan(text: widget.email,
                          style: TextStyle(
                            height: 1.5,
                            fontFamily: 'SF_Pro_700',
                            decoration: TextDecoration.none,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: ColorList.colorPrimary,
                          ),
                        )
                      ]
                  ),
                ),
              ),
              Container(
                height: height * 0.02,
              ),
              Container(
                height: height * 0.075,
                width: width,
                child: Center(
                  child: GestureDetector(
                    onLongPress: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content:
                              Text("Paste OTP?"),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () async {
                                      var copiedText =
                                      await Clipboard.getData("text/plain");
                                      if (copiedText.text.isNotEmpty) {
                                        controllerOTP.text = copiedText.text;
                                      }
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("YES")),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("No"))
                              ],
                            );
                          });
                    },
                    child: PinCodeTextField(
                      autofocus: false,
                      controller: controllerOTP,
                      hideCharacter: false,
                      highlight: true,
                      highlightColor: ColorList.colorGrayBorder,
                      defaultBorderColor: ColorList.colorGrayBorder,
                      hasTextBorderColor: ColorList.colorGrayBorder,
                      highlightPinBoxColor: Colors.transparent,
                      maxLength: pinLength,
                      hasError: hasError,
                      maskCharacter: "😎",
                      onTextChanged: (text) {
                        setState(() {
                          hasError = false;
                        });
                      },
                      onDone: (otp) {
                        Methods.showToast('Verifying OTP...');
                        ApiCalls.verifyAccount(context, widget.email, widget.password, widget.token, otp, controllerOTP);
                      },
                      pinBoxWidth: height * 0.075,
                      pinBoxHeight: height * 0.075,
                      hasUnderline: false,
                      pinBoxOuterPadding: EdgeInsets.all(width * 0.03),
                      wrapAlignment: WrapAlignment.spaceEvenly,
                      pinBoxDecoration:
                      ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                      pinTextStyle: TextStyle(
                          fontSize: 22.0 * ratio,
                          color: ColorList.colorSplashBG,
                          fontWeight: FontWeight.bold
                      ),
                      pinTextAnimatedSwitcherTransition: ProvidedPinBoxTextAnimation.scalingTransition,
                      pinTextAnimatedSwitcherDuration: Duration(milliseconds: 300),
                      highlightAnimation: true,
                      highlightAnimationBeginColor: ColorList.colorPrimary,
                      highlightAnimationEndColor: ColorList.colorPrimary,
                      pinBoxRadius: 10 * ratio,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
              ),
              Container(
                height: height * 0.5,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  RichText(
                    text: TextSpan(
                        text: 'Didn’t get code? ',
                        style: TextStyle(
                          fontFamily: 'SF_Pro_400',
                          decoration: TextDecoration.none,
                          fontSize: 15.0,
                          fontWeight: FontWeight.normal,
                          color: ColorList.colorPrimary,
                        ),
                        children: <TextSpan>[
                          TextSpan(text: 'Resend code',
                              style: TextStyle(
                                fontFamily: 'SF_Pro_400',
                                decoration: TextDecoration.none,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: _start == 0 ? ColorList.colorSplashBG : ColorList.colorGray,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  if (_start == 0) {
                                    setState(() {
                                      ApiCalls.resendOTP(widget.email)
                                          .then((value){
                                              widget.token = value;
                                          });
                                      _start = 59;
                                      time = '00:59';
                                      startTimer();
                                    });
                                  }
                                }
                          )
                        ]
                    ),
                  ),
                  /*Container(
                    child: Text(
                      'Didn’t get code? ',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'SF_Pro_400',
                        decoration: TextDecoration.none,
                        fontSize: 15.0 * ratio,
                        fontWeight: FontWeight.normal,
                        color: ColorList.colorPrimary,
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.transparent,
                    elevation: 0.0,
                    child: InkWell(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: (){
                        if (_start == 0) {
                          setState(() {
                            ColorList.showToast("Code sent again");
                            _start = 59;
                            time = '00:59';
                            startTimer();
                          });
                        }
                      },
                      child: Text(
                        'Resend code',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'SF_Pro_400',
                          decoration: TextDecoration.none,
                          fontSize: 15.0 * ratio,
                          fontWeight: FontWeight.bold,
                          color: ColorList.colorSplashBG,
                        ),
                      ),
                    ),
                  ),*/
                  Spacer(),
                  Text(
                    "$time",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: 'SF_Pro_400',
                      decoration: TextDecoration.none,
                      fontSize: 15.0,
                      fontWeight: FontWeight.normal,
                      color: ColorList.colorSplashBG,
                    ),
                  ),
                  Container(
                    width: width * 0.015,
                  )
                ],
              ),
              Container(
                height: height * 0.015,
              ),
            ],
          ),
        ),
        onWillPop: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Signup())
          );
          return null;
        },
      ),
    );
  }
}