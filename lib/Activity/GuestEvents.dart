import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:ibloov/Constants/ColorList.dart';
import 'package:ibloov/Constants/Methods.dart';

import 'Onboarding.dart';

PanelController sliderController = new PanelController();
bool isExpanded = false;
double width, height;
List<String> image = new List();
LatLng _center;
GoogleMapController mapController;
final Set<Marker> _markers = {};
LatLng _currentMapPosition = _center;

List<double> lat = new List(), lng = new List();

class GuestEvents extends StatefulWidget{

  final Position currentPosition;

  GuestEvents(this.currentPosition);

  @override
  GuestEventsState createState() => GuestEventsState();

}

class GuestEventsState extends State<GuestEvents>{

  BitmapDescriptor icon;

  @override
  void initState() {
    super.initState();
    getIcons();
    image.add('assets/images/burna.png');
    image.add('assets/images/burna.png');
    image.add('assets/images/burna.png');
    image.add('assets/images/burna.png');

    print(widget.currentPosition.latitude);
    print(widget.currentPosition.longitude);

    _center = LatLng(widget.currentPosition.latitude, widget.currentPosition.longitude);

    addMarkers();

  }

  getIcons() async {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(50, 50)),
        'assets/images/marker.png')
        .then((d) {
      icon = d;
    });
  }

  void _onCameraMove(CameraPosition position) {
    _currentMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    setState(() {
      _markers.add(Marker(
        markerId: MarkerId('Me'),
        draggable: false,
        icon: icon,
        anchor: const Offset(0.5, 0.5),
        position: _center,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {

    Set<Circle> circles = Set.from(
        [
          Circle(
            circleId: CircleId('3'),
            center: _center,
            radius: 1000,
            strokeWidth: 1,
            fillColor: ColorList.colorCorousalIndicatorActive.withOpacity(0.1),
            strokeColor: ColorList.colorSplashBG,
          ),
          Circle(
            circleId: CircleId('2'),
            center: _center,
            radius: 500,
            strokeWidth: 1,
            fillColor: ColorList.colorGenderBackground.withOpacity(0.1),
            strokeColor: ColorList.colorPrimary,
          ),
          Circle(
            circleId: CircleId('1'),
            center: _center,
            radius: 200,
            strokeWidth: 1,
            fillColor: ColorList.colorGrayBorder.withOpacity(0.1),
            strokeColor: ColorList.colorGrayHint,
          ),
        ]
    );

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ColorList.colorAccent,
      appBar:AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: true,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child:Text(
                    "Back",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: 'SF_Pro_700',
                        fontSize: 17.0,
                        color: ColorList.colorBack,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none
                    ),
                  ),
                ),
              ),
              //Spacer(),
              Expanded(
                  child: Card(
                    elevation: 0.0,
                    child: Container(
                        //width: width * 0.75,
                        color: ColorList.colorGrayBorder,
                        child: TextFormField(
                          onTap: (){
                          },
                          /*controller: dobController,
                        focusNode: dobFocusNode,*/
                          enableInteractiveSelection: false,
                          textInputAction: TextInputAction.done,
                          cursorColor: ColorList.colorPrimary,
                          maxLines: 1,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search for Events',
                              hintStyle: TextStyle(color: ColorList.colorGray),
                              //alignLabelWithHint: true,
                              prefixIcon: Icon(
                                  Icons.search,
                                  color: ColorList.colorGray
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.tune,
                                  color: ColorList.colorGray,
                                ),
                                color: ColorList.colorPrimary,
                                onPressed: (){
                                  FocusScope.of(context).requestFocus(new FocusNode());
                                  Methods.showToast('Filter');
                                },
                              )
                          ),
                        )
                    ),
                  ),
              )
            ],
          )
      ),
      body: SlidingUpPanel(
        controller: sliderController,
        parallaxEnabled: false,
        minHeight: 60.0,
        maxHeight: 235.0,
        body: WillPopScope(
          child: Column(
            children: [
              Padding(
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/near_event.png',
                      width: 25.0,
                      height: 25.0,
                    ),
                    Container(
                      width: 15.0,
                    ),
                    Text(
                      'Events Near You',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'SF_Pro_700',
                        decoration: TextDecoration.none,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: ColorList.colorPrimary,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                padding: EdgeInsets.all(25.0),
              ),
              Container(
                height: height * 0.75,
                child: GoogleMap(
                  markers: _markers,
                  onCameraMove: _onCameraMove,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 15.0,
                  ),
                  mapType: MapType.normal,
                  circles: circles,
                ),
              )
            ],
          ),
          onWillPop: (){
            Navigator.pop(context);
            return null;
          },
        ),
        panel: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: 35.0,
                width: width,
                child: Center(
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          isExpanded ? sliderController.close() : sliderController.open();
                          isExpanded = !isExpanded;
                        });
                      },
                      child: Image.asset(isExpanded ? 'assets/images/expanded.png': 'assets/images/hidden.png', width: 30.0, height: 25.0,),
                    )
                ),
              ),
              Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(
                      flex: 10,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                        child: SizedBox(
                          height: 200,
                          child: ListView.builder(
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: image.length,
                            itemBuilder: (BuildContext context, int item) =>
                                Card(
                                    elevation: 0.0,
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        openDetails(item);
                                      },
                                      child: Container(
                                        /*constraints: BoxConstraints.expand(
                                          width: width * 0.4, height: 200,
                                      ),*/
                                          margin: EdgeInsets.zero,
                                          color: ColorList.colorAccent,
                                          child: Container(
                                            padding: EdgeInsets.all(5.0),
                                            decoration: const BoxDecoration(
                                              color: ColorList.colorAccent,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                topRight: Radius.circular(10.0),
                                              ),
                                            ),
                                            child: ClipRRect(
                                              child: Stack(
                                                children: [
                                                  Image.asset(image[item], fit: BoxFit.fitWidth,),
                                                  Container(
                                                      height: 180,
                                                      //width: width * 0.3,
                                                      child: Column(
                                                        children: [
                                                          Align(
                                                              alignment: Alignment.center,
                                                              child: Padding(
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                                                '01',
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(
                                                                                  fontFamily: 'SF_Pro_700',
                                                                                  decoration: TextDecoration.none,
                                                                                  fontSize: 23.0,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: ColorList.colorPrimary,
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                'JAN',
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(
                                                                                  fontFamily: 'SF_Pro_400',
                                                                                  decoration: TextDecoration.none,
                                                                                  fontSize: 16.0,
                                                                                  fontWeight: FontWeight.normal,
                                                                                  color: ColorList.colorPrimary,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                                                                        )
                                                                    ),
                                                                    SizedBox(
                                                                      height: 15,
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.only(left: 5.0),
                                                                      child: Text(
                                                                        'Concert',
                                                                        textAlign: TextAlign.center,
                                                                        style: TextStyle(
                                                                          fontFamily: 'SF_Pro_400',
                                                                          decoration: TextDecoration.none,
                                                                          fontSize: 13.0,
                                                                          fontWeight: FontWeight.normal,
                                                                          color: ColorList.colorAccent,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 1,
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.only(left: 5.0),
                                                                      child: Text(
                                                                        'Burna Live 3',
                                                                        textAlign: TextAlign.center,
                                                                        style: TextStyle(
                                                                          fontFamily: 'SF_Pro_700',
                                                                          decoration: TextDecoration.none,
                                                                          fontSize: 22.0,
                                                                          fontWeight: FontWeight.bold,
                                                                          color: ColorList.colorAccent,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 4,
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.only(left: 5.0),
                                                                      child: Text(
                                                                        '\$ 20',
                                                                        style: TextStyle(
                                                                          fontFamily: 'SF_Pro_700',
                                                                          decoration: TextDecoration.none,
                                                                          fontSize: 16.0,
                                                                          fontWeight: FontWeight.bold,
                                                                          color: ColorList.colorAccent,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                padding: EdgeInsets.fromLTRB(5.0, 10.0, 15.0, 10.0),
                                                              )
                                                          )
                                                        ],
                                                      )
                                                  )
                                                ],
                                              ),
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0),),
                                            ),
                                          )/*CachedNetworkImage(
                                        imageUrl: image[item],
                                        placeholder: (context, url) => Center(
                                          child: Container(
                                            child: CircularProgressIndicator(
                                              valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                ColorList.colorMenuItemChecked,
                                              ),
                                              strokeWidth: 2,
                                            ),
                                            height: 35,
                                            width: 35,
                                          ),
                                        ),
                                        imageBuilder: (context, imageProvider) =>
                                            Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.fitWidth,
                                                ),
                                              ),
                                            ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),*/
                                      ),
                                    )
                                ),
                          ),
                        ),
                      ))
                ],
              ),
            ],
          ),
        ),
        onPanelOpened: (){
          setState(() {
            isExpanded = true;
          });
        },
        onPanelClosed: (){
          setState(() {
            isExpanded = false;
          });
        },
      ),
    );
  }

  void addMarkers() {

    lat.add(widget.currentPosition.latitude - 0.005);
    lat.add(widget.currentPosition.latitude + 0.005);
    lat.add(widget.currentPosition.latitude + 0.005);
    lat.add(widget.currentPosition.latitude - 0.005);

    lng.add(widget.currentPosition.longitude - 0.005);
    lng.add(widget.currentPosition.longitude + 0.005);
    lng.add(widget.currentPosition.longitude - 0.005);
    lng.add(widget.currentPosition.longitude + 0.005);

    for(int i=0; i<lat.length; i++){
      _markers.add(
          Marker(
              markerId: MarkerId('$i'),
              position: LatLng(lat.elementAt(i), lng.elementAt(i)),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
              onTap: () {
                openDetails(i);
              },
              consumeTapEvents: true
          )
      );
      var lt = lat.elementAt(i);
      var ln = lng.elementAt(i);
      print('$i: $lt, $ln');
    }
  }

  Future openDetails(int i) {
    Methods.showToast('Clicked $i');
    return showStickyFlexibleBottomSheet(
      minHeight: 0,
      initHeight: 0.36,
      maxHeight: 0.7,
      headerHeight: width * 0.93,
      context: context,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      headerBuilder: (BuildContext context, double offset) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Swipe up for more\nSwipe down to close',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'SF_Pro_700',
                  decoration: TextDecoration.none,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: ColorList.colorAccent,
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.all(10.0),
                decoration: const BoxDecoration(
                  color: ColorList.colorAccent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: ClipRRect(
                  child: Stack(
                    children: [
                      Image.asset(image[i], fit: BoxFit.fitWidth,),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Card(
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              child: Column(
                                children: [
                                  Text(
                                    '01',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'SF_Pro_700',
                                      decoration: TextDecoration.none,
                                      fontSize: 23.0,
                                      fontWeight: FontWeight.bold,
                                      color: ColorList.colorPrimary,
                                    ),
                                  ),
                                  Text(
                                    'JAN',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'SF_Pro_400',
                                      decoration: TextDecoration.none,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.normal,
                                      color: ColorList.colorPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                            )
                        ),
                      ),
                      Container(
                          height: width * 0.6,
                          //width: width * 0.3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Spacer(),
                              Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: ColorList.colorRed,
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              margin: EdgeInsets.fromLTRB(0.0, 5.0, 5.0, 5.0),
                                              height: 8.0,
                                              width: 8.0,
                                            ),
                                            Text(
                                              'Concert',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: 'SF_Pro_400',
                                                decoration: TextDecoration.none,
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.normal,
                                                color: ColorList.colorAccent,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Burna Live 3',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: 'SF_Pro_700',
                                                decoration: TextDecoration.none,
                                                fontSize: 22.0,
                                                fontWeight: FontWeight.bold,
                                                color: ColorList.colorAccent,
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.all(5.0),
                                              height: 8.0,
                                              width: 8.0,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                                  )
                              )
                            ],
                          )
                      )
                    ],
                  ),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0),),
                )
            )
          ],
        );
      },
      bodyBuilder: (BuildContext context, double offset) {
        return SliverChildListDelegate(
          <Widget>[
            Container(
              color: ColorList.colorAccent,
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            '',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: 'SF_Pro_400',
                              decoration: TextDecoration.none,
                              fontSize: 5.0,
                              fontWeight: FontWeight.normal,
                              color: ColorList.colorPrimary,
                            ),
                          ),
                          Row(
                            children: [
                              Image.asset('assets/images/time_logo.png', height: 25, width: 25,),
                              Container(width: 10,),
                              Text(
                                '10am to 12pm',
                                style: TextStyle(
                                  fontFamily: 'SF_Pro_700',
                                  decoration: TextDecoration.none,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: ColorList.colorPrimary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'FEE',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: 'SF_Pro_400',
                                  decoration: TextDecoration.none,
                                  fontSize: 8.0,
                                  fontWeight: FontWeight.normal,
                                  color: ColorList.colorPrimary,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '\$ 20',
                            style: TextStyle(
                              fontFamily: 'SF_Pro_700',
                              decoration: TextDecoration.none,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: ColorList.colorPrimary,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        children: [
                          Text(
                            'AGE RATING',
                            style: TextStyle(
                              fontFamily: 'SF_Pro_400',
                              decoration: TextDecoration.none,
                              fontSize: 8.0,
                              fontWeight: FontWeight.normal,
                              color: ColorList.colorPrimary,
                            ),
                          ),
                          Text(
                            'NC17',
                            style: TextStyle(
                              fontFamily: 'SF_Pro_700',
                              decoration: TextDecoration.none,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: ColorList.colorPrimary,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Container(
                    height: width * 0.01,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      '‘Burna Live’ will mark a direct follow-up to the singer’s highly publicized concert at Brixton Academy, O2 Arena in London, which was entirely sold out and was met with overwhelming positive reception from attendees and the media.',
                      style: TextStyle(
                        fontFamily: 'SF_Pro_400',
                        decoration: TextDecoration.none,
                        fontSize: 13.0,
                        fontWeight: FontWeight.normal,
                        color: ColorList.colorPrimary,
                      ),
                    ),
                  ),
                  Container(
                    height: width * 0.05,
                  ),
                  MaterialButton(
                    minWidth: width * 0.9,
                    height: 50.0,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    onPressed: () {
                      Methods.showToast('Get ticket for this event!');
                      /*Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ),
                      );*/
                    },
                    color: ColorList.colorPrimary,
                    child: Text(
                      'Get Ticket',
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
                ],
              ),
            )
          ],
        );
      },
      anchors: [0, 0, 0],
    );
  }
}