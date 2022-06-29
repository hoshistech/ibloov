import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ibloov/Activity/SearchResult.dart';
import 'package:ibloov/Constants/ApiCalls.dart';

import 'package:ibloov/Constants/ColorList.dart';
import 'package:ibloov/Constants/Methods.dart';
import 'package:ibloov/Utils/FilterFrame.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchWidget extends StatefulWidget{
  @override
  SearchWidgetState createState() => SearchWidgetState();
}

class SearchWidgetState extends State<SearchWidget>{
  double height, width;
  final searchController = TextEditingController();
  List categories = [];
  bool gettingCategories = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getCategories();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: RefreshIndicator(
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
                    textInputAction: TextInputAction.search,
                    cursorColor: ColorList.colorPrimary,
                    maxLines: 1,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search for events, people or hashtag',
                      hintStyle: TextStyle(color: ColorList.colorGray, fontSize: 14.0),
                      alignLabelWithHint: true,
                      prefixIcon: Icon(
                          Icons.search,
                          color: ColorList.colorGray
                      ),
                      // suffixIcon: IconButton(
                      //   icon: Icon(
                      //     Icons.tune,
                      //     color: ColorList.colorGray,
                      //   ),
                      //   color: ColorList.colorPrimary,
                      //   onPressed: (){
                      //     Methods.openSearchFilter(context, height, width, new FocusNode());
                      //   },
                      // ),
                    ),
                    onEditingComplete: (){
                      if(searchController.text == null
                          || searchController.text == "")
                        Methods.showError("Please type something to search!");
                      else
                        Methods.openSearch(context, searchController);
                    },
                  ),
                ),
                Container(
                  width: width,
                  padding: EdgeInsets.fromLTRB(5.0, height * 0.02, 5.0, 5.0),
                  child: Text(
                    'Categories',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: 'SF_Pro_900',
                      decoration: TextDecoration.none,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: ColorList.colorPrimary,
                    ),
                  ),
                ),
                Container(
                  height: height * 0.75,
                  width: width,
                  padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0.0),
                  child: (gettingCategories)
                      ? Center(
                        child: CircularProgressIndicator(
                          color: ColorList.colorSeeAll,
                        ),
                      )
                      : GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: (2 / 1.5),
                          crossAxisSpacing: 0.0,
                          mainAxisSpacing: 10.0,
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          children: List.generate(categories.length, (int index) {
                            return Card(
                                elevation: 0.0,
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    searchController.text = json.decode(categories[index])["name"];
                                    //Methods.showToast('${json.decode(categories[index])["name"]} clicked');
                                    Methods.openSearch(context, searchController);
                                  },
                                  child: Container(
                                      padding: EdgeInsets.only(left: 10.0),
                                      margin: EdgeInsets.zero,
                                      child: Container(
                                        child: ClipRRect(
                                          child: Stack(
                                            children: [
                                              if(gettingCategories)
                                                Container(
                                                child: Center(
                                                    child: CircularProgressIndicator(
                                                      color: ColorList.colorPrimary,
                                                      strokeWidth: 3.0,
                                                    )
                                                ),
                                              ),
                                              Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(json.decode(categories[index])["imageUrl"]),
                                                    ),
                                                  )
                                              ),
                                              Container(
                                                color: ColorList.colorPrimary.withOpacity(0.6),
                                              ),
                                              Center(
                                                child: Text(
                                                  json.decode(categories[index])["name"],
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontFamily: 'SF_Pro_600',
                                                    decoration: TextDecoration.none,
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: ColorList.colorAccent,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(10.0),),
                                        ),
                                      )
                                  ),
                                )
                            );
                          },),
                        ),
                ),
              ],
            ),
          ),
        ),
        onRefresh: () {
          return Future.delayed(
            Duration(seconds: 1),
                () {
              setState(() {
                gettingCategories = true;
              });
              getCategories();
            },
          );
        },
      ),
    );
  }

  Future<void> getCategories() async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
   int count = prefs.getInt('categoriesCount');
   setState(() {
     if(count > 0){
       var data = json.decode(prefs.getString('categoriesData'))['data'];

       categories.clear();

       for(int i=0; i<data.length; i++){
         categories.add(json.encode(data[i]));
       }
       gettingCategories = false;
     } else {
       gettingCategories = true;
     }
   });

    ApiCalls.fetchCategories()
        .then((value){
      setState(() {
        if(value != null){
          var data = json.decode(value)['data'];

          if(data.length != count){
            debugPrint("count: $count");
            debugPrint("length: ${data.length}");
            gettingCategories = true;

            categories.clear();

            for(int i=0; i<data.length; i++){
              categories.add(json.encode(data[i]));
            }
            gettingCategories = false;
            prefs.setString('categoriesData', value);
            prefs.setInt('categoriesCount', data.length);
          }
        }
      });
    });
  }

}