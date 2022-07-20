import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ibloov/Constants/ColorList.dart';

import 'package:ibloov/Constants/ApiCalls.dart';
import 'package:ibloov/Constants/Methods.dart';
import 'package:ibloov/Widget/NoResult.dart';
import 'package:intl/intl.dart';

var height, width;

class EventList extends StatefulWidget {
  int index;
  var data;
  EventList(this.index, this.data);

  @override
  EventListState createState() => EventListState();
}

class EventListState extends State<EventList> {
  var _selectedValue, _selectedArray;
  List<DropdownMenuItem> _dropdownItems = [];
  List<String> image = [];
  List<bool> saved = [];

  List listOfValue = [
    {
      'key': 0,
      'text': 'Featured Events',
      'array': 'featuredEvents',
      'details': 'See all the featured events and shows in your location.',
      'image': 'assets/images/featured_events.jpg'
    },
    {
      'key': 1,
      'text': 'Trending Now',
      'array': 'trendingEvents',
      'details': 'See all the latest events and shows that are trending now!',
      'image': 'assets/images/trending_now.jpg'
    },
    {
      'key': 2,
      'text': 'Happening Near You',
      'array': 'happeningNearMe',
      'details': 'See all the latest events and shows happening near you.',
      'image': 'assets/images/happening_near_you.jpg'
    },
    {
      'key': 3,
      'text': 'Happening Today',
      'array': 'happeningToday',
      'details': 'See all the latest events and shows happening today, in your location.',
      'image': 'assets/images/happening_today.jpg'
    },
    {
      'key': 4,
      'text': 'Happening This Week',
      'array': 'happeningThisWeek',
      'details': 'See all the latest events and shows happening this week, in your location.',
      'image': 'assets/images/happening_this_week.jpg'
    },
    {
      'key': 5,
      'text': 'Upcoming',
      'array': 'upcoming',
      'details': 'See all the latest upcoming events in your location.',
      'image': 'assets/images/happening_this_week.jpg'
    },
    {
      'key': 6,
      'text': 'Recommended for you',
      'array': 'recommendedForYou',
      'details': 'See all the recommended events in your location.',
      'image': 'assets/images/happening_this_week.jpg'
    },
  ];

  @override
  void initState() {
    _dropdownItems = buildDropdownItems(listOfValue);
    _selectedValue = widget.index;

    _selectedArray = listOfValue.elementAt(_selectedValue)['array'];

    for (int i = 0; i < 15; i++) {
      image.add('assets/images/burna.png');
      saved.add(false);
    }

    super.initState();
  }

  List<DropdownMenuItem> buildDropdownItems(List _testList) {
    List<DropdownMenuItem> items = [];
    for (var i in _testList) {
      items.add(
        DropdownMenuItem(
          value: i['key'],
          child: Row(
            
            children: [
              Text(
                i['text'],
              ),
              
              Padding(
                padding: EdgeInsets.only(left:8.0),
                child: Icon(
                  Icons.keyboard_arrow_down_sharp,
                  color: ColorList.colorAccent,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return items;
  }

  onChangeDropdown(selectedValue) {
    print(selectedValue);
    setState(() {
      _selectedValue = selectedValue;
      widget.index = selectedValue;
      _selectedArray = listOfValue.elementAt(_selectedValue)['array'];
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
        /*body: Center(
        child: Text(
          widget.title,
          style: TextStyle(
              fontSize: 20.0,
              decoration: TextDecoration.none
          ),
        ),
      ),*/
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: height * 0.3,
              //color: ColorList.colorGrayText,
              /*decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(listOfValue.elementAt(_selectedValue)['image']),
                ),
              ),*/
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: height * 0.3,
                    child: Image.asset('assets/images/placeholder.png', fit: BoxFit.fill,),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: height * 0.3,
                    child: Image.asset(listOfValue.elementAt(_selectedValue)['image'], fit: BoxFit.fill,),
                  ),
                  Container(
                    height: height * 0.3,
                    color: ColorList.colorPrimary.withOpacity(0.5),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(height * 0.025, height * 0.06,
                            height * 0.025, height * 0.025),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Go Back",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontFamily: 'SF_Pro_700',
                                    fontSize: 15.0,
                                    color: ColorList.colorAccent,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Padding(
                          padding: EdgeInsets.only(
                              left: height * 0.025, right: height * 0.1),
                          child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                              //width: width,
                              child: DropdownBelow(
                                isDense: true,
                                itemWidth: width * 0.9,
                                itemTextstyle: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'SF_Pro_900',
                                  fontSize: 15.0,
                                ),
                                boxTextstyle: TextStyle(
                                  color: ColorList.colorAccent,
                                  fontFamily: 'SF_Pro_900',
                                  fontSize: 24.0,
                                ),
                                hint: Row(
                                  children: [
                                    Text(
                                      listOfValue.elementAt(widget.index)['text'],
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color: ColorList.colorAccent,
                                        fontFamily: 'SF_Pro_900',
                                        fontSize: 24.0,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left:8.0),
                                      child: Icon(
                                        Icons.keyboard_arrow_down_sharp,
                                        color: ColorList.colorAccent,
                                      ),
                                    ),
                                  ],
                                ),
                                value: _selectedValue,
                                items: _dropdownItems,
                                onChanged: onChangeDropdown,
                              ))),
                      SizedBox(
                        height: 10,
                      ),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                              height * 0.025, 0, height * 0.075, height * 0.025),
                          child: Text(
                            listOfValue.elementAt(widget.index)['details'],
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: 'SF_Pro_400',
                                fontSize: 13.0,
                                color: ColorList.colorAccent,
                                fontWeight: FontWeight.normal,
                                decoration: TextDecoration.none),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ),
            (widget.data[_selectedArray].length > 0)
                ? Container(
                    height: height * 0.7,
                    padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: (2 / 1.5),
                      crossAxisSpacing: 0.0,
                      mainAxisSpacing: 10.0,
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      children: List.generate(
                        widget.data[_selectedArray].length,
                            (item) {
                          return Card(
                              elevation: 0.0,
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Methods.openEventDetails(context, widget.data[_selectedArray][item]['_id']);
                                },
                                child: Container(
                                    padding: EdgeInsets.only(left: 10.0),
                                    margin: EdgeInsets.zero,
                                    color: ColorList.colorAccent,
                                    child: Container(
                                      padding: EdgeInsets.zero,
                                      child: ClipRRect(
                                        child: Stack(
                                          children: [
                                            // Container(
                                            //   child: Container(
                                            //       height: width * 0.5,
                                            //       color: ColorList.colorPrimary.withOpacity(0.5),
                                            //     ),
                                            //   decoration: BoxDecoration(
                                            //     image: DecorationImage(
                                            //         fit: BoxFit.cover,
                                            //         image: Methods.getSmallEventCardImage(widget.data[_selectedArray][item]['banner']),
                                            //     ),
                                            //   )
                                            // ),
                                            Methods.getSmallEventCardImage(
                                                widget.data[_selectedArray][item]['banner'] ?? "", height: width * 0.5),
                                            Container(
                                              child: Column(
                                                children: [
                                                  Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Padding(
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Card(
                                                                    elevation: 0.0,
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(10.0),
                                                                    ),
                                                                    child: Padding(
                                                                      child: Column(
                                                                        children: [
                                                                          Text(
                                                                            (widget.data[_selectedArray][item]['startTime'] == null)
                                                                                ? '01'
                                                                                : DateFormat('dd').format(DateTime.tryParse(widget.data[_selectedArray][item]['startTime'])),
                                                                            textAlign: TextAlign.center,
                                                                            style: TextStyle(
                                                                              fontFamily: 'SF_Pro_700',
                                                                              decoration: TextDecoration.none,
                                                                              fontSize: 14.0,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: (widget.data[_selectedArray][item]['startTime'] == null)
                                                                                  ? ColorList.colorAccent
                                                                                  : ColorList.colorPrimary,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            (widget.data[_selectedArray][item]['startTime'] == null)
                                                                                ? 'JAN'
                                                                                : DateFormat('MMM').format(DateTime.tryParse(widget.data[_selectedArray][item]['startTime'])).toUpperCase(),
                                                                            textAlign: TextAlign.center,
                                                                            style: TextStyle(
                                                                              fontFamily: 'SF_Pro_400',
                                                                              decoration: TextDecoration.none,
                                                                              fontSize: 9.0,
                                                                              fontWeight: FontWeight.normal,
                                                                              color: (widget.data[_selectedArray][item]['startTime'] == null)
                                                                                  ? ColorList.colorAccent
                                                                                  : ColorList.colorPrimary,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      padding: EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
                                                                    )
                                                                ),
                                                                /*SizedBox(
                                                                  width: (widget.data[_selectedArray][item]['noOfRegistrations'] > 99) ? 60 : 65,
                                                                ),
                                                                Card(
                                                                    color: ColorList.colorPrimary,
                                                                    elevation: 0.0,
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(25.0),
                                                                    ),
                                                                    child: Padding(
                                                                      child: Text(
                                                                        //DateFormat('dd').format(DateTime.tryParse(dataArray[item]['startTime'])),
                                                                        (widget.data[_selectedArray][item]['noOfRegistrations'] > 99) ? '99+' : '${widget.data[_selectedArray][item]['noOfRegistrations']}',
                                                                        textAlign: TextAlign.center,
                                                                        style: TextStyle(
                                                                          fontFamily: 'SF_Pro_700',
                                                                          decoration: TextDecoration.none,
                                                                          fontSize: 14.0,
                                                                          fontWeight: FontWeight.bold,
                                                                          color: ColorList.colorAccent,
                                                                        ),
                                                                      ),
                                                                      padding: EdgeInsets.all(8.0),
                                                                    )
                                                                ),*/
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 8,
                                                            ),
                                                            Row(
                                                              children: [

                                                                // for showing the red mark for Live Events

                                                                /*SizedBox(
                                                                  width: 2,
                                                                ),
                                                                Card(
                                                                  color: ColorList.colorRed,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(5.0),
                                                                  ),
                                                                  child: Container(
                                                                    height: 5,
                                                                    width: 5,
                                                                  ),
                                                                ),*/

                                                                Padding(
                                                                  padding: EdgeInsets.only(left: 5.0),
                                                                  child: Text(
                                                                    widget.data[_selectedArray][item]['category']['name'],
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                      fontFamily: 'SF_Pro_400',
                                                                      decoration: TextDecoration.none,
                                                                      fontSize: 9.0,
                                                                      fontWeight: FontWeight.normal,
                                                                      color: ColorList.colorAccent,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 1,
                                                            ),
                                                            SizedBox(
                                                              //width: 235,
                                                              child: Padding(
                                                                padding: EdgeInsets.only(left: 5.0, right: 5.0),
                                                                child: Text(
                                                                  widget.data[_selectedArray][item]['title'],
                                                                  textAlign: TextAlign.start,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: TextStyle(
                                                                    fontFamily: 'SF_Pro_700',
                                                                    decoration: TextDecoration.none,
                                                                    fontSize: 12.0,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: ColorList.colorAccent,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 1,
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets.only(left: 5.0),
                                                              child: Text(
                                                                '${widget.data[_selectedArray][item]['location'] != null
                                                                    ? '${(widget.data[_selectedArray][item]['location']['name'] != null)
                                                                    ? '${widget.data[_selectedArray][item]['location']['name']}, '
                                                                    : ''}${widget.data[_selectedArray][item]['location']['city']}'
                                                                    : ''}',
                                                                //textAlign: TextAlign.center,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(
                                                                  fontFamily: 'SF_Pro_400',
                                                                  decoration: TextDecoration.none,
                                                                  fontSize: 10.0,
                                                                  fontWeight: FontWeight.normal,
                                                                  color: ColorList.colorAccent,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 3,
                                                            ),
                                                            Row(
                                                              mainAxisSize: MainAxisSize.max,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets.only(left: 5.0),
                                                                  child: Text(
                                                                    Methods.getLowestPrice(widget.data[_selectedArray][item]['tickets'], true),
                                                                    style: TextStyle(
                                                                      fontFamily: 'SF_Pro_700',
                                                                      decoration: TextDecoration.none,
                                                                      fontSize: 12.0,
                                                                      fontWeight: FontWeight.bold,
                                                                      color: ColorList.colorAccent,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Spacer(),
                                                                InkWell(
                                                                  onTap: (){
                                                                    Methods.shareEvent(widget.data[_selectedArray][item]['link']);
                                                                  },
                                                                  child: Icon(Icons.share_outlined, size: 15, color: ColorList.colorAccent,),
                                                                ),
                                                                SizedBox(width: 8),
                                                                InkWell(
                                                                  onTap: (){

                                                                    setState(() {
                                                                      widget.data[_selectedArray][item]['userLiked'] = !widget.data[_selectedArray][item]['userLiked'];
                                                                    });

                                                                    ApiCalls.toggleLike(widget.data[_selectedArray][item]['_id'])
                                                                        .then((value){
                                                                      if(!value)
                                                                        setState(() {
                                                                          widget.data[_selectedArray][item]['userLiked'] = !widget.data[_selectedArray][item]['userLiked'];
                                                                        });
                                                                    });
                                                                  },
                                                                  child: Icon(
                                                                    (widget.data[_selectedArray][item]['userLiked']) ? Icons.favorite : Icons.favorite_outline,
                                                                    size: 15,
                                                                    color: (widget.data[_selectedArray][item]['userLiked']) ? ColorList.colorRed : ColorList.colorAccent,
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        padding: EdgeInsets.all(5.0),
                                                      )
                                                  )
                                                ],
                                              )
                                            )
                                          ],
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                    )
                                ),
                              )
                          );
                        },
                      ),
                    )
                  )
                : Container(
                    height: height * 0.6,
                    child: Center(
                      child: NoResult('No events found in this category!'),
                    ),
                  )
          ],
    ));
  }
}
