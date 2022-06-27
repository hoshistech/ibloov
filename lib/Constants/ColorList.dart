import 'dart:ui';

import 'package:flutter/material.dart';

class ColorList {
  static const colorPrimary = const Color(0xFF000000);
  static const colorPrimaryDark = const Color(0xFF000000);
  static const colorAccent = const Color(0xFFFFFFFF);
  static const colorHeaderOpaque = const Color(0x8CB0B0B0);
  static const colorSplashBG = const Color(0xFF00237B);
  static const colorButtonBorder = const Color(0xFFC5C5C5);
  static const colorCorousalIndicatorActive = const Color(0xFF95B3FF);
  static const colorCorousalIndicatorInactive = const Color(0x82FFFFFF);
  static const colorGray = const Color(0xFF505050);
  static const colorGrayBorder = const Color(0xFFC5C5C5);
  static const colorGrayHint = const Color(0xFFA0A3BD);
  static const colorGrayText = const Color(0xFF4B4B4B);
  static const colorGenderBackground = const Color(0xFFE2E5FF);
  static const colorGenderText = const Color(0xFF515151);
  static const colorBack = const Color(0xFF858585);
  static const colorMapOuter = const Color(0x2C5AFF1A);
  static const colorRed = const Color(0xFFF14336);
  static const colorBlue = const Color(0xFF0000FF);
  static const colorSeeAll = const Color(0xFF4272ED);
  static const colorDetails = const Color(0xFF8C8C8C);
  static const colorBackground = const Color(0xFFCFDCFD);
  static const colorSearchList = const Color(0xFF5C5C5C);
  static const colorSearchListPlace = const Color(0xFF9F9F9F);
  static const colorSearchListMore = const Color(0xFF4272ED);
  static const colorTicketBG = const Color(0x1A4272ED);
  static const colorBlueOnBlack = const Color(0xFF4272ED);
  static const colorNavButton = const Color(0xFFB0B0B0);
  static const colorNavBG = const Color(0x593064EE);
  static const colorTileExpanded = const Color(0xFFECF1FD);
  static const colorPopUpBG = const Color(0xFFF0F0F0);
  static const colorMenuItem = const Color(0xFFB0B0B0);
  static const colorHeader = const Color(0xff202020);
  static const colorBottomSheetBG = const Color(0xFF737373);

  static void searchFilterMenu(BuildContext context, double height, double width){
    int locationIndex = 0;
    List locationFilter = [{'text':'Current Location', 'icon': Icons.location_pin}, {'text':'Find Location', 'icon': Icons.search}];

    int conditionIndex = 0;
    List conditionFilter = ['Women only', '18+', '21+', 'Kids',];

    int dateIndex = 0;
    List dateFilter = ['Today', 'Tomorrow', 'This week', 'This weekend', 'Choose a date'];

    RangeValues _currentRangeValues = const RangeValues(0, 20);

    showModalBottomSheet(
        isScrollControlled: true,
        elevation: 15,
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(50.0))),
        builder: (builder){
          return new Container(
            //height: MediaQuery.of(context).size.height * 0.9,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: new Container(
                height: 551,
                padding: EdgeInsets.all(15.0),
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(50.0),
                    topRight: const Radius.circular(50.0)
                  ),
                  gradient: LinearGradient(
                    begin: const Alignment(0.0, -1),
                    end: const Alignment(0.0, 0.0),
                    colors: [ColorList.colorBackground, Colors.white]
                  )
                ),
                child: Column(
                  children: [
                    Container(
                      child: Text(
                        'Filters',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'SF_Pro_900',
                          decoration: TextDecoration.none,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: ColorList.colorPrimary,
                        ),
                      ),
                      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                    ),
                    Container(
                      height: 460,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 15.0),
                              child: Text(
                                'Location',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: 'SF_Pro_700',
                                  decoration: TextDecoration.none,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: ColorList.colorPrimary,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 5.0),
                              child: ListView(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                children: new List.generate(locationFilter.length, (int index) {
                                  return Padding(
                                    padding: EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
                                    child: MaterialButton(
                                      //elevation: 2.0,
                                      textColor: (index == locationIndex) ? ColorList.colorAccent : ColorList.colorSplashBG,
                                      color: (index != locationIndex) ? ColorList.colorAccent : ColorList.colorSplashBG,
                                      child: Text(locationFilter[index]['text']),
                                      onPressed: () {
                                        /*if(index != locationIndex){
                                    setState(() {
                                      locationIndex = index;
                                      ColorList.showToast('Selected: ' + locationFilter[index]);
                                    });
                                  }*/
                                      },
                                      shape: new RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(30.0),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              height: 65.0,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 15.0, top: 15.0, bottom: 10.0),
                              child: Text(
                                'Condition',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: 'SF_Pro_700',
                                  decoration: TextDecoration.none,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: ColorList.colorPrimary,
                                ),
                              ),
                            ),
                            Wrap(
                              children: List.generate(conditionFilter.length, (int index) {
                                return Padding(
                                  padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                                  child: MaterialButton(
                                    //elevation: 2.0,
                                    textColor: (index == conditionIndex) ? ColorList.colorAccent : ColorList.colorSplashBG,
                                    color: (index != conditionIndex) ? ColorList.colorAccent : ColorList.colorSplashBG,
                                    child: Text(conditionFilter[index]),
                                    onPressed: () {
                                      /*if(index != locationIndex){
                                    setState(() {
                                      locationIndex = index;
                                      ColorList.showToast('Selected: ' + locationFilter[index]);
                                    });
                                  }*/
                                    },
                                    shape: new RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(30.0),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 15.0, top: 15.0, bottom: 10.0),
                              child: Text(
                                'Date',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: 'SF_Pro_700',
                                  decoration: TextDecoration.none,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: ColorList.colorPrimary,
                                ),
                              ),
                            ),
                            Wrap(
                              children: List.generate(dateFilter.length, (int index) {
                                return Padding(
                                  padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                                  child: MaterialButton(
                                    //elevation: 2.0,
                                    textColor: (index == dateIndex) ? ColorList.colorAccent : ColorList.colorSplashBG,
                                    color: (index != dateIndex) ? ColorList.colorAccent : ColorList.colorSplashBG,
                                    child: Text(dateFilter[index]),
                                    onPressed: () {
                                      /*if(index != locationIndex){
                                    setState(() {
                                      locationIndex = index;
                                      ColorList.showToast('Selected: ' + locationFilter[index]);
                                    });
                                  }*/
                                    },
                                    shape: new RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(30.0),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 15.0, top: 15.0, bottom: 10.0),
                              child: Text(
                                'Price',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: 'SF_Pro_700',
                                  decoration: TextDecoration.none,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: ColorList.colorPrimary,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 15.0, top: 0.0, bottom: 10.0),
                              child: Text(
                                'Free - \$ 20',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: 'SF_Pro_700',
                                  decoration: TextDecoration.none,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: ColorList.colorPrimary,
                                ),
                              ),
                            ),
                            RangeSlider(
                              values: _currentRangeValues,
                              min: 0,
                              max: 100,
                              divisions: 20,
                              onChanged: (RangeValues values) {
                                /*setState(() {
                            _currentRangeValues = values;
                          });*/
                              },
                            ),
                            Container(
                              height: 15.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                MaterialButton(
                                  color: ColorList.colorAccent.withOpacity(0.9),
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  minWidth: width * 0.25,
                                  height: 50.0,
                                  shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(10.0),
                                  ),
                                  elevation: 0.0,
                                  onPressed: (){

                                  },
                                  child: Text(
                                    'Reset',
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
                                MaterialButton(
                                  color: ColorList.colorSplashBG,
                                  minWidth: width * 0.6,
                                  height: 50.0,
                                  shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(10.0),
                                  ),
                                  elevation: 5.0,
                                  onPressed: (){

                                  },
                                  child: Text(
                                    'Apply',
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
                            Container(
                              height: 15.0,
                            ),

                          ],
                        ),
                      ),
                    )
                  ],
                )
            ),
          );
        }
    );
  }

}

/*A71
Height: 866.2857142857143
Width: 411.42857142857144*/