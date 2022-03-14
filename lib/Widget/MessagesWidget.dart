import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:ibloov/Constants/ColorList.dart';
import 'package:ibloov/Constants/Methods.dart';

class MessagesWidget extends StatefulWidget{
  @override
  MessagesWidgetState createState() => MessagesWidgetState();
}

class MessagesWidgetState extends State<MessagesWidget>{
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Container(
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
            DefaultTabController(
              length: 3,
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.transparent,
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(120.0),
                  child: AppBar(
                    flexibleSpace: Center(
                      child: Container(
                        padding: EdgeInsets.only(top: 30.0),
                        margin: EdgeInsets.symmetric(
                          horizontal: 18,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Messages',
                                  style: TextStyle(
                                    fontFamily: 'SF_Pro_700',
                                    decoration: TextDecoration.none,
                                    fontSize: 34.0,
                                    fontWeight: FontWeight.bold,
                                    color: ColorList.colorPrimary,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    /*Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                          return AddNewMessagePage();
                                        }));*/
                                  },
                                  child: Image.asset(
                                    'assets/images/chat_line.png',
                                    width: 24,
                                  ),
                                ),
                              ],
                            ),
                            /*// SEARCH
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              padding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              width: double.infinity,
                              height: 40,
                              decoration: BoxDecoration(
                                //color: backgroundWhite,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/icon_search.png',
                                    width: 16,
                                  ),
                                  SizedBox(
                                    width: 13,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      decoration:
                                      InputDecoration.collapsed(hintText: 'Search'),
                                    ),
                                  ),
                                ],
                              ),
                            ),*/
                          ],
                        ),
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                ),
                body: ContainedTabBarView(
                  tabBarProperties: TabBarProperties(
                    labelPadding: EdgeInsets.symmetric(horizontal: 15),
                    indicatorSize: TabBarIndicatorSize.tab,
                    isScrollable: true,
                    height: 35,
                    indicatorColor: ColorList.colorSplashBG,
                    indicatorWeight: 3.0,
                    labelColor: ColorList.colorPrimary,
                    unselectedLabelColor: ColorList.colorCorousalIndicatorInactive,
                  ),
                  tabs: getTabs(),
                  views: getViews(),
                ),
              ),
            ),
            Container(
              height: height,
              alignment: Alignment.bottomCenter,
              child: Methods.getComingSoon(height * 0.6, width),
            )
          ],
        ),
      ),
    );
  }

  getTabs() {
    List<Widget> tabs = [];
    tabs.add(
      Text(
        Methods.allWordsCapitalize('Direct Messages'),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'SF_Pro_600',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: ColorList.colorPrimary,
        ),
      )
    );
    tabs.add(
      Text(
        Methods.allWordsCapitalize('Group Messages'),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'SF_Pro_600',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: ColorList.colorPrimary,
        ),
      )
    );
    tabs.add(
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              width: 5
          ),
          Text(
            Methods.allWordsCapitalize('Notifications'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'SF_Pro_600',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: ColorList.colorPrimary,
            ),
          ),
          SizedBox(
            width: 5
          ),
          Image.asset(
            'assets/images/bullet.png',
            width: 10,
          )
        ],
      ),
    );
    return tabs;
  }

  getViews() {
    return [Container(), Container(), Container()];
  }

}