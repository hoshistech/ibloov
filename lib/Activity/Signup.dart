import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import 'package:ibloov/Constants/ApiCalls.dart';
import 'package:ibloov/Constants/ColorList.dart';
import 'package:ibloov/Constants/Methods.dart';

import 'CreateEvents.dart';
import 'Onboarding.dart';
import 'Login.dart';
import 'TermsCondition.dart';


class Signup extends StatefulWidget {
  @override
  SignupState createState() => SignupState();
}

class SignupState extends State<Signup>{

  double width, height, ratio;
  int gender = 0;
  String name = '', email = '', username = '', country = '+234', phone = '', dob = '', password = '', sex = 'Male';
  bool passwordVisibility, accept = false;

  final fullnameController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();
  final dobController = TextEditingController();
  final passwordController = TextEditingController();

  FocusNode fullnameFocusNode = new FocusNode();
  FocusNode emailFocusNode = new FocusNode();
  FocusNode usernameFocusNode = new FocusNode();
  FocusNode phoneFocusNode = new FocusNode();
  FocusNode dobFocusNode = new FocusNode();
  FocusNode passwordFocusNode = new FocusNode();

  RegExp regexEmail = new RegExp(Methods.patternEmail);

  @override
  void initState() {
    passwordVisibility = false;
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();

    /*fullnameController.text = "Isaac Olawale";
    emailController.text = "bodolawale42@gmail.com";
    usernameController.text = "bodolawale";
    phoneController.text = "8149916607";
    passwordController.text = "bodolawale";*/

  }

  @override
  Widget build(BuildContext context) {

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    ratio = MediaQuery.of(context).devicePixelRatio/2.625;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: height * 0.085,
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: ColorList.colorAccent,
        centerTitle: true,
        title: Image.asset(
          'assets/images/logo.png',
          color: ColorList.colorSplashBG,
          colorBlendMode: BlendMode.modulate,
          width: width * 0.25,
        ),
        flexibleSpace: Container(
          child: GestureDetector(
              onTap: (){
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Onboarding()),
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
          padding: EdgeInsets.fromLTRB(15, 40, 15, 10),
        ),
      ),
      body: SafeArea(
        child: WillPopScope(
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
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          /*Container(
                            height: height * 0.01,
                          ),
                          Container(
                            child: Stack(
                              children: [
                                InkWell(
                                    onTap: (){
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => Onboarding()),
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
                            //padding: EdgeInsets.fromLTRB(5.0, height * 0.05, 5.0, height * 0.05),
                          ),
                          Container(
                            height: height * 0.04,
                          ),*/
                          Container(
                            width: width,
                            child: Text(
                              'Hello there,',
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
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                child: Text(
                                  'Create account',
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
                                        '1',
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
                            height: height * 0.05,
                          ),
                          Card(
                            elevation: 0.0,
                            child: Container(
                                width: width,
                                child: TextFormField(
                                  textCapitalization: TextCapitalization.words,
                                  controller: fullnameController,
                                  focusNode: fullnameFocusNode,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  cursorColor: ColorList.colorPrimary,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    hintText: 'Full Name',
                                    hintStyle: TextStyle(color: ColorList.colorGrayHint),
                                    labelText: 'Full Name',
                                    labelStyle: TextStyle(color: ColorList.colorGrayHint),
                                    alignLabelWithHint: true,
                                    prefixIcon: Image.asset('assets/images/fullname_logo.png', height: 5.0, width: 5.0),
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
                            child: Container(
                                width: width,
                                child: TextFormField(
                                  textCapitalization: TextCapitalization.words,
                                  controller: usernameController,
                                  focusNode: usernameFocusNode,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  cursorColor: ColorList.colorPrimary,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    hintText: 'Username',
                                    hintStyle: TextStyle(color: ColorList.colorGrayHint),
                                    labelText: 'Username',
                                    labelStyle: TextStyle(color: ColorList.colorGrayHint),
                                    alignLabelWithHint: true,
                                    prefixIcon: Image.asset('assets/images/username_logo.png', height: 5.0, width: 5.0),
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
                            child: Stack(
                              children: [
                                Container(
                                    width: width,
                                    child: TextFormField(
                                      controller: phoneController,
                                      focusNode: phoneFocusNode,
                                      keyboardType: TextInputType.phone,
                                      textInputAction: TextInputAction.done,
                                      cursorColor: ColorList.colorPrimary,
                                      maxLength: 10,
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                        hintText: 'Phone Number',
                                        hintStyle: TextStyle(color: ColorList.colorGrayHint),
                                        labelText: 'Phone Number',
                                        labelStyle: TextStyle(color: ColorList.colorGrayHint),
                                        alignLabelWithHint: true,
                                        prefixIcon: Image.asset('assets/images/phone_logo.png', height: 5.0, width: 5.0),
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
                                Container(
                                  height: 58.0,
                                  width: 60.0,
                                  padding: EdgeInsets.only(left: 4.0),
                                  alignment: Alignment.center,
                                  child: CountryCodePicker(
                                    onChanged: (code) => country = code.dialCode,
                                    hideMainText: true,
                                    showFlagMain: true,
                                    showFlag: true,
                                    initialSelection: 'NG',
                                    hideSearch: false,
                                    showCountryOnly: true,
                                    showOnlyCountryWhenClosed: true,
                                    alignLeft: false,
                                    flagWidth: 20.0,
                                    padding: EdgeInsets.zero,
                                    showDropDownButton: false,
                                    showFlagDialog: true,
                                  ),
                                )
                              ],
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
                                  onTap: (){
                                    openDOBSelector(context);
                                  },
                                  controller: dobController,
                                  focusNode: dobFocusNode,
                                  enableInteractiveSelection: false,
                                  textInputAction: TextInputAction.done,
                                  cursorColor: ColorList.colorPrimary,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    hintText: 'Date of Birth',
                                    hintStyle: TextStyle(color: ColorList.colorGrayHint),
                                    labelText: 'Date of Birth',
                                    labelStyle: TextStyle(color: ColorList.colorGrayHint),
                                    alignLabelWithHint: true,
                                    prefixIcon: Image.asset('assets/images/dob_logo.png', height: 5.0, width: 5.0),
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
                              onTap: (){
                                if(passwordController.text.length == 0){
                                  Methods.showError(Methods.passwordAlert);
                                }
                              },
                            ),
                          ),
                          Container(
                            height: height * 0.015,
                          ),
                          Card(
                            color: ColorList.colorGenderBackground,
                            elevation: 0.0,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(width * 0.075),
                              child: Container(
                                height: height * 0.1,
                                width: width,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      width: width,
                                      child: Text(
                                        'GENDER',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontFamily: 'SF_Pro_700',
                                          decoration: TextDecoration.none,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold,
                                          color: ColorList.colorGenderText,
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              gender = 0;
                                              sex = 'Male  ';
                                            });
                                          },
                                          child: Card(
                                            elevation: 0.0,
                                            color: gender == 0 ? ColorList.colorCorousalIndicatorActive : Colors.transparent,
                                            shape: new RoundedRectangleBorder(
                                              borderRadius: new BorderRadius.circular(10.0),
                                            ),
                                            child: Container(
                                              height: height * 0.05,
                                              width: width * 0.20,
                                              child: Row(
                                                children: [
                                                  Spacer(),
                                                  Image.asset(
                                                    'assets/images/male_logo.png',
                                                    width: 25.0,
                                                    height: 25.0,
                                                  ),
                                                  Container(
                                                    width: width * 0.01,
                                                  ),
                                                  Text(
                                                    ' Male ',
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontFamily: 'SF_Pro_600',
                                                      decoration: TextDecoration.none,
                                                      fontSize: 14.0,
                                                      fontWeight: FontWeight.bold,
                                                      color:  gender == 0 ? ColorList.colorAccent : ColorList.colorGrayText,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              gender = 1;
                                              sex = 'Female';
                                            });
                                          },
                                          child: Card(
                                            elevation: 0.0,
                                            color: gender == 1 ? ColorList.colorCorousalIndicatorActive : Colors.transparent,
                                            shape: new RoundedRectangleBorder(
                                              borderRadius: new BorderRadius.circular(10.0),
                                            ),
                                            child: Container(
                                              height: height * 0.05,
                                              width: width * 0.20,
                                              child: Row(
                                                children: [
                                                  Spacer(),
                                                  Image.asset(
                                                    'assets/images/female_logo.png',
                                                    width: 25.0,
                                                    height: 25.0,
                                                  ),
                                                  Container(
                                                    width: width * 0.01,
                                                  ),
                                                  Text(
                                                    'Female ',
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontFamily: 'SF_Pro_600',
                                                      decoration: TextDecoration.none,
                                                      fontSize: 13.0,
                                                      fontWeight: FontWeight.bold,
                                                      color: gender == 1 ? ColorList.colorAccent : ColorList.colorGrayText,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              gender = 2;
                                              sex = 'Other gender';
                                            });
                                          },
                                          child: Card(
                                            elevation: 0.0,
                                            color: gender == 2 ? ColorList.colorCorousalIndicatorActive : Colors.transparent,
                                            shape: new RoundedRectangleBorder(
                                              borderRadius: new BorderRadius.circular(10.0),
                                            ),
                                            child: Container(
                                              height: height * 0.05,
                                              width: width * 0.20,
                                              child: Row(
                                                children: [
                                                  Spacer(),
                                                  Image.asset(
                                                    'assets/images/other_gender_logo.png',
                                                    width: 25.0,
                                                    height: 25.0,
                                                  ),
                                                  Container(
                                                    width: width * 0.01,
                                                  ),
                                                  Text(
                                                    'Others ',
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontFamily: 'SF_Pro_600',
                                                      decoration: TextDecoration.none,
                                                      fontSize: 14.0,
                                                      fontWeight: FontWeight.bold,
                                                      color: gender == 2 ? ColorList.colorAccent : ColorList.colorGrayText,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: height * 0.015,
                          ),
                          Container(
                            width: width * 0.88,
                            //height: height * 0.05,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      if(!accept)
                                        accept = true;
                                      else
                                        accept = false;
                                    });
                                  },
                                  child: Image.asset(
                                    !accept ? 'assets/images/accept_agreement_select.png' : 'assets/images/accept_agreement.png',
                                    width: width * 0.075,
                                    height: width * 0.075,
                                  ),
                                ),
                                Container(
                                  width: width * 0.03,
                                ),
                                Container(
                                  width: width * 0.75,
                                  child: RichText(
                                    text: TextSpan(
                                        text: 'I agree to the ',
                                        style: TextStyle(
                                          fontFamily: 'SF_Pro_400',
                                          decoration: TextDecoration.none,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          color: ColorList.colorGrayText,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: 'terms and conditions',
                                              style: TextStyle(
                                                fontFamily: 'SF_Pro_400',
                                                decoration: TextDecoration.underline,
                                                decorationColor: ColorList.colorSplashBG,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                                color: ColorList.colorSplashBG,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => TermsCondition(),
                                                      )
                                                  );
                                                }
                                          ),
                                          TextSpan(
                                            text: ' and ',
                                            style: TextStyle(
                                              fontFamily: 'SF_Pro_400',
                                              decoration: TextDecoration.none,
                                              decorationColor: ColorList.colorGrayText,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                              color: ColorList.colorSplashBG,
                                            ),
                                          ),
                                          TextSpan(
                                              text: 'privacy policy',
                                              style: TextStyle(
                                                fontFamily: 'SF_Pro_400',
                                                decoration: TextDecoration.underline,
                                                decorationColor: ColorList.colorSplashBG,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                                color: ColorList.colorSplashBG,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => CreateEvents(),
                                                      )
                                                  );
                                                }
                                          ),
                                        ]
                                    ),
                                  ),
                                ),
                              ],
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

                              SystemChannels.textInput.invokeMethod('TextInput.hide');

                              setState(() {
                                name = fullnameController.text;
                                email = emailController.text;
                                username = usernameController.text;
                                phone = phoneController.text;
                                dob = dobController.text;
                                password = passwordController.text;
                              });


                              if(name == null || name.isEmpty){
                                Methods.showToast('Name field is empty!');
                                SystemChannels.textInput.invokeMethod('TextInput.show');
                                FocusScope.of(context).requestFocus(fullnameFocusNode);
                              } else if(email == null || email.isEmpty){
                                Methods.showToast('Email field is empty!');
                                SystemChannels.textInput.invokeMethod('TextInput.show');
                                FocusScope.of(context).requestFocus(emailFocusNode);
                              } else if(!(email.contains(regexEmail))){
                                Methods.showToast('Please enter a valid Email ID!');
                                SystemChannels.textInput.invokeMethod('TextInput.show');
                                FocusScope.of(context).requestFocus(emailFocusNode);
                              } else if(username == null || username.isEmpty){
                                Methods.showToast('Username field is empty!');
                                SystemChannels.textInput.invokeMethod('TextInput.show');
                                FocusScope.of(context).requestFocus(usernameFocusNode);
                              } else if(phone == null || phone.isEmpty){
                                Methods.showToast('Phone field is empty!');
                                SystemChannels.textInput.invokeMethod('TextInput.show');
                                FocusScope.of(context).requestFocus(phoneFocusNode);
                              } else if(dob == null || dob.isEmpty){
                                Methods.showToast('DOB field is empty!');
                                openDOBSelector(context);
                              } else if(password == null || password.isEmpty){
                                Methods.showToast('Password field is empty!');
                                SystemChannels.textInput.invokeMethod('TextInput.show');
                                FocusScope.of(context).requestFocus(passwordFocusNode);
                              } else if(password.length < 6||
                                  !password.contains(new RegExp(r'[0-9]')) ||
                                  !password.contains(new RegExp(r'[A-Z]')) ||
                                  !password.contains(new RegExp(r'[=!&@#%.]'))){
                                Methods.showError(Methods.passwordAlert);
                                SystemChannels.textInput.invokeMethod('TextInput.show');
                                FocusScope.of(context).requestFocus(passwordFocusNode);
                              } else if(!accept){
                                Methods.showToast('Please accept the terms & conditions!');
                              } else {
                                phone = country + phone;
                                ApiCalls.doSignup(name, email, phone, password, sex, username, dob + 'T00:00:00.000Z', context);
                              }
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
                          Container(
                            height: height * 0.025,
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
                                        'Existing user?   ',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'SF_Pro_700',
                                          decoration: TextDecoration.none,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.normal,
                                          color: ColorList.colorPrimary,
                                        ),
                                      ),
                                      Text(
                                        'Sign in',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'SF_Pro_700',
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
                              )
                          ),
                          Container(
                            height: height * 0.025,
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
                  MaterialPageRoute(builder: (context) => Onboarding())
              );
              return null;
            }
        ),
      ),
    );
  }

  void openDOBSelector(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    DatePicker.showDatePicker(
        context,
        showTitleActions: true,
        maxTime: DateTime(DateTime.now().year - 18, DateTime.now().month, DateTime.now().day - 1),
        onConfirm: (date) {
          print('confirm $date');
          dobController.text = DateFormat('yyyy-MM-dd').format(date);
        },
        currentTime: DateTime.now(),
        locale: LocaleType.en
    );
  }

}