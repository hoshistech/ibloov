import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ibloov/Constants/ApiCalls.dart';

import 'package:ibloov/Constants/ColorList.dart';
import 'package:ibloov/Constants/Methods.dart';

import 'Login.dart';
import 'ForgetPassword.dart';

class ForgotPassword extends StatefulWidget {
  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {

  var height, width;
  String email = '';
  var sampleText = "Please enter your email address below to receive your password reset instructions";

  final emailController = TextEditingController();
  FocusNode emailFocusNode = new FocusNode();

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: WillPopScope(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                child: InkWell(
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    onTap: (){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
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
                  'Enter Email Address',
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
                      sampleText,
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
              Card(
                elevation: 0.0,
                child: Container(
                    width: width,
                    child: TextFormField(
                      controller: emailController,
                      focusNode: emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      cursorColor: ColorList.colorPrimary,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: 'Email address',
                        hintStyle: TextStyle(color: ColorList.colorGrayHint),
                        labelText: 'Email address',
                        labelStyle: TextStyle(color: ColorList.colorGrayHint),
                        alignLabelWithHint: true,
                        prefixIcon: Image.asset('assets/images/email_logo.png', height: 5.0, width: 5.0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: ColorList.colorGrayBorder, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: ColorList.colorGrayBorder, width: 2),
                        ),
                      ),
                    )
                ),
              ),
              Container(
                height: height * 0.4,
              ),
              MaterialButton(
                minWidth: width * 0.9,
                height: 50.0,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                onPressed: () {

                  setState(() {
                    email = emailController.text;
                  });

                  if(email == null || email.isEmpty){
                    Methods.showToast('Email field is empty!');
                    SystemChannels.textInput.invokeMethod('TextInput.show');
                    FocusScope.of(context).requestFocus(emailFocusNode);
                  } else {
                    ApiCalls.resetPasswordOTP(email)
                        .then((token){
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => ForgotPasswordOtpScreen(token, email)),
                          );
                    });
                  }

                },
                color: ColorList.colorSplashBG,
                child: Text(
                  'Send Email',
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

  Widget generateList(String text) {
    return Container(
      padding: EdgeInsets.only(top: 10.0, left: 10.0),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.circle,
            size: 8.0
          ),
          SizedBox(
            width: 8.0,
          ),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'SF_Pro_400',
              decoration: TextDecoration.none,
              fontSize: 13.0,
              fontWeight: FontWeight.normal,
              color: ColorList.colorPrimary,
            )
          )
        ],
      ),
    );
  }
}
