import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:ibloov/Constants/ApiCalls.dart';
import 'package:ibloov/Constants/ColorList.dart';
import 'package:ibloov/Constants/Methods.dart';

import 'EnableLocation.dart';
import 'ExploreEvents.dart';
import 'GuestUser.dart';
import 'Signup.dart';

class Categories {
  String name;
  String id;
  Color color;
  double widthx;
  double left;
  double top;

  Categories({
    this.name,
    this.id,
    this.color,
    this.widthx,
    this.left,
    this.top,
  });

  @override
  String toString() {
    return '\n\nname :${this.name}, \nid: ${this.id}, \ncolor: ${this.color}, \nwidthx: ${this.widthx}, \nleft: ${this.left}, \ntop: ${this.top}';
  }
}

class SelectInterest extends StatefulWidget {

  final String type;
  final Position currentPosition;
  final String currentAddress, dob;

  SelectInterest(this.type, this.currentPosition, this.currentAddress, this.dob);

  @override
  _SelectInterestState createState() => _SelectInterestState();
}

class _SelectInterestState extends State<SelectInterest> {

  var width, height, ratio;
  var data = <Categories>{};
  var selected = <String>{};
  bool loading;
  final randomColor = Random();
  final randomPlace = Random();

  @override
  void initState() {
    loading = true;
    new Future.delayed(Duration.zero,() {
      ApiCalls.getInterests(context)
          .then((value) {
            setState(() {
              loading = false;
            });
            var interest = json.decode(value)['data'];
            data.clear();
            for(int i=0; i<interest.length; i++){
              data.add(
                Categories(
                  name: interest[i]['name'],
                  id: interest[i]['_id'],
                  color: Colors.primaries[randomColor.nextInt(Colors.primaries.length)][randomColor.nextInt(9) * 100],
                  widthx: i.remainder(3) == 0
                      ? width * ((25 + randomPlace.nextInt(40 - 30))/100)
                      : i.remainder(3) == 1
                      ? width * ((24 + randomPlace.nextInt(30 - 24))/100)
                      : width * ((20 + randomPlace.nextInt(25 - 20))/100),
                  left: i.remainder(3) == 0
                          ? width * ((1 + randomPlace.nextInt(5 - 1))/100)
                          : i.remainder(3) == 1
                              ? width * ((40 + randomPlace.nextInt(42 - 40))/100)
                              : width * (75/100),
                  top: (i/3).floor() == 0
                          ? (height * ((5 + randomPlace.nextInt(10 - 5))/100)) + ((i/3).floor() * height * 0.15)
                          : (i/3).floor() == 1
                              ? (height * ((5 + randomPlace.nextInt(15 - 5))/100)) + ((i/3).floor() * height * 0.15)
                              : (height * ((8 + randomPlace.nextInt(20 - 8))/100)) + ((i/3).floor() * height * 0.15),
                ),
              );
            }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    ratio = MediaQuery.of(context).devicePixelRatio/2.625;

    return loading
        ? Container(color: ColorList.colorAccent,)
        : Scaffold(
      body: WillPopScope(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: height * 0.12,
                  ),
                  Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            //padding: EdgeInsets.only(left: 10),
                            child: Icon(Icons.favorite_outline),
                          ),
                          Container(
                            //width: width * 0.5,
                              padding: EdgeInsets.only(left: 10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Select",
                                    style: TextStyle(
                                      fontFamily: 'SF_Pro_700',
                                      decoration: TextDecoration.none,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                      color: ColorList.colorPrimary,
                                    ),
                                  ),
                                  Text("your Interests",
                                      style: TextStyle(
                                        fontFamily: 'SF_Pro_700',
                                        decoration: TextDecoration.none,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                        color: ColorList.colorPrimary,
                                      )
                                  ),
                                ],
                              )
                          ),
                          Spacer(),
                          Container(
                            //width: width * 0.35,
                              alignment: Alignment.topRight,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Step"),
                                  Text.rich(TextSpan(children: <InlineSpan>[
                                    TextSpan(
                                      text: '3',
                                      style: TextStyle(
                                        fontFamily: 'SF_Pro_700',
                                        decoration: TextDecoration.none,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: ColorList.colorPrimary,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' of 3',
                                      style: TextStyle(
                                        fontFamily: 'SF_Pro_700',
                                        decoration: TextDecoration.none,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.normal,
                                        color: ColorList.colorGrayText,
                                      ),
                                    )
                                  ])),
                                ],
                              )),
                        ],
                      )),
                  Padding(
                    padding: EdgeInsets.only(left: 50.0),
                    child: Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "You can select upto 5 options",
                          style: TextStyle(
                            fontFamily: 'SF_Pro_400',
                            decoration: TextDecoration.none,
                            fontSize: 13.0,
                            fontWeight: FontWeight.normal,
                            color: ColorList.colorPrimary,
                          ),
                        )
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Container(
                      width: width,
                      height: height * 0.65,
                      child: Stack(
                          alignment: Alignment.center,
                          children: getList()
                      ),
                    ),
                  ),
                  MaterialButton(
                    minWidth: width * 0.6,
                    //height: height * 0.06,
                    /*shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                ),*/
                    onPressed: () {
                      if(selected.length > 0 && selected.length < 6){
                        (widget.type == 'Reg')
                            ? ApiCalls.updateProfile(context, {'interests' : selected.toList()})
                            .then((value){
                              if(value != null){
                                var responseSaveInterest = json.decode(value);
                                Methods.showToast(responseSaveInterest['message']);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => EnableLocation()),
                                );
                              }
                            })
                            : Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => ExploreEvents(widget.type, widget.currentPosition, widget.currentAddress)),
                              );
                      } else {
                        Methods.showToast('Please select 1 to 5 interests!');
                      }
                    },
                    color: Colors.transparent,
                    //splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    highlightElevation: 0.0,
                    elevation: 0.0,
                    child: Text(
                      'Save interests',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'SF_Pro_400',
                        decoration: TextDecoration.none,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: ColorList.colorSplashBG,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 80,
              //color: ColorList.colorAccent,
              child: Stack(
                children: [
                  InkWell(
                      onTap: (){
                        (widget.type == 'Reg')
                            ? Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => Signup()),
                              )
                            : Navigator.pop(context);
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
                        padding: EdgeInsets.all(10.0),
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
              padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
            ),
          ],
        ),
        onWillPop: (){
          (widget.type == 'Reg')
              ? Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Signup()),
                )
              : Navigator.pop(context);
          return null;
        },
      )
    );
  }

  List<Widget> getList() {
    List<Widget> child = [];
    for (int i=0; i<data.length; i++) {
      child.add(
          getCircle(
              id: data.elementAt(i).id,
              text: data.elementAt(i).name,
              color: data.elementAt(i).color ?? Colors.lightBlue,
              widthx: data.elementAt(i).widthx,
              left: data.elementAt(i).left,
              top: data.elementAt(i).top
          )
      );
    }
    return child;
  }

  Widget getCircle({id, text, color, widthx, top, left}) {
    return Positioned(
        left: left,
        top: top,
        child: Container(
          width: widthx,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //   content: Text(text),
                // ));
                _selectInterests(id);
              },
              child: FittedBox(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(width/2),
                  child: Align(
                    alignment: Alignment.center,
                    child: Stack(alignment: Alignment.center,
                        children: [
                          (selected.contains(id))?ColorFiltered(
                            child: Image.asset(
                              'assets/images/circle.png',
                            ),
                            colorFilter: ColorFilter.mode(color, BlendMode.color),
                          ): Image.asset(
                            'assets/images/unselected.png',
                          ),
                          Text(
                              text,
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style:TextStyle(
                                  fontFamily: 'SF_Pro_700',
                                  fontWeight: FontWeight.bold,
                                  color: (selected.contains(text))?Colors.white:Colors.grey,
                                  fontSize: 18.0)
                          )
                        ]),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  _selectInterests(String interest) {
    setState(() {
      if (selected.contains(interest)) {
        selected.remove(interest);
      } else {
        if (selected.length >= 5) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("You can select upto 5 options only!"),
          ));
        } else {
          selected.add(interest);
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //   content: Text("$interest add to the selected list"),
          // ));
        }
      }
    });
  }
}
