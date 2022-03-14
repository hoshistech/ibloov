import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/services.dart';

import 'package:ibloov/Constants/ApiCalls.dart';
import 'package:ibloov/Constants/ColorList.dart';
import 'package:ibloov/Constants/Methods.dart';
import 'package:ibloov/Widget/FAQCard.dart';
import 'package:ibloov/Widget/NoResult.dart';

class FAQ extends StatefulWidget {
  @override
  FAQState createState() => FAQState();
}
class FAQState extends State<FAQ> {

  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = new FocusNode();
  bool isLoading = true;
  var dataArray, data;

  @override
  void initState() {
    super.initState();

    if(dataArray != null)
      dataArray.clear();

    getFAQ();
  }

  void getFAQ() {
    ApiCalls.getInformation('faq')
        .then((value) {
      setState(() {
        isLoading = false;
        if(value != null) {
          data = json.decode(value)['data']['content'];
          changeData();
        }
      });
    });
    searchController.addListener(changeData);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;

    Widget search() {
      return Container(
        margin: EdgeInsets.all(15.0),
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
                hintText: 'Search for keywords',
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
                    setState(() {
                      dataArray = data;
                    });
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
      );
    }

    Widget content() {
      return Container(
        margin: EdgeInsets.only(
          top: 80,
          //left: 20,
          //right: 20,
        ),
        child: ContainedTabBarView(
          tabBarProperties: TabBarProperties(
            labelPadding: EdgeInsets.symmetric(horizontal: 15),
            indicatorSize: TabBarIndicatorSize.tab,
            isScrollable: true,
            height: 35,
            indicatorColor: ColorList.colorSplashBG,
            indicatorWeight: 3.0,
            labelColor: ColorList.colorPrimary,
            unselectedLabelColor: ColorList.colorCorousalIndicatorInactive,
          ),
          tabs: getTabs(),
          views: getViews(),
        ),
      );
    }

    body() {
      return Stack(
        children: [
          search(),
          content(),
        ],
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
                  'FAQs',
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
                        fontFamily: 'SF_Pro_400',
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: ColorList.colorPrimary,
                      ),
                    ),
                  ),
                ),
              ),
              body: body(),
            ),
          );
  }

  getTabs() {
    List<Widget> tabs = [];
    for(int i=0; i<data.length; i++){
      tabs.add(
          Text(
            Methods.allWordsCapitalize(data[i]['name']),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'SF_Pro_600',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: ColorList.colorPrimary,
            ),
          )
      );
    }
    return tabs;
  }

  getViews() {
    List<Widget> views = [];
    for(int i=0; i<data.length; i++){
      views.add(
        RefreshIndicator(
          child: Container(
            margin: EdgeInsets.only(
                top: 20,
                bottom: 20
            ),
            child:
            (dataArray[i]['content'].length > 0)
                ? ListView.builder(
                    //shrinkWrap: true,
                    itemCount: dataArray[i]['content'].length,
                    itemBuilder: (BuildContext context, int item) =>
                        FAQCard(dataArray[i]['content'][item]),
                  )
                : NoResult('Your query is not in our database yet!')
          ),
          onRefresh: (){
            return Future.delayed(
              Duration(seconds: 1),
                  () {
                setState(() {
                  isLoading = true;
                });
                getFAQ();
              },
            );
          },
        )
      );
    }
    return views;
  }

  void changeData() {
    if(searchController.text.length > 0) {
      dataArray = [];

      for(int i=0; i<data.length; i++){
        var dataChild = data[i];
        var dataContent = dataChild['content'];
        var dataContentResult = [];

        for(int j=0; j< dataContent.length; j++){
          var dataContentChild = dataContent[j];

          if(dataContentChild.toString().toLowerCase().contains(searchController.text.toLowerCase())){
            dataContentResult.add(dataContentChild);
          }
        }

        setState(() {
          dataArray.add(DataContent(dataChild['name'], dataContentResult).toJson());
        });

      }

    } else {
      setState(() {
        dataArray = data;
      });
    }
  }
}

class DataContent {
  String name;
  List content;

  DataContent(this.name, this.content);

  Map toJson() => {
    'name': name,
    'content': content
  };
}