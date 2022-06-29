import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:ibloov/Constants/ApiCalls.dart';
import 'package:ibloov/Constants/ColorList.dart';
import 'package:ibloov/Constants/Methods.dart';

import 'Onboarding.dart';
import 'ForgotPassword.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login>{

  var width, height;
  bool passwordVisibility;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  FocusNode emailFocusNode = new FocusNode();
  FocusNode passwordFocusNode = new FocusNode();
  RegExp regexEmail = new RegExp(Methods.patternEmail);

  String email = '', password = '';

  @override
  void initState() {
    passwordVisibility = false;
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();

    /*emailController.text = "john@email.com";
    passwordController.text = "P@ssw0rd";*/

  }

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
              child: InkWell(
                onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
                child: Container(
                  color: ColorList.colorAccent,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: height * 0.075,
                        ),
                        Image.asset(
                          'assets/images/logo.png',
                          color: ColorList.colorSplashBG,
                          colorBlendMode: BlendMode.modulate,
                          width: width * 0.25,
                        ),
                        Container(
                          height: height * 0.04,
                        ),
                        Container(
                          width: width,
                          child: Text(
                            'Welcome back.',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: 'SF_Pro_600',
                              decoration: TextDecoration.none,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                              color: ColorList.colorGray,
                            ),
                          ),
                        ),
                        Container(
                          height: height * 0.01,
                        ),
                        Container(
                          width: width,
                          child: Text(
                            'Sign in',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: 'SF_Pro_700',
                              decoration: TextDecoration.none,
                              fontSize: 35.0,
                              fontWeight: FontWeight.bold,
                              color: ColorList.colorPrimary,
                            ),
                          ),
                        ),
                        Container(
                          height: height * 0.015,
                        ),
                        Card(
                          elevation: 0.0,
                          child: Container(
                              width: width,
                              child: TextFormField(
                                controller: emailController,
                                focusNode: emailFocusNode,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                cursorColor: ColorList.colorPrimary,
                                maxLines: 1,
                                decoration: InputDecoration(
                                  hintText: 'Email address',
                                  hintStyle: TextStyle(color: ColorList.colorGrayHint),
                                  labelText: 'Email address',
                                  labelStyle: TextStyle(color: ColorList.colorGrayHint),
                                  alignLabelWithHint: true,
                                  prefixIcon: Image.asset('assets/images/email_logo.png', height: 5.0, width: 5.0),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      color: ColorList.colorGray,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        emailController.clear();
                                      });
                                    },
                                  ),
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
                          height: height * 0.015,
                        ),
                        Card(
                          elevation: 0.0,
                          child: TextFormField(
                            controller: passwordController,
                            focusNode: passwordFocusNode,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            cursorColor: ColorList.colorPrimary,
                            maxLines: 1,
                            /*onTap: (){
                        if(passwordController.text.length == 0){
                          Methods.showError(Methods.passwordAlert);
                        }
                      },*/
                            obscureText: !passwordVisibility,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: TextStyle(color: ColorList.colorGrayHint),
                              labelText: 'Password',
                              labelStyle: TextStyle(color: ColorList.colorGrayHint),
                              alignLabelWithHint: true,
                              prefixIcon: Image.asset('assets/images/password_logo.png', height: 5.0, width: 5.0),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  passwordVisibility
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: ColorList.colorPrimaryDark,
                                ),
                                onPressed: () {
                                  setState(() {
                                    passwordVisibility = !passwordVisibility;
                                  });
                                },
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: ColorList.colorGrayBorder, width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: ColorList.colorGrayBorder, width: 2),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: height * 0.015,
                        ),
                        MaterialButton(
                          minWidth: width * 0.88,
                          height: 50.0,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          onPressed: () {
                            setState(() {
                              email = emailController.text;
                              password = passwordController.text;
                            });

                            SystemChannels.textInput.invokeMethod('TextInput.hide');

                            if(email == null || email.isEmpty){
                              Methods.showToast('Email field is empty!');
                              SystemChannels.textInput.invokeMethod('TextInput.show');
                              FocusScope.of(context).requestFocus(emailFocusNode);
                            } else if(!(email.contains(regexEmail))){
                              Methods.showToast('Please enter a valid Email ID!');
                              SystemChannels.textInput.invokeMethod('TextInput.show');
                              FocusScope.of(context).requestFocus(emailFocusNode);
                            } else if(password == null || password.isEmpty){
                              Methods.showToast('Password field is empty!');
                              SystemChannels.textInput.invokeMethod('TextInput.show');
                              FocusScope.of(context).requestFocus(passwordFocusNode);
                            }/* else if(password.length < 6||
                                !password.contains(new RegExp(r'[0-9]')) ||
                                !password.contains(new RegExp(r'[A-Z]')) ||
                                !password.contains(new RegExp(r'[=!&@#%.]'))){
                              Methods.showError(Methods.passwordAlert);
                              SystemChannels.textInput.invokeMethod('TextInput.show');
                              FocusScope.of(context).requestFocus(passwordFocusNode);
                            }*/ else {
                              ApiCalls.doLogin(email, password, context, true);
                            }
                          },
                          color: ColorList.colorSplashBG,
                          child: Text(
                            'Sign in',
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
                        Container(
                          height: height * 0.015,
                        ),
                        Container(
                          //width: width * 0.88,
                          height: height * 0.05,
                          alignment: Alignment.centerRight,
                          child: Card(
                            elevation: 0.0,
                            child: InkWell(
                              onTap: (){
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => ForgotPassword()),
                                );
                              },
                              child: Text(
                                'Forgot Password?',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontFamily: 'SF_Pro_700',
                                  decoration: TextDecoration.none,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: ColorList.colorSplashBG,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: height * 0.05,
                        ),
                        Card(
                          elevation: 3.0,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          child: InkWell(
                            onTap: (){
                              Methods.authGoogle(context, 'login');
                            },
                            child: Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/google_logo.png',
                                    width: 25.0,
                                    height: 25.0,
                                  ),
                                  Container(
                                    width: width * 0.05,
                                  ),
                                  Text(
                                    'Continue with Google',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: 'SF_Pro_600',
                                      decoration: TextDecoration.none,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: ColorList.colorGrayText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: height * 0.005,
                        ),
                        // Card(
                        //   elevation: 3.0,
                        //   shape: new RoundedRectangleBorder(
                        //     borderRadius: new BorderRadius.circular(10.0),
                        //   ),
                        //   child: InkWell(
                        //     onTap: (){
                        //       Methods.showComingSoon();
                        //       //Methods.showToast("Continue with Facebook");
                        //     },
                        //     child: Padding(
                        //       padding: EdgeInsets.all(15.0),
                        //       child: Row(
                        //         children: [
                        //           Image.asset(
                        //             'assets/images/fb_logo.png',
                        //             width: 25.0,
                        //             height: 25.0,
                        //           ),
                        //           Container(
                        //             width: width * 0.05,
                        //           ),
                        //           Text(
                        //             'Continue with Facebook',
                        //             textAlign: TextAlign.left,
                        //             style: TextStyle(
                        //               fontFamily: 'SF_Pro_600',
                        //               decoration: TextDecoration.none,
                        //               fontSize: 14.0,
                        //               fontWeight: FontWeight.bold,
                        //               color: ColorList.colorGrayText,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Visibility(
                          visible: Platform.isIOS,
                          child: Container(
                            height: height * 0.005,
                          ),
                        ),
                        Visibility(
                          visible: Platform.isIOS,
                          child: Card(
                            elevation: 3.0,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                            ),
                            child: InkWell(
                              onTap: (){
                                // Methods.showComingSoon();
                                Methods.authApple(context, 'login');
                              },
                              child: Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/apple_logo.png',
                                      width: 25.0,
                                      height: 25.0,
                                    ),
                                    Container(
                                      width: width * 0.05,
                                    ),
                                    Text(
                                      'Continue with Apple',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: 'SF_Pro_600',
                                        decoration: TextDecoration.none,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        color: ColorList.colorGrayText,
                                      ),
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
                          width: width * 0.9,
                          height: height * 0.05,
                          alignment: Alignment.center,
                          child: Card(
                            elevation: 0.0,
                            color: Colors.transparent,
                            child: InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: (){
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => Onboarding()),
                                );
                              },
                              child: Row(
                                children: [
                                  Spacer(),
                                  Text(
                                    'New user?   ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'SF_Pro_600',
                                      decoration: TextDecoration.none,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.normal,
                                      color: ColorList.colorPrimary,
                                    ),
                                  ),
                                  Text(
                                    'Create account',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'SF_Pro_600',
                                      decoration: TextDecoration.none,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: ColorList.colorSplashBG,
                                    ),
                                  ),
                                  Spacer()
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
          ),
        ),
        onWillPop: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Onboarding()),
          );
          return null;
        },
      ),
    );
  }

}