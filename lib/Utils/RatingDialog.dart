import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ibloov/Constants/ApiCalls.dart';
import 'package:ibloov/Constants/ColorList.dart';
import 'package:ibloov/Constants/Methods.dart';

class RatingDialog extends StatefulWidget {
  RatingDialog({
    this.onTap,
    this.onWriteReviewTap,
    this.height,
    this.width,
  });
  final Function() onTap;
  final Function() onWriteReviewTap;
  final double width;
  final double height;
  @override
  RatingDialogState createState() => RatingDialogState();
}

class RatingDialogState extends State<RatingDialog> {
  bool _isStarTapped = false;
  bool _isSubmitted = false;
  var rating = [0, 0, 0, 0, 0];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 25, right: 25),
            child: Column(
              children: [
                Image(
                  image: AssetImage("assets/images/logo.png"),
                  color: ColorList.colorSplashBG,
                  colorBlendMode: BlendMode.modulate,
                  width: widget.width * 0.25,
                ),
                SizedBox(
                  height: widget.height * 0.02,
                ),
                (!_isSubmitted)
                    ? Text(
                        "Enjoying Ibloov?",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    : Text(
                        "Thanks for your feedback",
                        textScaleFactor: 1.2,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                (!_isSubmitted)
                    ? Text(
                        "Tap a star to rate it on the App store.",
                        style: TextStyle(
                            // fontWeight: FontWeight.bold
                            ),
                      )
                    : Text(
                        "You can also write a review",
                        style: TextStyle(
                            // fontWeight: FontWeight.bold
                            ),
                      ),
                // Divider()
              ],
            ),
          ),
          (!_isSubmitted) ? Divider() : SizedBox(height: 5,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            for (int i = 0; i < 5; i++)
              GestureDetector(
                  onTap: () {
                    if(!_isSubmitted){
                      widget.onTap();
                      setState(() {
                        _isStarTapped = true;
                        for (int j = 0; j <= i; j++) rating[j] = 1;
                        for (int j = i + 1; j < 5; j++) rating[j] = 0;
                      });
                    }
                  },
                  child: Icon(
                    (rating[i] == 1)
                        ? Icons.star_rate_rounded
                        : Icons.star_outline_rounded,
                    color: (!_isSubmitted) ? Colors.blue : Colors.yellow[800],
                  ))
          ]),
          if (_isSubmitted)
            GestureDetector(
                onTap: () async {
                  widget.onWriteReviewTap();
                  SharedPreferences pref = await SharedPreferences.getInstance();
                  pref.setString('rating', rating.toString());
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                  child: Text("Write a Review",
                      textScaleFactor: 1.3,
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold)),
                )),
          Divider(),
          IntrinsicHeight(
            child: (!_isSubmitted)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: (!_isStarTapped)
                        ? <Widget>[
                            GestureDetector(
                                onTap:(){
                                  Navigator.pop(context);
                                },
                                child: Text("Not Now",
                                    textScaleFactor: 1.5,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.blue)
                                )
                            ),
                          ]
                        : <Widget>[
                            GestureDetector(
                              onTap:(){
                                Navigator.pop(context);
                              },
                              child: Text("Cancel",
                                  textScaleFactor: 1.5,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.blue)),
                            ),
                            VerticalDivider(
                              endIndent: 1,
                              color: Colors.grey[500],
                            ),
                            GestureDetector(
                              onTap: () {
                                ApiCalls.submitReview(context, true, "", Methods.getRating(rating), "", "")
                                    .then((value) {
                                      setState(() {
                                        _isSubmitted = value;
                                        Navigator.pop(context);
                                      });
                                    }
                                );
                              },
                              child: Text(
                                "Submit",
                                textScaleFactor: 1.5,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold
                                )
                              ),
                            )
                          ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Text(
                          "OK",
                          textScaleFactor: 1.5,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.blue)
                        ),
                      )
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}