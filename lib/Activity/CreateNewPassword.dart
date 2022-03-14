import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ibloov/Constants/ApiCalls.dart';

import 'package:ibloov/Constants/ColorList.dart';
import 'package:ibloov/Constants/Methods.dart';

import 'Login.dart';
import 'ForgetPasswordSuccess.dart';

var height, width;
var sampleText =
    "Your new password must be different from \npreviously used password.";
bool passwordVisibility;

final passwordController = TextEditingController();

FocusNode passwordFocusNode = new FocusNode();

class CreateNewPassword extends StatefulWidget {
  String token, email, otp;

  CreateNewPassword(this.token, this.email, this.otp);

  @override
  _CreateNewPasswordState createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {

  @override
  void initState() {
    passwordVisibility = false;
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
                    'assets/images/lock_icon.png',
                    width: width * 0.05,
                  ),
                  Container(
                    width: 10,
                  ),
                  Container(
                    child: Text(
                      'Create New Password',
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
                  child: TextFormField(
                    controller: passwordController,
                    focusNode: passwordFocusNode,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    cursorColor: ColorList.colorPrimary,
                    maxLines: 1,
                    obscureText: !passwordVisibility,
                    decoration: InputDecoration(
                      hintText: 'New Password',
                      hintStyle: TextStyle(color: ColorList.colorGrayHint),
                      labelText: 'New Password',
                      labelStyle: TextStyle(color: ColorList.colorGrayHint),
                      alignLabelWithHint: true,
                      prefixIcon: Image.asset('assets/images/password_logo.png',
                          height: 5.0, width: 5.0),
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
                        borderSide: BorderSide(
                            color: ColorList.colorGrayBorder, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                            color: ColorList.colorGrayBorder, width: 2),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: ListView(
                    padding: EdgeInsets.all(0.0),
                    shrinkWrap: true,
                    children: <Widget>[
                      generateList("6 or more characters"),
                      generateList("An uppercase letter"),
                      generateList("A Numeric digit"),
                      generateList("A special character (=.!&@#%)"),
                    ],
                  )
              ),
              Container(
                height: height * 0.25,
              ),
              MaterialButton(
                minWidth: width * 0.9,
                height: 50.0,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                onPressed: () {
                  if(passwordController.text.isNotEmpty){
                    if(passwordController.text.length < 6) {
                      Methods.showToast('Password must contain 6 characters!');
                      SystemChannels.textInput.invokeMethod('TextInput.show');
                      FocusScope.of(context).requestFocus(passwordFocusNode);
                    } else if (!passwordController.text.contains(new RegExp(r'[0-9]'))) {
                      Methods.showToast('Please enter at least one number!');
                      SystemChannels.textInput.invokeMethod('TextInput.show');
                      FocusScope.of(context).requestFocus(passwordFocusNode);
                    } else if (!passwordController.text.contains(new RegExp(r'[A-Z]'))) {
                      Methods.showToast('Please enter at least one uppercase letter!');
                      SystemChannels.textInput.invokeMethod('TextInput.show');
                      FocusScope.of(context).requestFocus(passwordFocusNode);
                    } else if (!passwordController.text.contains(new RegExp(r'[=!&@#%.]'))) {
                      Methods.showToast('Please enter at least one special character from the given list!');
                      SystemChannels.textInput.invokeMethod('TextInput.show');
                      FocusScope.of(context).requestFocus(passwordFocusNode);
                    } else
                      ApiCalls.resetPassword(context, widget.otp, widget.token, passwordController.text);
                  } else {
                    Methods.showToast('Please type an alpha-numeric password!');
                    SystemChannels.textInput.invokeMethod('TextInput.show');
                    FocusScope.of(context).requestFocus(passwordFocusNode);
                  }
                },
                color: ColorList.colorSplashBG,
                child: Text(
                  'Confirm New Password',
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
