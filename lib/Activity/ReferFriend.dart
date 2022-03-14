import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ibloov/Constants/ApiCalls.dart';
import 'package:ibloov/Constants/ColorList.dart';
import 'package:ibloov/Constants/Methods.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReferFriend extends StatefulWidget {
  @override
  ReferFriendState createState() => ReferFriendState();
}

class ReferFriendState extends State<ReferFriend>{
  String referralURL = ApiCalls.urlMain;

  @override
  void initState() {

    getReferralURL().then((value) => referralURL = value);
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    Widget header() {
      return Container(
        margin: EdgeInsets.only(top: 14),
        width: double.infinity,
        height: 44,
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                'Back',
                style: TextStyle(
                  fontFamily: 'SF_Pro_400',
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: ColorList.colorPrimary,
                ),
              ),
            ),
            SizedBox(
              width: 70,
            ),
            Text(
              'Refer Friends',
              style: TextStyle(
                fontFamily: 'SF_Pro_700',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorList.colorPrimary,
              ),
            ),
          ],
        ),
      );
    }

    Widget gift() {
      return Container(
        color: Colors.transparent,
        margin: EdgeInsets.only(top: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/icon_gift.png',
              width: 120,
            )
          ],
        ),
      );
    }

    Widget textGift() {
      return Container(
        color: Colors.transparent,
        margin: EdgeInsets.only(top: 60),
        child: Column(
          children: [
            Text(
              'Get 3% discount on tickets',
              style: TextStyle(
                fontFamily: 'SF_Pro_700',
                fontSize: 22,
                fontWeight: FontWeight.normal,
                color: ColorList.colorSplashBG,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Receive discounts on tickets when you refer your\nfriends and they sign up and register for an event\nwith your referral link',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'SF_Pro_400',
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: ColorList.colorPrimary,
              ),
            ),
          ],
        ),
      );
    }

    Widget textRefer() {
      return Container(
        color: Colors.transparent,
        margin: EdgeInsets.only(top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Your Referral Link',
              style: TextStyle(
                fontFamily: 'SF_Pro_400',
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: ColorList.colorPrimary,
              ),
            ),
            Container(
              width: width,
              height: 50,
              margin: EdgeInsets.only(top: 15),
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: ColorList.colorTicketBG,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      referralURL,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'SF_Pro_400',
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: ColorList.colorPrimary,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: referralURL));
                      Methods.showToast("Link copied to clipboard");
                    },
                    child: Text(
                      'Copy',
                      style: TextStyle(
                        fontFamily: 'SF_Pro_600',
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        color: ColorList.colorSplashBG,
                      ),
                    )
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget customBottomBar() {
      return Container(
        color: Colors.transparent,
        margin: EdgeInsets.only(top: width * 0.3),
        child: MaterialButton(
          minWidth: width * 0.88,
          height: 50.0,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
          color: ColorList.colorSplashBG,
          onPressed: () {
            shareCode(referralURL);
          },
          child: Text(
            'Share Referral Link',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'SF_Pro_600',
              decoration: TextDecoration.none,
              fontSize: 15.0,
              fontWeight: FontWeight.normal,
              color: ColorList.colorAccent,
            ),
          ),
        ),
      );
    }

    return SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: const Alignment(0.0, -1),
                  end: const Alignment(0.0, 0.6),
                  colors: [ColorList.colorBackground, Colors.white]
              )
          ),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Text(
                'Refer Friends',
                style: TextStyle(
                  fontFamily: 'SF_Pro_700',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorList.colorPrimary,
                ),
              ),
              flexibleSpace: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Back',
                    style: TextStyle(
                      fontFamily: 'SF_Pro_400',
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: ColorList.colorPrimary,
                    ),
                  ),
                ),
              ),
            ),
            body: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    //header(),
                    gift(),
                    textGift(),
                    textRefer(),
                    customBottomBar()
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }

  shareCode(url) async {
    await Share.share(
        'Hey, join me on ibloov in the following link \n\n $url',
        subject: 'Share Referral Code'
    );
  }

  Future<String> getReferralURL() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    String referralURL = ApiCalls.urlMain + pref.getString('referralCode');
    print(referralURL);
    
    return referralURL;
  }
}