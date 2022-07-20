import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:ibloov/Constants/ColorList.dart';
import 'package:ibloov/Constants/Methods.dart';
import 'package:uuid/uuid.dart';

//import 'package:ibloov/Widget/HomeWidget.dart';

var height, width;
LatLng _center;
final Set<Marker> _markers = {};
LatLng _currentMapPosition = _center;

class SelectLocation extends StatefulWidget{
  Position currentPosition;
  SelectLocation(this.currentPosition);


  @override
  SelectLocationState createState() => SelectLocationState();
}

class SelectLocationState extends State<SelectLocation>{

  Position currentPosition;
  String currentAddress = 'Fetching location...';
  BitmapDescriptor icon;
  final locationController = TextEditingController();
  Completer<GoogleMapController> mapController = Completer();

  var uuid = new Uuid();
  String _sessionToken;
  List<dynamic>_placeList = [];
  bool tapped = false;

  @override
  void initState() {
    super.initState();
    try {
      // if(widget.currentPosition != null) {
      //   getAddressFromLatLng(widget.currentPosition.latitude, widget.currentPosition.longitude);
      // }

      getIcons();

      // locationController.addListener(() {
      //   _onChanged();
      // });

      _center = LatLng(widget.currentPosition?.latitude, widget.currentPosition?.longitude);
      currentPosition = widget.currentPosition;
    } catch(e) {
      debugPrint(e.toString());
    }
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    getCurrentLocation();
  }

  getCurrentLocation() {
    Methods.determinePosition().then((Position position) {
      setState(() {
        currentPosition = position;
      });

      getAddressFromLatLng(currentPosition.latitude, currentPosition.longitude);
      onPlaceSelected();
    }).catchError((e) {
      print(e);
    });
  }

  void _onChanged() {
    if(tapped){
      if (_sessionToken == null) {
        setState(() {
          _sessionToken = uuid.v4();
        });
      }
      Methods.getSuggestion(
          locationController.text,
          _sessionToken
      ).then((value) {
        setState(() {
          _placeList = value;
        });
      });
    }
  }

  getAddressFromLatLng(latitude, longitude) async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(latitude, longitude);

      Placemark place = p[0];

      // setState(() {
        var placeData = json.decode(json.encode(place.toJson()));
        String thoroughfare = placeData["thoroughfare"].length > 0 ? '${placeData["thoroughfare"]}, ' : "";
        String subLocality = placeData["subLocality"].length > 0 ? '${placeData["subLocality"]}, ' : "";
        String locality = placeData["locality"].length > 0 ? '${placeData["locality"]}, ' : "";
        String country = placeData["country"].length > 0 ? placeData["country"] : "";
        //currentAddress = '${placeData["thoroughfare"]}, ${placeData["subLocality"]}, ${placeData["locality"]}, ${placeData["country"]}';
        currentAddress = '$thoroughfare$subLocality$locality$country';
      // });
    } catch (e) {
      print(e);
    }
  }

  getIcons() async {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(50, 50)),
        'assets/images/my_location.png')
        .then((d) {
      icon = d;
    });
  }

  void _onCameraMove(CameraPosition position) {
    _currentMapPosition = position.target;

    currentPosition = new Position(latitude: position.target.latitude, longitude: position.target.longitude);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController.complete(controller);

    setState(() {
      _markers.add(
          Marker(
            onTap: () {
              print('Tapped');
            },
            draggable: true,
            icon: icon,
            markerId: MarkerId('Me'),
            anchor: const Offset(0.5, 0.5),
            position: _center,
            onDragEnd: ((newPosition) {
              setState(() {
                _center = newPosition;
                getAddressFromLatLng(_center.latitude, _center.longitude);
              });
            })
          )
      );
    });
  }

  Future<void> onPlaceSelected() async {
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(currentPosition.latitude, currentPosition.longitude),
                zoom: 15
            )
        )
    );
    print('Latitude: ${currentPosition.latitude}');
    print('Longitude: ${currentPosition.longitude}');
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    locationController.addListener(() {
      _onChanged();
    });

    return Scaffold(
      body: WillPopScope(
        child: Stack(
          children: [
            Stack(
              children: [                
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 15.0,
                  ),
                  zoomGesturesEnabled: true,
                  compassEnabled: true,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  onMapCreated: _onMapCreated,
                  onCameraMove: _onCameraMove,
                  onCameraIdle: () async {
                    // you can use the captured location here. when the user stops moving the map.
                    getAddressFromLatLng(_currentMapPosition.latitude, _currentMapPosition.longitude);
                  },
                ),
                Align(
                  alignment: Alignment.center,
                  child: Image.asset('assets/images/my_location.png', width: width * 0.075, height: width * 0.075),
                ),
              ]
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(width * 0.05, height * 0.06, width * 0.05, 0.0),
                  child: Card(
                    elevation: 10.0,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    child: TextFormField(
                      onTap: (){
                        setState(() {
                          if(!tapped){
                            tapped = true;
                          }
                        });
                      },
                      controller: locationController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.search,
                      cursorColor: ColorList.colorPrimary,
                      maxLines: 1,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search for location',
                        hintStyle: TextStyle(color: ColorList.colorGray, fontSize: 14.0),
                        alignLabelWithHint: true,
                        prefixIcon: Icon(
                            Icons.search,
                            color: ColorList.colorGray
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.close,
                            color: ColorList.colorGray,
                          ),
                          color: ColorList.colorPrimary,
                          onPressed: (){
                            locationController.text = '';
                            _placeList.clear();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                (tapped && _placeList.length>0)
                    ? Container(
                        margin: EdgeInsets.symmetric(horizontal: width * 0.05),
                        decoration: new BoxDecoration(
                          color: ColorList.colorAccent,
                          border: Border.all(color: Colors.black, width: 1.0),
                        ),
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _placeList.length + 1,
                          itemBuilder: (context, index) {
                            return (index == _placeList.length)
                                ? Column(
                                    children: [
                                      Divider(color: Colors.black, height: 2.0,),
                                      Container(
                                        padding: EdgeInsets.all(10.0),
                                        alignment: Alignment.center,
                                        child: InkWell(
                                          onTap: (){
                                            setState(() {
                                              getCurrentLocation();
                                              tapped = false;
                                              locationController.text = '';
                                              _placeList.clear();
                                              SystemChannels.textInput.invokeMethod('TextInput.hide');
                                            });
                                          },
                                          child: Text(
                                            'Use Current Location',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: ColorList.colorBlue
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8.0),
                                        alignment: Alignment.center,
                                        child: InkWell(
                                            onTap: (){
                                              Methods.getPlaceDetails(_placeList[index]["place_id"])
                                                  .then((value) {
                                                setState(() {
                                                  currentAddress = locationController.text = _placeList[index]["description"];
                                                  currentPosition = value;
                                                  print('Selected: $value');
                                                  locationController.selection = TextSelection.fromPosition(TextPosition(offset: locationController.text.length));
                                                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                                                  _placeList = [];
                                                  tapped = false;
                                                  onPlaceSelected();
                                                });
                                              });
                                            },
                                            child: Text(
                                              _placeList[index]["description"],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: ColorList.colorPrimary
                                              ),
                                            )
                                        ),
                                      ),
                                      Divider(color: Colors.black, height: 1.0,)
                                    ],
                                  );
                          },
                        ),
                      )
                    : Container()
              ],
            )
          ],
        ),
        onWillPop: (){
          Navigator.pop(context, widget.currentPosition);
          return null;
        },
      ),
      bottomSheet: Container(
        height: height * 0.15,
        width: width,
        padding: EdgeInsets.all(width * 0.02),
        alignment: Alignment.bottomRight,
        decoration: BoxDecoration(
          color: ColorList.colorAccent.withOpacity(0.75),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: width * 0.9,
              child: Row(
                children: [
                  Container(
                    height: height * 0.05,
                    alignment: Alignment.center,
                    child: Text(
                      "You’re currently here:",
                      style: TextStyle(
                          fontFamily: 'SF_Pro_600',
                          color: ColorList.colorGrayHint,
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.03),
                  Expanded(
                    child: Text(
                      currentAddress,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'SF_Pro_600',
                          color: ColorList.colorPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                      ),
                    ),
                  )

                ],
              ),
              alignment: Alignment.center,
            ),
            Spacer(),
            MaterialButton(
              color: ColorList.colorSplashBG,
              minWidth: width,
              height: height * 0.07,
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0),
              ),
              elevation: 5.0,
              onPressed: (){
                Navigator.pop(context, currentPosition);
              },
              child: Text(
                'Save Location',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'SF_Pro_600',
                  decoration: TextDecoration.none,
                  fontSize: 15.0,
                  fontWeight: FontWeight.normal,
                  color: ColorList.colorAccent,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}