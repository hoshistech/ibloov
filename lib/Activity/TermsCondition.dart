import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:ibloov/Constants/ApiCalls.dart';
import 'package:ibloov/Constants/ColorList.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsCondition extends StatefulWidget {
  @override
  TermsConditionState createState() => TermsConditionState();
}
class TermsConditionState extends State<TermsCondition> {

  bool isLoading = true;
  var data;

  @override
  void initState() {
    super.initState();
    ApiCalls.getInformation('terms')
        .then((value) {
      setState(() {
        isLoading = false;
        data = json.decode(value)['data']['content'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;

    Widget text() {
      return Container(
        margin: EdgeInsets.only(top: 14),
        child: Text(
          'Terms Effective Date: ${DateFormat('MMMM dd, yyyy').format(DateTime.tryParse(data['effectiveDate']))}',
          style: TextStyle(
            fontFamily: 'SF_Pro_400',
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: ColorList.colorPrimary,
          ),
        ),
      );
    }

    Widget desc(data) {
      return Container(
        //margin: EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40.0,
            ),
            Text(
              data['header'],
              style: TextStyle(
                fontFamily: 'SF_Pro_400',
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: ColorList.colorPrimary,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              data['content'],
              style: TextStyle(
                fontFamily: 'SF_Pro_400',
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: ColorList.colorPrimary,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      );
    }

    return isLoading
        ? Container(
            height: height,
            color: ColorList.colorAccent,
            child: Center(
              child: CircularProgressIndicator(
                color: ColorList.colorSeeAll,
              ),
            ),
        )
        : SafeArea(
          child: Scaffold(
            backgroundColor: ColorList.colorAccent,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: ColorList.colorAccent,
              centerTitle: true,
              title: Text(
                'Terms & Conditions',
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
                        fontFamily: 'SF_Pro_700',
                        fontSize: 15,
                        color: ColorList.colorBack,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none
                    ),
                  ),
                ),
              ),
            ),
            body: Container(
              //margin: EdgeInsets.symmetric(horizontal: 20.0),
              child: WebView(
                  initialUrl: 'https://ibloov-landing-page-v2-staging.herokuapp.com/terms-of-service'
              )/*ListView(
                children: [
                  text(),
                  ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data['body'].length,
                    itemBuilder: (BuildContext context, int item) =>
                        Column(
                          children: [
                            desc(data['body'][item]),
                            SizedBox(
                              height: 40.0,
                            )
                          ],
                        )
                  ),
                ],
              )*/,
            ),
          ),
        );
  }
}