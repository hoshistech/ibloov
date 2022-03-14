import 'package:flutter/cupertino.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:ibloov/Constants/ColorList.dart';

class FAQCard extends StatefulWidget {
  var data;
  FAQCard(this.data);

  @override
  _FAQCardState createState() => _FAQCardState();
}

class _FAQCardState extends State<FAQCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 20,
            top: 2,
            right: 20,
            bottom: 2,
          ),
          child: ExpansionTileCard(
            animateTrailing: true,
            //baseColor: ColorList.colorHeaderOpaque,
            expandedColor: ColorList.colorTileExpanded,
            expandedTextColor: ColorList.colorPrimary,
            initialElevation: 1.0,
            elevation: 1.0,
            duration: Duration(milliseconds: 350),
            contentPadding: EdgeInsets.only(
              left: 18.0,
              //top: 4.0,
              right: 15.0,
            ),
            title: Text(
              (widget.data['questions'] != "")
                  ? widget.data['questions']
                  : "No question",
              style: TextStyle(
                fontFamily: 'SF_Pro_600',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: ColorList.colorPrimary,
              ),
            ),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 20.0,
                    //top: 4.0,
                    right: 20.0,
                    bottom: 16.0
                  ),
                  child: Text(
                    (widget.data['answer'] != "")
                        ? widget.data['answer']
                        : "No answer",
                    style: TextStyle(
                      fontFamily: 'SF_Pro_400',
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: ColorList.colorPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}