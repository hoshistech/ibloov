import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ibloov/Constants/ApiCalls.dart';

import 'package:ibloov/Constants/ColorList.dart';
import 'package:ibloov/Constants/Methods.dart';
import 'package:ibloov/Utils/FilterFrame.dart';
import 'package:intl/intl.dart';

var width, height;

class SearchResult extends StatefulWidget{
  final searchController;
  SearchResult(this.searchController);

  @override
  SearchResultState createState() => SearchResultState();
}

class SearchResultState extends State<SearchResult> {

  List categories = ['Events', 'Artists', 'People', 'Hashtags'];
  int catIndex = 0;
  var searchController = TextEditingController();
  FocusNode searchFocusNode = new FocusNode();
  String keyword = "";
  bool search = false;

  int page0 = 1, totalCount0 = 0;
  int page1 = 1, totalCount1 = 0;
  int page2 = 1, totalCount2 = 0;
  int page3 = 1, totalCount3 = 0;
  var result0 = [];
  var result1 = [];
  var result2 = [];
  var result3 = [];
  bool isLoading0 = false;
  bool isLoading1 = false;
  bool isLoading2 = false;
  bool isLoading3 = false;


  @override
  void initState() {
    super.initState();

    getData(true);
  }

  @override
  Widget build(BuildContext context) {

    searchController = widget.searchController;

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    if(widget.searchController.text == null
        || widget.searchController.text == "") {
      clearSearch();
      isLoading0 = isLoading1 = isLoading2 = isLoading3 = false;
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: InkWell(
          onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
          child: Container(
            height: height,
            padding: EdgeInsets.fromLTRB(15.0, height * 0.075, 15.0, 10.0),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: const Alignment(0.0, -1),
                    end: const Alignment(0.0, 0.6),
                    colors: [ColorList.colorBackground, Colors.white]
                )
            ),
            child: Column(
              children: [
                Card(
                  elevation: 10.0,
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: searchController,
                    focusNode: searchFocusNode,
                    textInputAction: TextInputAction.search,
                    cursorColor: ColorList.colorPrimary,
                    maxLines: 1,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search for events, people or hashtag',
                        hintStyle: TextStyle(color: ColorList.colorGray, fontSize: 14.0),
                        alignLabelWithHint: true,
                        prefixIcon: IconButton(
                          icon: searchController.text.isNotEmpty ? Icon(
                            Icons.close,
                            color: ColorList.colorGray,
                          ) : Icon(
                            Icons.arrow_back,
                            color: ColorList.colorGray,
                          ),
                          color: ColorList.colorPrimary,
                          onPressed: (){
                            if(searchController.text.isEmpty) {
                              Navigator.pop(context);
                              SystemChannels.textInput.invokeMethod('TextInput.hide');
                            } else {
                              clearSearch();
                              clearArrays();
                            }
                          },
                        ),
                        // suffixIcon: IconButton(
                        //   icon: Icon(
                        //     Icons.tune,
                        //     color: ColorList.colorGray,
                        //   ),
                        //   color: ColorList.colorPrimary,
                        //   onPressed: (){
                        //     setState(() {
                        //       search = true;
                        //     });
                        //     Methods.openSearchFilter(context, height, width, searchFocusNode);
                        //   },
                        // )
                    ),
                    onChanged: (value){
                      if(value.length > 3)
                        getData(true);
                      else {
                        clearArrays();
                      }
                    },
                    onEditingComplete: (){
                      if(searchController.text.length > 0){
                        if(search)
                          getData(true);
                        FocusScope.of(context).requestFocus(new FocusNode());
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                      } else {
                        Methods.showError("Please type something to search!");
                      }
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 15.0),
                  child: ListView(
                    //shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: new List.generate(categories.length, (int index) {
                      return Padding(
                        padding: EdgeInsets.zero,
                        child: MaterialButton(
                          elevation: 0.0,
                          splashColor: Colors.transparent,
                          textColor: (index == catIndex) ? ColorList.colorPrimary : ColorList.colorPrimary.withOpacity(0.3),
                          child: Text(
                            categories[index],
                            style: TextStyle(
                              fontFamily: 'SF_Pro_900',
                              decoration: TextDecoration.none,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            if(index != catIndex){
                              setState(() {
                                catIndex = index;
                                int page = 0;
                                if(catIndex == 0) {
                                  page = page0;
                                } else if(catIndex == 1) {
                                  page = page1;
                                } else if(catIndex == 2) {
                                  page = page2;
                                } else if(catIndex == 3) {
                                  page = page3;
                                }
                                if(searchController.text != keyword || page == 1) {
                                  keyword = searchController.text;
                                  getData(true);
                                }
                              });
                            }
                          },
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(0.0),
                          ),
                        ),
                      );
                    }),
                  ),
                  height: 40.0,
                ),
                getResult()
              ],
            ),
          ),
        ),
      ),
    );
  }

  void clearArrays() {
    setState(() {
      result0.clear();
      result1.clear();
      result2.clear();
      result3.clear();
    });
  }

  void clearSearch() {
    searchController.clear();
    page0 = page1 = page2 = page3 = 1;
    totalCount0 = totalCount1 = totalCount2 = totalCount3 = 1;
    FocusScope.of(context).requestFocus(searchFocusNode);
  }

  getResult() {
    Widget body = Container();

    if(catIndex == 0){
      body = Container(
        height: height * 0.75,
        child: (isLoading0 && page0 == 1)
          ? Center(child: new CircularProgressIndicator())
          : (result0.length > 0)
            ? Column(
              children: [
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!isLoading0 && page0 <= totalCount0 && totalCount0 > 0
                          && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent
                      ) {
                        getData(false);
                      }
                      return true;
                    },
                    child: RefreshIndicator(
                      child: ListView(
                        //shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        children: new List.generate(result0.length, (int index) {
                          return InkWell(
                            onTap: (){
                              Methods.openEventDetails(context, result0[index]['_id']);
                            },
                            child: Container(
                              width: width,
                              //height: 50.0,
                              padding: EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 10),
                                    width: height * 0.11,
                                    height: height * 0.08,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      //shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: Methods.getSmallEventCardImage(result0[index]['banner']),
                                          fit: BoxFit.fill
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        (result0[index]['startTime'] != null)
                                            ? DateFormat('EEEE, dd MMM yyyy hh.mm a').format(DateTime.tryParse(result0[index]['startTime']))
                                            : "Undefined",
                                        style: TextStyle(
                                            fontFamily: 'SF_Pro_900',
                                            fontSize: 9.0,
                                            color: ColorList.colorPrimary,
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.none
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      SizedBox(
                                        width: width * 0.5,
                                        child: Text(
                                          result0[index]['title'],
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontFamily: 'SF_Pro_700',
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
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: width * 0.25,
                                            child: Text(
                                              (result0[index]['location'] != null) ? result0[index]['location']['name'] : "Location not available",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontFamily: 'SF_Pro_700',
                                                  fontSize: 10.0,
                                                  color: ColorList.colorSearchListPlace,
                                                  fontWeight: FontWeight.normal,
                                                  decoration: TextDecoration.none
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5,),
                                          SizedBox(
                                            width: width * 0.25,
                                            child: Text(
                                              "Starting from ${Methods.getLowestPrice(result0[index]['tickets'], false)}",
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontFamily: 'SF_Pro_700',
                                                  fontSize: 10.0,
                                                  color: ColorList.colorSearchListPlace,
                                                  fontWeight: FontWeight.normal,
                                                  decoration: TextDecoration.none
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  InkWell(
                                      splashColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      onTap: (){
                                        setState(() {
                                          result0[index]['userLiked'] = !result0[index]['userLiked'];
                                        });

                                        ApiCalls.toggleLike(result0[index]['_id'])
                                            .then((value){
                                          if(!value)
                                            setState(() {
                                              result0[index]['userLiked'] = !result0[index]['userLiked'];
                                            });
                                        });
                                      },
                                      child: Container(
                                        child: Icon(
                                          (result0[index]['userLiked']) ? Icons.favorite : Icons.favorite_outline,
                                          size: 20,
                                          color: (result0[index]['userLiked']) ? ColorList.colorRed : ColorList.colorPrimary,
                                        ),
                                        padding: EdgeInsets.all(5.0),
                                      )
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                      onRefresh: () {
                        return Future.delayed(
                          Duration(seconds: 1),
                              () {
                            getData(true);
                          },
                        );
                      },
                    )
                  ),
                ),
                Container(
                  height: (isLoading0) ? 50.0 : 0,
                  color: Colors.transparent,
                  child: Center(
                    child: new CircularProgressIndicator(),
                  ),
                ),
              ],
            )
            : noResult()
      );
    }
    else if(catIndex == 1){
      body = Container(
        height: height * 0.75,
        child: (isLoading1 && page1 == 1)
          ? Center(child: new CircularProgressIndicator())
          : (result1.length > 0)
            ? Column(
              children: [
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!isLoading1 && page1 <= totalCount1 && totalCount1 > 0
                          && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent
                      ) {
                        getData(false);
                      }
                      return true;
                    },
                    child: RefreshIndicator(
                      child: ListView(
                        //shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        children: new List.generate(result1.length, (int index) {
                          return InkWell(
                            onTap: (){
                              Methods.openArtistDetails(context, result1[index]['_id']);
                            },
                            child: Container(
                              width: width,
                              //height: 50.0,
                              padding: EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 15),
                                    width: height * 0.075,
                                    height: height * 0.075,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: Methods.getImage(result1[index]['imgUrl'], 'profile'),
                                          fit: BoxFit.cover
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        result1[index]['name'],
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontFamily: 'SF_Pro_900',
                                            fontSize: 14.0,
                                            color: ColorList.colorPrimary,
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.none
                                        ),
                                      ),
                                      Text(
                                        getGenres(result1[index]),
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontFamily: 'SF_Pro_400',
                                            fontSize: 13.0,
                                            color: ColorList.colorDetails,
                                            fontWeight: FontWeight.normal,
                                            decoration: TextDecoration.none
                                        ),
                                      ),
                                      Text(
                                        "No Next Event",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontFamily: 'SF_Pro_400',
                                            fontSize: 13.0,
                                            color: ColorList.colorDetails,
                                            fontWeight: FontWeight.normal,
                                            decoration: TextDecoration.none
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                      onRefresh: () {
                        return Future.delayed(
                          Duration(seconds: 1),
                              () {
                            getData(true);
                          },
                        );
                      },
                    )
                  ),
                ),
                Container(
                  height: (isLoading1) ? 50.0 : 0,
                  color: Colors.transparent,
                  child: Center(
                    child: new CircularProgressIndicator(),
                  ),
                ),
              ],
            )
            : noResult()
      );
    }
    else if(catIndex == 2){
      body = Container(
        height: height * 0.75,
        child: (isLoading2 && page2 == 1)
            ? Center(child: new CircularProgressIndicator())
            : (result2.length > 0)
              ? Column(
                children: [
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!isLoading2 && page2 <= totalCount2 && totalCount2 > 0
                          && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent
                      ) {
                        getData(false);
                      }
                      return true;
                    },
                    child: RefreshIndicator(
                      child: ListView(
                        //shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        children: new List.generate(result2.length, (int index) {
                          return InkWell(
                            onTap: (){
                              Methods.openUserDetails(context, result2[index]['_id']);
                            },
                            child: Container(
                              width: width,
                              //height: 50.0,
                              padding: EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 15),
                                    width: height * 0.075,
                                    height: height * 0.075,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: Methods.getImage(result2[index]['imageUrl'], 'profile'),
                                          fit: BoxFit.cover
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        result2[index]['fullName'],
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontFamily: 'SF_Pro_900',
                                            fontSize: 14.0,
                                            color: ColorList.colorPrimary,
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.none
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                      onRefresh: () {
                        return Future.delayed(
                          Duration(seconds: 1),
                              () {
                            getData(true);
                          },
                        );
                      },
                    )
                  ),
                ),
                Container(
                  height: (isLoading2) ? 50.0 : 0,
                  color: Colors.transparent,
                  child: Center(
                    child: new CircularProgressIndicator(),
                  ),
                ),
              ],
            )
              : noResult()
      );
    }
    else if(catIndex == 3){
      body = Container(
        height: height * 0.75,
        child: (isLoading3 && page3 == 1)
            ? Center(child: new CircularProgressIndicator())
            : (result3.length > 0)
            ? Column(
              children: [
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!isLoading3 && page3 <= totalCount3 && totalCount3 > 0
                          && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent
                      ) {
                        getData(false);
                      }
                      return true;
                    },
                    child: RefreshIndicator(
                      child: ListView(
                        //shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        children: new List.generate(result3.length, (int index) {
                          return InkWell(
                            onTap: (){
                              Methods.openEventDetails(context, result3[index]['_id']);
                            },
                            child: Container(
                              width: width,
                              //height: 50.0,
                              padding: EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 10),
                                    width: height * 0.11,
                                    height: height * 0.08,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      //shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: Methods.getSmallEventCardImage(result3[index]['banner']),
                                          fit: BoxFit.fill
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        (result3[index]['startTime'] != null)
                                            ? DateFormat('EEEE, dd MMM yyyy hh.mm a').format(DateTime.tryParse(result3[index]['startTime']))
                                            : "Undefined",
                                        style: TextStyle(
                                            fontFamily: 'SF_Pro_900',
                                            fontSize: 9.0,
                                            color: ColorList.colorPrimary,
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.none
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      SizedBox(
                                        width: width * 0.5,
                                        child: Text(
                                          result3[index]['title'],
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontFamily: 'SF_Pro_700',
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
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: width * 0.25,
                                            child: Text(
                                              (result3[index]['location'] != null) ? result3[index]['location']['name'] : "Location not available",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontFamily: 'SF_Pro_700',
                                                  fontSize: 10.0,
                                                  color: ColorList.colorSearchListPlace,
                                                  fontWeight: FontWeight.normal,
                                                  decoration: TextDecoration.none
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5,),
                                          SizedBox(
                                            width: width * 0.25,
                                            child: Text(
                                              "Starting from ${Methods.getLowestPrice(result3[index]['tickets'], false)}",
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontFamily: 'SF_Pro_700',
                                                  fontSize: 10.0,
                                                  color: ColorList.colorSearchListPlace,
                                                  fontWeight: FontWeight.normal,
                                                  decoration: TextDecoration.none
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  InkWell(
                                      splashColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      onTap: (){
                                        setState(() {
                                          result3[index]['userLiked'] = !result3[index]['userLiked'];
                                        });

                                        ApiCalls.toggleLike(result3[index]['_id'])
                                            .then((value){
                                          if(!value)
                                            setState(() {
                                              result3[index]['userLiked'] = !result3[index]['userLiked'];
                                            });
                                        });
                                      },
                                      child: Container(
                                        child: Icon(
                                          (result0[index]['userLiked']) ? Icons.favorite : Icons.favorite_outline,
                                          size: 20,
                                          color: (result0[index]['userLiked']) ? ColorList.colorRed : ColorList.colorPrimary,
                                        ),
                                        padding: EdgeInsets.all(5.0),
                                      )
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                      onRefresh: () {
                        return Future.delayed(
                          Duration(seconds: 1),
                              () {
                            getData(true);
                          },
                        );
                      },
                    )
                  ),
                ),
                Container(
                  height: (isLoading1) ? 50.0 : 0,
                  color: Colors.transparent,
                  child: Center(
                    child: new CircularProgressIndicator(),
                  ),
                ),
              ],
            )
            : noResult()
      );
    }

    return body;
  }

  void getData(state) {
    setState(() {
      if(catIndex == 0) {
        isLoading0 = true;
        if(state)
          page0 = 1;
      } else if(catIndex == 1) {
        isLoading1 = true;
        if(state)
          page1 = 1;
      } else if(catIndex == 2) {
        isLoading2 = true;
        if(state)
          page2 = 1;
      } else if(catIndex == 3) {
        isLoading3 = true;
        if(state)
          page3 = 1;
      }
      search = false;
    });

    if(catIndex == 0){
      ApiCalls.searchEvents(widget.searchController.text, page0)
          .then((value) => {
            setState((){
              isLoading0 = false;
              if(value != null){
                if(page0 == 1) {
                  result0.clear();
                  totalCount0 = json.decode(value)['data']['pagination']['total'];
                  totalCount0 = (totalCount0/10 + 1).toInt();
                }

                for(int i=0; i<json.decode(value)['data']['data'].length; i++){
                  result0.add(json.decode(value)['data']['data'][i]);
                }
                page0++;
                result0 = filterResult(result0);
              }
            })
          });
    } else if(catIndex == 1){
      ApiCalls.searchArtists(widget.searchController.text, page1)
          .then((value) => {
            setState(() {
              isLoading1 = false;
              if(value != null){
                if(page1 == 1) {
                  result1.clear();
                  totalCount1 = json.decode(value)['data']['pagination']['total'];
                  totalCount1 = (totalCount1/10 + 1).toInt();
                }

                for(int i=0; i<json.decode(value)['data']['data'].length; i++){
                  result1.add(json.decode(value)['data']['data'][i]);
                }
                page1++;
              }
            })
          });
    } else if(catIndex == 2){
      ApiCalls.searchUsers(widget.searchController.text, page2)
          .then((value) => {
            setState(() {
              isLoading2 = false;
              if(value != null){
                if(page2 == 1) {
                  result2.clear();
                  totalCount2 = json.decode(value)['data']['pagination']['total'];
                  totalCount2 = (totalCount2/10 + 1).toInt();
                }

                for(int i=0; i<json.decode(value)['data']['data'].length; i++){
                  result2.add(json.decode(value)['data']['data'][i]);
                }
                page2++;
              }
            })
          });
    } else if(catIndex == 3){
      ApiCalls.searchHashtags(widget.searchController.text, page3)
          .then((value) => {
            setState(() {
              isLoading3 = false;
              if(value != null){
                if(page3 == 1) {
                  result3.clear();
                  totalCount3 = json.decode(value)['data']['pagination']['total'];
                  totalCount3 = (totalCount3/10 + 1).toInt();
                }

                for(int i=0; i<json.decode(value)['data']['data'].length; i++){
                  result3.add(json.decode(value)['data']['data'][i]);
                }
                page3++;
                result3 = filterResult(result3);
              }
            })
          });
    }
  }

  getGenres(data) {
    String genres = '';
    var list = data['genre'];

    for(int i=0; i<list.length; i++){
      genres += list[i] + ', ';
    }

    return genres.substring(0, genres.length-2);
  }

  noResult(){
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
                    'No events found',
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
                    'We can\'t find any event matching your search',
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
            Container(
              padding: EdgeInsets.only(top: 60, left: width * 0.2, right: width * 0.2),
              child: MaterialButton(
                height: 50.0,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                onPressed: () {
                  FocusScope.of(context).requestFocus(searchFocusNode);
                  SystemChannels.textInput.invokeMethod('TextInput.show');
                  // getData(true);
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
            )
          ],
        )
    );
  }

  filterResult(result) {
    if(Methods.data != null){
      print(Methods.data['latitude']);
      print(Methods.data['longitude']);
      print(Methods.data['start_date']);
      print(Methods.data['end_date']);
      result = result.where(
              (data) => (((data['location']['coordinates'][0] >= Methods.data['latitude'] - 0.0011
                            && data['location']['coordinates'][0] <= Methods.data['latitude'] + 0.0011)
                        || (data['location']['coordinates'][1] >= Methods.data['longitude'] - 0.0055
                            && data['location']['coordinates'][1] <= Methods.data['longitude'] + 0.0055))
                        && Methods.locationIndex != 0)
                        && (getPriceComparison(Methods.data['min_price'], Methods.data['max_price'], data['tickets'])
                        && (Methods.rangeValues.end.toInt() - Methods.rangeValues.start.toInt()) > 0)
                        && (getDateComparison(Methods.data['start_date'], Methods.data['end_date'], data['startTime'], data['endTime'])
                        && Methods.dateIndex != 0)

      ).toList();
    }

    return result;
  }

  getPriceComparison(dataMin, dataMax, dataTickets) {
    bool compare = true;
    int lowest = 0;
    int highest = 0;

    if(dataTickets != null){
      if(dataTickets.length > 0) {
        if(dataTickets[0]['price'] != null) {
          lowest = dataTickets[0]['price'];
          highest = dataTickets[0]['price'];
        } else {
          highest = 0;
          lowest = 0;
        }
      }

      for(int i=0; i<dataTickets.length; i++){
        if(dataTickets[0]['price'] != null && lowest > dataTickets[i]['price']) {
          lowest = dataTickets[i]['price'];
        }
        if(dataTickets[0]['price'] != null && highest < dataTickets[i]['price']) {
          highest = dataTickets[i]['price'];
        }
      }

      if(lowest <= dataMax && highest >= dataMax)
        compare = true;

    } else
      compare = false;

    return compare;
  }

  getDateComparison(dataMin, dataMax, dataStart, dataEnd) {
    bool compare = false;

    if(dataMin != '' && dataMax != '')
      if((DateTime.parse(dataMin).isAtSameMomentAs(DateTime.parse(dataStart))
          || DateTime.parse(dataMin).isAfter(DateTime.parse(dataStart)))
          && (DateTime.parse(dataMax).isAtSameMomentAs(DateTime.parse(dataEnd))
              || DateTime.parse(dataMax).isBefore(DateTime.parse(dataEnd)))) {
        compare = true;
      }
    else
        compare = false;

    return compare;
  }
}