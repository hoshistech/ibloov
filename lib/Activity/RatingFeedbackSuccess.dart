import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:ibloov/Constants/ColorList.dart';

import 'Home.dart';

var width,height;

class RatingFeedbackSuccess extends StatefulWidget {
  @override
  _RatingFeedbackSuccessState createState() => _RatingFeedbackSuccessState();
}

class _RatingFeedbackSuccessState extends State<RatingFeedbackSuccess> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(

        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 200,
              ),
              Padding(
                padding: const EdgeInsets.only(top:20),
                child: Center(
                  child: Container(
                      width: 80,
                      height: 80,
                      /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                      child: Image.asset('assets/images/create_success.png')),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(top:20),
                child: SizedBox(
                  //width: width/2,
                  child: Container(
                    child: Center(
                      child: Text(
                        "Feedback Received!",
                        textScaleFactor: 1.2,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:30),
                child: SizedBox(
                  width: width * 0.9,
                  child: Container(
                    child: Center(
                      child: Text(
                        "Thank you for sharing your feedback with us, we appreciate your feedback.",
                        textScaleFactor: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(

                          fontSize: 16,
                          // fontWeight: FontWeight.bold
                        ),),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 80,
              ),
              Padding(
                padding: const EdgeInsets.only(top:20),
                child: ElevatedButton(
                    style:ElevatedButton.styleFrom(
                      // onPrimary: Colors.black87,
                      primary: ColorList.colorSplashBG,
                      minimumSize: Size(width * 0.9, 50),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Home()
                          ),
                          ModalRoute.withName("/Home")
                      );
                    },
                    child: new Text(
                      'Back to Home',
                      // style: new TextStyle(fontSize: 16.0, color: Colors.white)),
                    )
                ),
              )
            ],
          ),
        )
    );
  }
}