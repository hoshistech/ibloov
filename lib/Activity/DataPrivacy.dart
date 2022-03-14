import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:ibloov/Constants/ApiCalls.dart';
import 'package:ibloov/Constants/ColorList.dart';

class DataPrivacy extends StatefulWidget {
  @override
  DataPrivacyState createState() => DataPrivacyState();
}
class DataPrivacyState extends State<DataPrivacy> {

  bool isLoading = true;
  var data, date;

  @override
  void initState() {
    super.initState();
    ApiCalls.getInformation('privacy')
        .then((value) {
      setState(() {
        isLoading = false;
        data = json.decode(value)['data'];
        date = json.decode(value)['data']['updatedAt'];
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
          'Last modified: ${DateFormat('MMMM dd, yyyy').format(DateTime.tryParse(date))}',
          style: TextStyle(
            fontFamily: 'SF_Pro_400',
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: ColorList.colorPrimary.withOpacity(0.6),
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
              height: 20,
            ),
            Text(
              data,
              style: TextStyle(
                fontFamily: 'SF_Pro_400',
                fontSize: 14,
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
                'Data Privacy',
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
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView(
                children: [
                  text(),
                  ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data['content'].length,
                    itemBuilder: (BuildContext context, int item) =>
                        Column(
                          children: [
                            desc(data['content'][item]),
                            SizedBox(
                              height: 40.0,
                            )
                          ],
                        )
                  ),
                ],
              ),
            ),
          ),
        );
  }
}