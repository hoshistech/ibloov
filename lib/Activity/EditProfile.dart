import 'dart:convert';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:ibloov/Constants/ApiCalls.dart';
import 'package:ibloov/Constants/ColorList.dart';
import 'package:ibloov/Constants/Methods.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget{
  @override
  EditProfileState createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile>{
  var preference;
  var width;
  bool selected = false, status = false, editUserName = false, editPhone = false;
  String stringProfile, stringName, stringUsername, stringEmail, country = '+234', stringCode = 'NG', stringPhone, stringBio, stringBackground, stringGender;
  DateTime stringDOB;
  XFile profileImage, bgImage;
  List data = [];
  int gender = 0;

  final ImagePicker imagePicker = ImagePicker();

  TextEditingController nameController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController phoneNoController = new TextEditingController();
  TextEditingController bioController = new TextEditingController();

  FocusNode phoneFocusNode = new FocusNode();

  @override
  void initState() {
    getProfileData()
        .then((pref){
      setState(() {
        preference = pref;
        nameController.text = preference?.getString('fullName');
        bioController.text = preference?.getString('bio');
        stringProfile = preference?.getString('imageUrl');
        stringName = preference?.getString('fullName');
        stringUsername = preference?.getString('username');
        stringEmail = preference?.getString('email');
        stringPhone = preference?.getString('phoneNumber');
        stringBackground = preference?.getString('backgroundImage');
        stringGender = preference?.getString('gender');
        try {
          stringDOB = DateTime.parse(preference?.getString('dob'));
        } catch (e) {
          stringDOB = null;
          print(e);
        }

        if(stringUsername.length > 0 && !stringUsername.startsWith('@')) {
          usernameController.text = '@$stringUsername';
        } else if(stringUsername.startsWith('@')) {
          usernameController.text = '$stringUsername';
        } else {
          editUserName = true;
        }

        if(!stringPhone.contains('+') || stringPhone == 'N/A')
          editPhone = true;
      });
    });

    super.initState();
  }

  getProfileData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref;
  }

  @override
  Widget build(BuildContext context) {

    width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        flexibleSpace: GestureDetector(
          onTap: () {
            Navigator.pop(context, status);
          },
          child: Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Back',
              style: TextStyle(
                  fontFamily: 'SF_Pro_700',
                  fontSize: 15,
                  color: ColorList.colorBack,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none
              ),
            ),
          ),
        ),
      ),
      body: WillPopScope(
          child: GestureDetector(
            onTap: () {
              SystemChannels.textInput.invokeMethod('TextInput.hide');
              if(usernameController.text.length == 1) {
                usernameController.text = '';
                FocusScope.of(context).requestFocus(new FocusNode());
              }
            },
            child: Container(
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView(
                children: [
                  Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontFamily: 'SF_Pro_900',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ColorList.colorPrimary,
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      showPicker(context, true);
                    },
                    child: Center(
                      child: Card(
                        color: ColorList.colorAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(77.0),
                        ),
                        elevation: 10.0,
                        child: CircleAvatar(
                          radius: 76.0,
                          backgroundColor: ColorList.colorAccent,
                          child: CircleAvatar(
                            backgroundColor: ColorList.colorAccent,
                            radius: 77.0,
                            backgroundImage: ((stringProfile != null || stringProfile != "")
                                && !selected)
                                ? NetworkImage(stringProfile)
                                : (!selected)
                                ? AssetImage('assets/images/profile.png')
                                : FileImage(File(profileImage.path)),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: CircleAvatar(
                                backgroundColor: Colors.green,
                                radius: 19.0,
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 18.0,
                                  color: ColorList.colorPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              child: Text(
                                'Full Name',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: 'SF_Pro_700',
                                  decoration: TextDecoration.none,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: ColorList.colorGrayHint,
                                ),
                              ),
                            ),
                            Spacer(),
                            Container(
                              width: width * 0.6,
                              //color: Colors.black,
                              child: TextFormField(
                                textCapitalization: TextCapitalization.words,
                                keyboardType: TextInputType.name,
                                controller: nameController,
                                textInputAction: TextInputAction.done,
                                cursorColor: ColorList.colorPrimary,
                                maxLines: 1,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontFamily: 'SF_Pro_700',
                                  decoration: TextDecoration.none,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: ColorList.colorPrimary,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Full name',
                                  hintStyle: TextStyle(
                                    fontFamily: 'SF_Pro_700',
                                    decoration: TextDecoration.none,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: ColorList.colorGray,
                                  ),
                                  alignLabelWithHint: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                        //SizedBox(height: 10),
                        Divider(
                          thickness: 1,
                          color: ColorList.colorGenderBackground,
                        )
                      ],
                    ),
                  ),
                  Container(
                    //margin: EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              child: Text(
                                'Username',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: 'SF_Pro_700',
                                  decoration: TextDecoration.none,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: ColorList.colorGrayHint,
                                ),
                              ),
                            ),
                            Spacer(),
                            Container(
                              width: width * 0.6,
                              //color: Colors.black,
                              child: TextFormField(
                                enabled: editUserName,
                                textCapitalization: TextCapitalization.words,
                                keyboardType: TextInputType.name,
                                controller: usernameController,
                                textInputAction: TextInputAction.done,
                                cursorColor: ColorList.colorPrimary,
                                maxLines: 1,
                                onTap: (){
                                  setState(() {
                                    if(!usernameController.text.contains('@'))
                                      usernameController.text = '@${usernameController.text}';
                                  });
                                },
                                onEditingComplete: (){
                                  setState(() {
                                    if(!usernameController.text.contains('@'))
                                      usernameController.text = '@${usernameController.text}';
                                  });
                                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                                  FocusScope.of(context).requestFocus(new FocusNode());
                                },
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontFamily: 'SF_Pro_700',
                                  decoration: TextDecoration.none,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: ColorList.colorPrimary,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Not set yet!',
                                  hintStyle: TextStyle(
                                    fontFamily: 'SF_Pro_700',
                                    decoration: TextDecoration.none,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: ColorList.colorGray,
                                  ),
                                  alignLabelWithHint: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                        //SizedBox(height: 15),
                        Divider(
                          thickness: 1,
                          color: ColorList.colorGenderBackground,
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              child: Text(
                                'Email',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: 'SF_Pro_700',
                                  decoration: TextDecoration.none,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: ColorList.colorGrayHint,
                                ),
                              ),
                            ),
                            Spacer(),
                            Container(
                              child: Text(
                                stringEmail,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontFamily: 'SF_Pro_700',
                                  decoration: TextDecoration.none,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: ColorList.colorPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Divider(
                          thickness: 1,
                          color: ColorList.colorGenderBackground,
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              child: Text(
                                'Phone Number',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: 'SF_Pro_700',
                                  decoration: TextDecoration.none,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: ColorList.colorGrayHint,
                                ),
                              ),
                            ),
                            Spacer(),
                            Container(
                              width: width * 0.6,
                              child: GestureDetector(
                                onTap: (){
                                  if(editPhone)
                                    showPhoneDialog(context);
                                },
                                child: Text(
                                  stringPhone,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontFamily: 'SF_Pro_700',
                                    decoration: TextDecoration.none,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: editPhone
                                        ? ColorList.colorGray
                                        : ColorList.colorPrimary,
                                  ),
                                ),
                              )
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Divider(
                          thickness: 1,
                          color: ColorList.colorGenderBackground,
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              child: Text(
                                'Date of Birth',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: 'SF_Pro_700',
                                  decoration: TextDecoration.none,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: ColorList.colorGrayHint,
                                ),
                              ),
                            ),
                            Spacer(),
                            Container(
                              //color: Colors.black,
                                child: InkWell(
                                  child: Text(
                                    (stringDOB != null)
                                        ? DateFormat('dd MMMM yyyy').format(stringDOB)
                                        : "Not set yet!",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontFamily: 'SF_Pro_700',
                                      decoration: TextDecoration.none,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: (stringDOB != null)
                                          ? ColorList.colorPrimary
                                          : ColorList.colorGray,
                                    ),
                                  ),
                                  onTap: (){
                                    openDOBSelector(context);
                                  },
                                )
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Divider(
                          thickness: 1,
                          color: ColorList.colorGenderBackground,
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              child: Text(
                                'Gender',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: 'SF_Pro_700',
                                  decoration: TextDecoration.none,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: ColorList.colorGrayHint,
                                ),
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                showGenderModal(context);
                              },
                              child: Container(
                                child: Text(
                                  stringGender,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontFamily: 'SF_Pro_700',
                                    decoration: TextDecoration.none,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: ColorList.colorPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Divider(
                          thickness: 1,
                          color: ColorList.colorGenderBackground,
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bio',
                          style: TextStyle(
                            fontFamily: 'SF_Pro_900',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ColorList.colorGrayHint,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.multiline,
                          controller: bioController,
                          //textInputAction: TextInputAction.done,
                          cursorColor: ColorList.colorPrimary,
                          minLines: 1,
                          maxLines: 3,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'No bio yet!',
                            hintStyle: TextStyle(
                              fontFamily: 'SF_Pro_700',
                              decoration: TextDecoration.none,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: ColorList.colorGray,
                            ),
                            alignLabelWithHint: true,
                          ),
                        ),
                        SizedBox(height: 15),
                        Divider(
                          thickness: 1,
                          color: ColorList.colorGenderBackground,
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Background image',
                          style: TextStyle(
                            fontFamily: 'SF_Pro_900',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ColorList.colorGrayHint,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            showPicker(context, false);
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  bgImage != null
                                      ? bgImage.name
                                      : "Select background image",
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'SF_Pro_600',
                                    fontSize: 15,
                                    fontWeight: bgImage != null
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: bgImage != null
                                        ? ColorList.colorPrimary
                                        : ColorList.colorGrayHint,
                                  ),
                                ),
                              ),
                              SizedBox(width: 5,),
                              Text(
                                'Change',
                                style: TextStyle(
                                  fontFamily: 'SF_Pro_700',
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  color: ColorList.colorSeeAll,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        Divider(
                          thickness: 1,
                          color: ColorList.colorGenderBackground,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        child: Container(
                          width: width * 0.35,
                          height: 50.0,
                          decoration: new BoxDecoration(
                            color: ColorList.colorAccent,
                            border: Border.all(color: ColorList.colorSplashBG, width: 1.0),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Center(
                            child: Text(
                              'Cancel',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: 'SF_Pro_600',
                                decoration: TextDecoration.none,
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal,
                                color: ColorList.colorSplashBG,
                              ),
                            ),
                          ),
                        ),
                        onTap: () => Navigator.pop(context, status),
                      ),
                      Spacer(),
                      MaterialButton(
                        color: ColorList.colorSplashBG,
                        minWidth: width * 0.5,
                        height: 50.0,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        elevation: 5.0,
                        onPressed: (){
                          FocusScope.of(context).requestFocus(new FocusNode());
                          if(profileImage != null){
                            uploadProfileImage();
                          } else if(bgImage != null){
                            uploadBgImage();
                          } else {
                            updateProfileData();
                          }
                        },
                        child: Text(
                          'Save Profile',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: 'SF_Pro_600',
                            decoration: TextDecoration.none,
                            fontSize: 15.0,
                            fontWeight: FontWeight.normal,
                            color: ColorList.colorAccent,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          onWillPop: () async {
            Navigator.pop(context, status);
            return false;
          }
      ),
    );
  }

  void showPicker(context, profile) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        selectImage(ImageSource.gallery, profile);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      selectImage(ImageSource.camera, profile);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  selectImage(source, profile) async {
    try {
      final pickedFile = await imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 100,
      );

      if (pickedFile == null) return;

      setState(() {
        if(profile) {
          selected = true;
          profileImage = pickedFile;
        } else
          bgImage = pickedFile;
      });
    } on PlatformException catch (e) {
      print('failed $e');
    }
  }

  Future<Null> showPhoneDialog(BuildContext context) async {

    return showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            CupertinoAlertDialog(
              content: Column(
                children: [
                  Text(
                      "Enter Phone Number",
                      textScaleFactor: 1.2,
                      style: TextStyle(fontWeight: FontWeight.bold)
                  ),
                  SizedBox(
                    height: 25
                  ),
                  Material(
                    color: Colors.transparent,
                    child: Stack(
                      children: [
                        Container(
                            width: width,
                            child: TextFormField(
                              controller: phoneNoController,
                              focusNode: phoneFocusNode,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.done,
                              cursorColor: ColorList.colorPrimary,
                              //maxLength: 10,
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
                                  borderSide: BorderSide(color: ColorList.colorPrimary, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(color: ColorList.colorPrimary, width: 1),
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
                            onChanged: (code) {
                              setState(() {
                                country = code.dialCode;
                                stringCode = code.name;
                              });
                            },
                            hideMainText: true,
                            showFlagMain: true,
                            showFlag: true,
                            initialSelection: stringCode,
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
                ],
              ),
              actions: <Widget>[
                CupertinoActionSheetAction(
                  isDefaultAction: true,
                  isDestructiveAction: false,
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        fontSize: 16.0
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CupertinoActionSheetAction(
                  isDefaultAction: false,
                  child: Text(
                    "Done",
                    style: TextStyle(
                        color:Colors.green,
                        fontSize: 16.0
                    ),
                  ),
                  onPressed: () async {
                    String phoneNo = phoneNoController.text;
                    if((phoneNo.isNotEmpty || phoneNo != null) && phoneNo.length == 10) {
                      setState(() {
                        stringPhone = country + " " + phoneNo;
                      });
                      Navigator.pop(context);
                    } else if(phoneNo.length != 10){
                      SystemChannels.textInput.invokeMethod('TextInput.show');
                      FocusScope.of(context).requestFocus(phoneFocusNode);
                      Methods.showError("Please enter a valid phone number!");
                    }
                  },
                )
              ],
            )
    );
  }

  Future<void> showGenderModal(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        backgroundColor: ColorList.colorAccent,
        builder: (context) {
      return Wrap(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                gender = 0;
                stringGender = 'Male';
              });
              Navigator.pop(context);
            },
            child: ListTile(
              leading: Image.asset(
                'assets/images/male_logo.png',
                width: 25.0,
                height: 25.0,
              ),
              title: Text(
                'Male',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'SF_Pro_600',
                  decoration: TextDecoration.none,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color:  gender == 0 ? ColorList.colorBlue : ColorList.colorGrayText,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                gender = 1;
                stringGender = 'Female';
              });
              Navigator.pop(context);
            },
            child: ListTile(
              leading: Image.asset(
                'assets/images/female_logo.png',
                width: 25.0,
                height: 25.0,
              ),
              title: Text(
                'Female',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'SF_Pro_600',
                  decoration: TextDecoration.none,
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                  color: gender == 1 ? ColorList.colorBlue : ColorList.colorGrayText,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                gender = 2;
                stringGender = 'Other gender';
              });
              Navigator.pop(context);
            },
            child: ListTile(
              leading: Image.asset(
                'assets/images/female_logo.png',
                width: 25.0,
                height: 25.0,
              ),
              title: Text(
                'Others',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'SF_Pro_600',
                  decoration: TextDecoration.none,
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                  color: gender == 2 ? ColorList.colorBlue : ColorList.colorGrayText,
                ),
              ),
            ),
          ),
        ],
      );
    },
    );
  }

  void openDOBSelector(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    DatePicker.showDatePicker(
        context,
        showTitleActions: true,
        maxTime: DateTime(DateTime.now().year - 18, DateTime.now().month, DateTime.now().day - 1),
        onConfirm: (date) {
          setState(() {
            stringDOB = date;
          });
        },
        currentTime: DateTime.now(),
        locale: LocaleType.en
    );
  }

  void uploadProfileImage() {
    Methods.showToast('Uploading Profile Image...');
    ApiCalls.uploadFile(context, 'avatar', profileImage.path)
        .then((value) {
          var dataJson = json.decode(value)['data'];
          if(data != null){
            preference?.setString('imageUrl', dataJson['url']);
            stringProfile = dataJson['url'];
            if(bgImage != null){
              uploadBgImage();
            } else {
              updateProfileData();
            }
          }
    });
  }

  void uploadBgImage() {
    Methods.showToast('Uploading Background Image...');
    ApiCalls.uploadFile(context, 'background', bgImage.path)
        .then((value) {
      var dataJson = json.decode(value)['data'];
      if(data != null){
        preference?.setString('backgroundImage', dataJson['url']);
        stringBackground = dataJson['url'];
        updateProfileData();
      }
    });
  }

  void updateProfileData() {
    Map data = {
      'fullName': nameController.text,
      'username': usernameController.text,
      'phoneNumber': stringPhone,
      'dob': stringDOB.toString(),
      'imageUrl': stringProfile,
      'backgroundImage': stringBackground,
      'bio': bioController.text,
      'gender': stringGender,
    };

    ApiCalls.updateProfile(context, data)
        .then((value){
      Methods.showToast(json.decode(value)['message']);
      if(value != null){
        var responseUpdate = json.decode(value)['data'];
        getProfileData()
            .then((pref){
          setState(() {
            Methods.saveUserData(pref, responseUpdate);
          });
        });
        status = true;
      }
    });
  }
  
}