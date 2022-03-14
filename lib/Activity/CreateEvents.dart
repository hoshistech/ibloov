import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ibloov/Constants/ColorList.dart';
import 'package:ibloov/Constants/Methods.dart';

class CreateEvents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: const Alignment(0.0, -1),
                end: const Alignment(0.0, 0.6),
                colors: [ColorList.colorBackground, ColorList.colorAccent]
            )
        ),
        child: Stack(
          children: [
            Methods.getComingSoon(height, width),
            Container(
              width: width,
              padding: EdgeInsets.fromLTRB(15, 35, 15, 10),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
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
              ),
              /*child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                          onTap: (){
                            Navigator.pop(context);
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
                            padding: EdgeInsets.all(0.0),
                          )
                      ),
                      Spacer(),
                    ],
                  ),
                  Container(
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/near_event.png',
                          width: 25.0,
                          height: 25.0,
                        ),
                        Container(
                          width: 15.0,
                        ),
                        Text(
                          'Explore Events',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: 'SF_Pro_900',
                            decoration: TextDecoration.none,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: ColorList.colorPrimary,
                          ),
                        ),
                        Spacer(),
                        /*InkWell(
                                  onTap: (){
                                    if(widget.currentPosition == null) {
                                      _getCurrentLocation(false)
                                          .then((value) {
                                        setState(() {
                                          isMap = !isMap;
                                          countEvent = 0;
                                        });
                                      });
                                    } else{
                                      setState(() {
                                        isMap = !isMap;
                                        countEvent = 0;
                                      });
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        (isMap) ? 'assets/images/grid_view.png' : 'assets/images/map_view.png',
                                        //width: 10.0,
                                        height: 15.0,
                                        //color: ColorList.colorSplashBG,
                                      ),
                                      Container(
                                        width: 5.0,
                                      ),
                                      Text(
                                        (isMap) ? 'Grid view' : 'Map View',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontFamily: 'SF_Pro_600',
                                          decoration: TextDecoration.none,
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.normal,
                                          color: ColorList.colorSplashBG,
                                        ),
                                      ),
                                    ],
                                  ),
                                )*/
                      ],
                    ),
                  ),
                ],
              ),*/
            ),
          ],
        ),
    );
  }
  
}