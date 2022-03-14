import 'package:flutter/cupertino.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:ibloov/Constants/ColorList.dart';

class NoResult extends StatefulWidget {
  var msg;
  NoResult(this.msg);

  @override
  NoResultState createState() => NoResultState();
}

class NoResultState extends State<NoResult> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
                width: 120,
                height: 120,
                child: Image.asset('assets/images/no_result.png')
            ),
            Container(
                padding: EdgeInsets.only(top: 25),
                child: Center(
                  child: Text(
                    'No results found',
                    style: TextStyle(
                        fontFamily: 'SF_Pro_900',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColorList.colorSearchList,
                        decoration: TextDecoration.none
                    ),
                  ),
                )
            ),
            Container(
                padding: EdgeInsets.only(top: 15),
                child: Center(
                  child: Text(
                    widget.msg,
                    style: TextStyle(
                        fontFamily: 'SF_Pro_900',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: ColorList.colorSearchListPlace,
                        decoration: TextDecoration.none
                    ),
                  ),
                )
            ),
            /*Container(
              padding: EdgeInsets.only(top: 60, left: width * 0.2, right: width * 0.2),
              child: MaterialButton(
                height: 50.0,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                onPressed: () {
                  FocusScope.of(context).requestFocus(searchFocusNode);
                  SystemChannels.textInput.invokeMethod('TextInput.show');
                },
                color: ColorList.colorSplashBG,
                child: Text(
                  'Search again',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'SF_Pro_600',
                    decoration: TextDecoration.none,
                    fontSize: 15.0,
                    fontWeight: FontWeight.normal,
                    color: ColorList.colorAccent,
                  ),
                ),
              ),
            )*/
          ],
        )
    );
  }
}