import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ibloov/Constants/ApiCalls.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

import 'package:ibloov/Constants/ColorList.dart';
import 'package:ibloov/Constants/Methods.dart';

import 'ForgotPassword.dart';
import 'CreateNewPassword.dart';

double width, height, ratio;

class ForgetPassword extends StatefulWidget {
  String token, email;
  ForgetPassword(this.token, this.email);

  @override
  ForgetPasswordState createState() => ForgetPasswordState();
}

class ForgetPasswordState extends State<ForgetPassword>{
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
          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                child: InkWell(
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  onTap: (){
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPassword()),
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
                    padding: EdgeInsets.only(top: 0.0),
                  )
                ),
                padding: EdgeInsets.fromLTRB(0.0, height * 0.05, 0.0, height * 0.05),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset(
                    'assets/images/forgot_otp.png',
                    width: width * 0.05,
                  ),
                  Container(
                    width: 10,
                  ),
                  Container(
                    child: Text(
                      'Forgot Password?',
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
                ],
              ),
              Container(
                height: height * 0.03,
              ),
              Container(
                child: Text(
                  'OTP Verification',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'SF_Pro_700',
                    decoration: TextDecoration.none,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                    color: ColorList.colorPrimary,
                  ),
                ),
              ),
              Container(
                height: height * 0.03,
              ),
              Container(
                child: Text(
                  'Enter the 4 digit OTP that was sent to your email address',
                  style: TextStyle(
                    fontFamily: 'SF_Pro_400',
                    decoration: TextDecoration.none,
                    fontSize: 17.0,
                    fontWeight: FontWeight.normal,
                    color: ColorList.colorPrimary,
                  )
                )
              ),
              Container(
                height: height * 0.03,
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
                                FlatButton(
                                    onPressed: () async {
                                      var copiedText =
                                      await Clipboard.getData("text/plain");
                                      if (copiedText.text.isNotEmpty) {
                                        controllerOTP.text = copiedText.text;
                                      }
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("YES")),
                                FlatButton(
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
                      onDone: (text) {
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
                height: height * 0.35,
              ),
              MaterialButton(
                minWidth: width * 0.88,
                height: 50.0,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                onPressed: () {
                  if(controllerOTP.text.length == 4){
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => CreateNewPassword(widget.token, widget.email, controllerOTP.text)),
                    );
                  } else {
                    Methods.showToast('Please enter the OTP you received!');
                  }
                },
                color: ColorList.colorSplashBG,
                child: Text(
                  'Confirm OTP',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'SF_Pro_600',
                    decoration: TextDecoration.none,
                    fontSize: 15.0,
                    fontWeight: FontWeight.normal,
                    color: ColorList.colorAccent,
                  ),
                ),
              ),
              Container(
                height: height * 0.075,
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
                                      ApiCalls.resetPasswordOTP(widget.email)
                                          .then((token){
                                        widget.token = token;
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
              MaterialPageRoute(builder: (context) => ForgotPassword())
          );
          return null;
        },
      ),
    );
  }
}