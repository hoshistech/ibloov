import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ibloov/Activity/CreateEvents.dart';
import 'package:ibloov/Activity/DataPrivacy.dart';
import 'package:ibloov/Activity/FAQ.dart';
import 'package:ibloov/Activity/ReferFriend.dart';
import 'package:ibloov/Activity/TermsCondition.dart';
import 'package:ibloov/Constants/ColorList.dart';
import 'package:ibloov/Constants/Methods.dart';

class SettingsWidget extends StatefulWidget{
  @override
  SettingsWidgetState createState() => SettingsWidgetState();
}

class SettingsWidgetState extends State<SettingsWidget>{
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Container(
      height: height,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: const Alignment(0.0, -1),
              end: const Alignment(0.0, 0.6),
              colors: [ColorList.colorBackground, Colors.white]
          )
      ),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 100),
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // account(),
                      // preferences(),
                      // security(),
                      about(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
              height: 100,
              padding: EdgeInsets.only(top: 30),
              child: Center(
                child: Text(
                  'Settings',
                  style: TextStyle(
                    fontFamily: 'SF_Pro_700',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColorList.colorPrimary,
                  ),
                ),
              )
          ),
          Column(
            children: [
              Container(
                  height: 90
              ),
              Divider(
                thickness: 1,
              ),
            ],
          )
        ],
      )
    );
  }

  Widget account() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ACCOUNT',
            style: TextStyle(
              fontFamily: 'SF_Pro_400',
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: ColorList.colorGray,
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              /*Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentMethod(),
                  ));*/
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateEvents(),
                  )
              );
            },
            child: Row(
              children: [
                Image.asset(
                  'assets/images/icon_payment.png',
                  width: 24,
                ),
                SizedBox(width: 30),
                Expanded(
                  child: Text(
                    'Payment method',
                    style: TextStyle(
                      fontFamily: 'SF_Pro_400',
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: ColorList.colorPrimary,
                    ),
                  ),
                ),
                Image.asset(
                  'assets/images/icon_arrow.png',
                  width: 8,
                  height: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget connectedAccounts() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              /*Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConnectedAccount(),
                  ));*/
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateEvents(),
                  )
              );
            },
            child: Row(
              children: [
                Image.asset(
                  'assets/images/icon_account.png',
                  width: 24,
                ),
                SizedBox(width: 30),
                Expanded(
                  child: Text(
                    'Connected Accounts',
                    style: TextStyle(
                      fontFamily: 'SF_Pro_400',
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: ColorList.colorPrimary,
                    ),
                  ),
                ),
                Image.asset(
                  'assets/images/icon_arrow.png',
                  width: 8,
                  height: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget interests() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateEvents(),
                  )
              );
            },
            child: Row(
              children: [
                Image.asset(
                  'assets/images/icon_love.png',
                  width: 24,
                ),
                SizedBox(width: 30),
                Expanded(
                  child: Text(
                    'Interests',
                    style: TextStyle(
                      fontFamily: 'SF_Pro_400',
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: ColorList.colorPrimary,
                    ),
                  ),
                ),
                Image.asset(
                  'assets/images/icon_arrow.png',
                  width: 8,
                  height: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget privacy() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DataPrivacy(),
                  )
              );
            },
            child: Row(
              children: [
                Image.asset(
                  'assets/images/icon_privacy.png',
                  width: 24,
                ),
                SizedBox(width: 30),
                Expanded(
                  child: Text(
                    'Data Policy',
                    //'Privacy',
                    style: TextStyle(
                      fontFamily: 'SF_Pro_400',
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: ColorList.colorPrimary,
                    ),
                  ),
                ),
                Image.asset(
                  'assets/images/icon_arrow.png',
                  width: 8,
                  height: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget notifications() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              /*Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationPage(),
                  ));*/
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateEvents(),
                  )
              );
            },
            child: Row(
              children: [
                Image.asset(
                  'assets/images/icon_notification.png',
                  width: 24,
                ),
                SizedBox(width: 30),
                Expanded(
                  child: Text(
                    'Notifications',
                    style: TextStyle(
                      fontFamily: 'SF_Pro_400',
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: ColorList.colorPrimary,
                    ),
                  ),
                ),
                Image.asset(
                  'assets/images/icon_arrow.png',
                  width: 8,
                  height: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget preferences() {
    return Container(
      margin: EdgeInsets.only(top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PREFERENCES',
            style: TextStyle(
              fontFamily: 'SF_Pro_400',
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: ColorList.colorGray,
            ),
          ),
          connectedAccounts(),
          interests(),
          //privacy(),
          notifications(),
        ],
      ),
    );
  }

  Widget security() {
    return Container(
      margin: EdgeInsets.only(
        top: 30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SECURITY',
            style: TextStyle(
              fontFamily: 'SF_Pro_400',
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: ColorList.colorGray,
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateEvents(),
                  )
              );
            },
            child: Row(
              children: [
                Image.asset(
                  'assets/images/icon_reset.png',
                  width: 24,
                ),
                SizedBox(width: 30),
                Expanded(
                  child: Text(
                    'Reset Password',
                    style: TextStyle(
                      fontFamily: 'SF_Pro_400',
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: ColorList.colorPrimary,
                    ),
                  ),
                ),
                Image.asset(
                  'assets/images/icon_arrow.png',
                  width: 8,
                  height: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget termsButton() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TermsCondition(),
                  )
              );
            },
            child: Row(
              children: [
                Image.asset(
                  'assets/images/icon_info.png',
                  width: 24,
                ),
                SizedBox(width: 30),
                Expanded(
                  child: Text(
                    'Terms and conditions',
                    style: TextStyle(
                      fontFamily: 'SF_Pro_400',
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: ColorList.colorPrimary,
                    ),
                  ),
                ),
                Image.asset(
                  'assets/images/icon_arrow.png',
                  width: 8,
                  height: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget faqsButton() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FAQ(),
                  )
              );
            },
            child: Row(
              children: [
                Image.asset(
                  'assets/images/icon_faqs.png',
                  width: 24,
                ),
                SizedBox(width: 30),
                Expanded(
                  child: Text(
                    'FAQs',
                    style: TextStyle(
                      fontFamily: 'SF_Pro_400',
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: ColorList.colorPrimary,
                    ),
                  ),
                ),
                Image.asset(
                  'assets/images/icon_arrow.png',
                  width: 8,
                  height: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget referButton() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateEvents(),
                    //builder: (context) => ReferFriend(),
                  )
              );
            },
            child: Row(
              children: [
                Image.asset(
                  'assets/images/icon_share.png',
                  width: 24,
                ),
                SizedBox(width: 30),
                Expanded(
                  child: Text(
                    'Refer a Friend',
                    style: TextStyle(
                      fontFamily: 'SF_Pro_400',
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: ColorList.colorPrimary,
                    ),
                  ),
                ),
                Image.asset(
                  'assets/images/icon_arrow.png',
                  width: 8,
                  height: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget about() {
    return Container(
      margin: EdgeInsets.only(top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ABOUT IBLOOV',
            style: TextStyle(
              fontFamily: 'SF_Pro_400',
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: ColorList.colorGray,
            ),
          ),
          termsButton(),
          privacy(),
          faqsButton(),
          //referButton(),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Methods.logoutUser(context);
            },
            child: Row(
            children: [
              Image.asset(
                'assets/images/icon_logout.png',
                width: 24,
              ),
              SizedBox(width: 30),
              Text(
                'Logout',
                style: TextStyle(
                  fontFamily: 'SF_Pro_400',
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: ColorList.colorRed,
                ),
              ),
            ],
          ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

}