import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ibloov/Constants/ApiCalls.dart';
import 'package:ibloov/Constants/ColorList.dart';
import 'package:ibloov/Constants/Methods.dart';
import 'package:ibloov/Widget/NoResult.dart';
import 'package:intl/intl.dart';

import 'TicketQRCode.dart';

class MyTickets extends StatefulWidget{
  @override
  MyTicketsState createState () => MyTicketsState();
}

class MyTicketsState extends State<MyTickets>{

  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = new FocusNode();
  bool isLoading = true;
  String status = "ATTENDING";
  var dataArray, data, tickets;

  @override
  void initState(){
    ApiCalls.getTickets('')
        .then((value){
      if(value != null){
        dataArray = json.decode(value)['data'];
        data = dataArray.where((item)=> item.toString().toUpperCase().contains(status)).toList();
        setState(() {
          isLoading = false;
        });
      }
    });
    searchController.addListener(changeData);
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return isLoading
        ? Container(
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
                toolbarHeight: height * 0.085,
                automaticallyImplyLeading: false,
                elevation: 0,
                backgroundColor: ColorList.colorAccent,
                centerTitle: true,
                title: Text(
                  'My Tickets',
                  style: TextStyle(
                    fontFamily: 'SF_Pro_700',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColorList.colorPrimary,
                  ),
                ),
                flexibleSpace: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Back',
                      style: TextStyle(
                        fontFamily: 'SF_Pro_400',
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: ColorList.colorPrimary,
                      ),
                    ),
                  ),
                ),
              ),
              body: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: (){
                              FocusScope.of(context).requestFocus(new FocusNode());
                              status = "ATTENDING";
                              searchController.clear();
                              changeData();
                            },
                            child: Container(
                              width: width * 0.45,
                              height: height * 0.05,
                              color: status == "ATTENDING" ? ColorList.colorSplashBG : ColorList.colorTileExpanded,
                              child: Center(
                                child: Text(
                                  'Attending',
                                  style: TextStyle(
                                    fontFamily: status == "ATTENDING" ? 'SF_Pro_400' : 'SF_Pro_600',
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: status == "ATTENDING" ? ColorList.colorAccent : ColorList.colorGrayHint,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              FocusScope.of(context).requestFocus(new FocusNode());
                              status = "ATTENDED";
                              searchController.clear();
                              changeData();
                            },
                            child: Container(
                              width: width * 0.45,
                              height: height * 0.05,
                              color: status == "ATTENDED" ? ColorList.colorSplashBG : ColorList.colorTileExpanded,
                              child: Center(
                                child: Text(
                                  'Attended',
                                  style: TextStyle(
                                    fontFamily: status == "ATTENDED" ? 'SF_Pro_400' : 'SF_Pro_600',
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: status == "ATTENDED" ? ColorList.colorAccent : ColorList.colorGrayHint,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: width * 0.025, vertical: height * 0.01),
                        child: Card(
                          elevation: 5.0,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: searchController,
                            focusNode: searchFocusNode,
                            showCursor: true,
                            textInputAction: TextInputAction.search,
                            cursorColor: ColorList.colorPrimary,
                            maxLines: 1,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search',
                              hintStyle: TextStyle(color: ColorList.colorGray, fontSize: 14.0),
                              alignLabelWithHint: true,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: ColorList.colorGray,
                                ),
                                color: ColorList.colorPrimary,
                                onPressed: (){
                                  searchController.clear();
                                  changeData();
                                },
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: ColorList.colorPrimary,
                              ),
                            ),
                            onEditingComplete: (){
                              if(searchController.text.length > 0){
                                changeData();
                                FocusScope.of(context).requestFocus(new FocusNode());
                                SystemChannels.textInput.invokeMethod('TextInput.hide');
                              } else {
                                Methods.showError("Please type something to search!");
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  (data.length > 0)
                    ? Container(
                        margin: EdgeInsets.only(top: height * 0.15),
                        child: ListView.builder(
                            padding: EdgeInsets.all(width * 0.025),
                            physics: BouncingScrollPhysics(),
                            itemCount: data.length,
                            itemBuilder: (context, index) =>
                                showTicketChild(context, index, width)
                        ),
                      )
                    : NoResult('You haven\'t purchased any tickets yet!')
                ],
              )
            ),
          );
  }

  showTicketChild(BuildContext context, int index, double width) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TicketQRCode(data[index]['_id'], true)
            )
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.025),
        child: Column(
          children: [
            Container(
              //height: height * 0.2,
              //width: width * 0.8,
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    width: width * 0.3,
                    height: width * 0.22,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      //shape: BoxShape.circle,
                      image: DecorationImage(
                          image: Methods.getImage(data[index]['banner'], 'placeholder'),
                          fit: BoxFit.fill
                      ),
                    ),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Card(
                                  elevation: 0.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                  ),
                                  child: Padding(
                                    child: Column(
                                      children: [
                                        Text(
                                          (data[index]['startTime'] == null)
                                              ? '01'
                                              : DateFormat('dd').format(DateTime.tryParse(data[index]['startTime'])),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'SF_Pro_700',
                                            decoration: TextDecoration.none,
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.bold,
                                            color: (data[index]['startTime'] == null)
                                                ? ColorList.colorAccent
                                                : ColorList.colorPrimary,
                                          ),
                                        ),
                                        Text(
                                          (data[index]['startTime'] == null)
                                              ? 'JAN'
                                              : DateFormat('MMM').format(DateTime.tryParse(data[index]['startTime'])),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'SF_Pro_700',
                                            decoration: TextDecoration.none,
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.normal,
                                            color: (data[index]['startTime'] == null)
                                                ? ColorList.colorAccent
                                                : ColorList.colorPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.fromLTRB(6.0, 4.0, 6.0, 4.0),
                                  )
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(3.0),
                        )
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Methods.allWordsCapitalize(data[index]['category']['name']),
                        style: TextStyle(
                            fontFamily: 'SF_Pro_900',
                            fontSize: 9.0,
                            color: ColorList.colorPrimary,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none
                        ),
                      ),
                      SizedBox(
                        height: width * 0.02,
                      ),
                      SizedBox(
                        width: width * 0.5,
                        child: Text(
                          data[index]['title'],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: 'SF_Pro_900',
                              fontSize: 15.0,
                              color: ColorList.colorSearchList,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      SizedBox(
                        width: width * 0.5,
                        child: Text(
                          (data[index]['location'] != null) ? data[index]['location']['name'] : "Location not available",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: 'SF_Pro_700',
                              fontSize: 12.0,
                              color: ColorList.colorSearchListPlace,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none
                          ),
                        ),
                      ),
                      SizedBox(
                        height: width * 0.02,
                      ),
                      SizedBox(
                        width: width * 0.5,
                        child: RichText(
                          text: TextSpan(
                              text: '${getTicketCount(data[index]['tickets'])}',
                              style: TextStyle(
                                  fontFamily: 'SF_Pro_800',
                                  fontSize: 12.0,
                                  color: ColorList.colorSearchListMore,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: (getTicketCount(data[index]['tickets']) > 1) ? ' Tickets' : ' Ticket',
                                  style: TextStyle(
                                      fontFamily: 'SF_Pro_600',
                                      fontSize: 12.0,
                                      color: ColorList.colorSearchListMore,
                                      fontWeight: FontWeight.normal,
                                      decoration: TextDecoration.none
                                  ),
                                ),
                              ]
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Image.asset(
                    'assets/images/icon_arrow.png',
                    width: 8,
                    height: 15,
                    fit: BoxFit.fill,
                    color: ColorList.colorPrimary,
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
              color: ColorList.colorButtonBorder,
            )
          ],
        ),
      ),
    );
  }

  void changeData() {
    setState(() {
      if(searchController.text.length > 0)
        data.clear();
      data = dataArray
          .where((item)=> item.toString().toUpperCase().contains(status))
          .where((item)=> item.toString().toLowerCase().contains(searchController.text.toLowerCase()))
          .toList();
    });
  }

  getTicketCount(data) {
    var count = 0;

    for(int i=0; i<data.length; i++){
      count += data[i]['quantity'];
    }

    return count;
  }
}