import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ibloov/Activity/EditProfile.dart';

import 'package:ibloov/Constants/ColorList.dart';
import 'package:ibloov/Constants/Methods.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constants/ApiCalls.dart';

class MyIbloovWidget extends StatefulWidget{
  @override
  MyIbloovWidgetState createState() => MyIbloovWidgetState();
}

class MyIbloovWidgetState extends State<MyIbloovWidget>{
  var preference;

  double posx = 100.0;
  double posy = 100.0;
  double height, width;
  String countFollower = '', countFollowing = '';

  @override
  void initState() {
    getProfileData()
        .then((pref){
          setState(() {
            preference = pref;
            print('Started');
          });
    });

    ApiCalls.getProfileData()
        .then((value){
          setState(() {
            if(value != null){
              var profileData = json.decode(value)['data'];
              countFollower = profileData['followersCount'].toString();
              countFollowing = profileData['followingCount'].toString();
            }
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
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    Widget header() {
      return Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: (preference?.getString('backgroundImage') == null || preference?.getString('backgroundImage') == "")
                ? AssetImage('assets/images/image_background.png',)
                : NetworkImage(preference?.getString('backgroundImage'))
          ),
        ),
      );
    }

    Widget layer() {
      return Container(
        width: double.infinity,
        height: height,
        color: ColorList.colorHeaderOpaque,
      );
    }

    Widget more() {
      return SafeArea(
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 25),
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    showPopup();
                  },
                  child: Image.asset("assets/images/more_vert.png", height: 25, color: ColorList.colorAccent,),
                  onTapDown: (TapDownDetails details) {
                    RenderBox box = context.findRenderObject();
                    Offset localOffset = box.globalToLocal(details.globalPosition);
                    setState(() {
                      posx = localOffset.dx;
                      posy = localOffset.dy;
                    });
                  },
                )
              ],
            ),
          ),
        ),
      );
    }

    Widget profile() {
      return Container(
        margin: EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Container(
              child: Center(
                  child: CircleAvatar(
                    radius: 77.0,
                    backgroundColor: ColorList.colorAccent,
                    child: CircleAvatar(
                        backgroundColor: ColorList.colorAccent,
                        radius: 77.0,
                        backgroundImage: (preference?.getString('imageUrl') == null
                            || preference?.getString('imageUrl') == "")
                            ? AssetImage('assets/images/profile.png')
                            : NetworkImage(preference?.getString('imageUrl'))
                    ),
                  ),
              ),
              height: 150,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              (preference?.getString('fullName') == null || preference?.getString('fullName') == "")
              ? ""
              : preference?.getString('fullName'),
              style: TextStyle(
                fontFamily: 'SF_Pro_700',
                fontSize: 25,
                fontWeight: FontWeight.normal,
                color: ColorList.colorAccent,
              ),
            ),
            SizedBox(height: 10),
            Text(
              (preference?.getString('username') == null || preference?.getString('username') == "")
                  ? "Username not set!"
                  : (!preference.getString('username').startsWith('@'))
                      ? '@${preference?.getString('username')}'
                      : preference?.getString('username'),
              style: TextStyle(
                fontFamily: 'SF_Pro_400',
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: ColorList.colorAccent,
              ),
            ),
            SizedBox(height: 15),
            Text(
              (preference?.getString('bio') == null || preference?.getString('bio') == "")
                  ? "No bio yet!"
                  : preference?.getString('bio'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'SF_Pro_600',
                fontSize: 13,
                fontWeight: FontWeight.normal,
                color: ColorList.colorAccent.withOpacity(0.6),
              ),
            ),
            SizedBox(
              height: 70,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    /*Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FollowersPage(),
                        )
                    );*/
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Follower',
                        style: TextStyle(
                          fontFamily: 'SF_Pro_600',
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: ColorList.colorAccent.withOpacity(0.5),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        countFollower,
                        style: TextStyle(
                          fontFamily: 'SF_Pro_800',
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: ColorList.colorAccent,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 40,
                ),
                GestureDetector(
                  onTap: () {
                    /*Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FollowingPage(),
                        ));*/
                  },
                  child: Column(
                    children: [
                      Text(
                        'Following',
                        style: TextStyle(
                          fontFamily: 'SF_Pro_600',
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: ColorList.colorAccent.withOpacity(0.5),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        countFollowing,
                        style: TextStyle(
                          fontFamily: 'SF_Pro_800',
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: ColorList.colorAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          header(),
          layer(),
          profile(),
          more(),
          Container(
            alignment: Alignment.bottomCenter,
            child: Methods.getComingSoon(height * 0.6, width),
          )
        ],
      ),
    );
  }

  Future<void> showPopup() async {
    var _selectedSettingsMenuOptions = await showMenu(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))
      ),
      position: RelativeRect.fromLTRB(width, posy + 20.0, 20.0, 0.0),
      items: [
        PopupMenuItem(
          height: 30,
          padding: EdgeInsets.only(left:20, right: 30),
          value: 0,
          child: Text(
            "Edit Profile",
            style: TextStyle(
                fontFamily: 'SF_Pro_600',
                color: ColorList.colorPrimary,
                fontWeight: FontWeight.normal,
                fontSize: 12
            ),
          ),
        ),
      ],
      elevation: 8.0,
    );

    if (_selectedSettingsMenuOptions != null) {
      if(_selectedSettingsMenuOptions == 0){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EditProfile()),
        ).then((value) {
          if(value){
            getProfileData()
                .then((pref){
              setState(() {
                preference = pref;
                print('Resumed');
              });
            });
          } else {
            print('Not Resumed');
          }
        });
      }
    }

  }

}