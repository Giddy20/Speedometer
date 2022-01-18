
import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';

import 'dart:math' as math;

import 'package:permission_handler/permission_handler.dart';

class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Position currentPosition;

  Geolocator geolocator = Geolocator();

  GeoCoordinates userCoords;

  PermissionStatus _permissionStatus;


  MapCamera mapCamera;

  HereMapController hereMapController = HereMapController(2);

  Rx<MapScheme> mapScheme = MapScheme.normalDay.obs;

  RxBool visible = false.obs;
  RxBool visible2 = true.obs;




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    locatePosition();
  }



  double _getRandom(double min, double max) {
    return min + math.Random().nextDouble() * (max - min);
  }


  // Update location and rotation of map. Update location of arrow.
  void _updateMapView(GeoCoordinates currentGeoCoordinates, double bearingInDegrees) {
    MapCameraOrientationUpdate orientation = MapCameraOrientationUpdate.withDefaults();
    orientation.bearing = bearingInDegrees;
    orientation.tilt = 180.0;
    hereMapController.camera.lookAtPointWithOrientationAndDistance(
      currentGeoCoordinates,
      orientation,
      100,
    );
    userCoords = currentGeoCoordinates;
  }

  void _addLocationIndicator(GeoCoordinates geoCoordinates, LocationIndicatorIndicatorStyle indicatorStyle) {
    LocationIndicator locationIndicator = LocationIndicator();
    locationIndicator.locationIndicatorStyle = indicatorStyle;

    // A LocationIndicator is intended to mark the user's current location,
    // including a bearing direction.
    // For testing purposes, we create a Location object. Usually, you may want to get this from
    // a GPS sensor instead.
    Location location = Location.withCoordinates(GeoCoordinates(userCoords.latitude, userCoords.longitude));
    location.time = DateTime.now();
    location.bearingInDegrees = _getRandom(0, 360);

    setState(() {
      locationIndicator.updateLocation(location);
    });


    // A LocationIndicator listens to the lifecycle of the map view,
    // therefore, for example, it will get destroyed when the map view gets destroyed.
    hereMapController.addLifecycleListener(locationIndicator);
  }


  void locatePosition() async{
    Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        currentPosition = position;
      });



      GeoCoordinates geoCoordinates = GeoCoordinates(position.latitude, position.longitude);

      setState(() {
        userCoords = geoCoordinates;
        print(userCoords.longitude);
        hereMapController.camera.lookAtPointWithDistance(GeoCoordinates(userCoords.latitude, userCoords.longitude), 1000);
        _updateMapView(userCoords, 90);
      });

      //hereMapController.camera.lookAtPointWithDistance(GeoCoordinates(userCoords.latitude, userCoords.longitude), 10);
      // _location = Location.withCoordinates(geoCoordinates);
      //
      // locIndicator(_location);

    }).catchError((e) {
      print(e);
    });
  }


  Align button(String buttonLabel, Function callbackFunction) {
    return Align(
      alignment: Alignment.topCenter,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.lightBlueAccent,
          onPrimary: Colors.white,
        ),
        onPressed: () => changeScheme(),
        child: Text(buttonLabel, style: TextStyle(fontSize: 20)),
      ),
    );
  }


  void _enableAllButtonClicked() {
    hereMapController.camera.lookAtPointWithDistance(GeoCoordinates(userCoords.latitude, userCoords.longitude), 10);
  }


  void changeScheme(){
    setState(() {
      mapScheme = MapScheme.normalNight.obs;
    });
  }




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          HereMap(onMapCreated: _onMapCreated),

          Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: 0.30,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [


                  Obx(() => Visibility(
                      visible: visible.value,
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFF36454f),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Map view',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),),

                                IconButton(
                                    onPressed: (){
                                      visible2.value = true;
                                      visible.value = false;
                                    },
                                    icon: Icon(Icons.close,
                                      color: Colors.white,)),
                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 80,
                                    margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Image.asset('images/normal.jpeg', fit: BoxFit.contain,),
                                  ),
                                ),

                                Expanded(
                                  child: InkWell(
                                    onTap: (){
                                      setState(() {
                                        mapScheme.value = MapScheme.satellite;
                                      });
                                    },
                                    child: Container(
                                      height: 80,
                                      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                      child: Image.asset('images/sat.jpeg', fit: BoxFit.contain,),
                                    ),
                                  ),
                                ),


                              ],
                            ),

                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //   children: [
                            //     Text('Default',
                            //       style: TextStyle(
                            //           color: Colors.white,
                            //           fontSize: 12,
                            //           fontWeight: FontWeight.bold,
                            //       ),),
                            //
                            //     Text('Satellite',
                            //       style: TextStyle(
                            //           color: Colors.white,
                            //           fontSize: 12,
                            //           fontWeight: FontWeight.bold
                            //       ),),
                            //   ],
                            // ),

                          ],
                        ),
                      )

                  ),
                  ),



                  Obx(()=> Visibility(
                    visible: visible2.value,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: (){
                          visible.value = true;
                          visible2.value = false;
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Color(0xFF36454f),
                              shape: BoxShape.circle
                          ),
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 0),
                          child: const Icon(Icons.layers,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        height: 100,
                        width: double.infinity,
                        decoration:const BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                          color: Color(0xFF36454f),
                        ),
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: Column(
                            children: [
                              TextField(
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(30)),
                                    ),
                                    prefixIcon: Icon(Icons.search,
                                      color: Colors.white,),
                                    hintText: 'Where to?',
                                    hintStyle: TextStyle(
                                        color: Colors.white
                                    )
                                ),
                                onChanged: (text) {
                                  setState(() {
                                    //you can access nameController in its scope to get
                                    // the value of text entered as shown below
                                    //UserName = nameController.text;
                                  });
                                },
                              )
                            ],
                          ),
                        )
                    ),
                  ),
                ],
              ),
            ),
          )

        ],
      ),
    )
    ;
  }

  void _onMapCreated(HereMapController hereMapController) {
    hereMapController.mapScene.loadSceneForMapScheme(mapScheme.value, (MapError error) {
      if (error != null) {
        print('Map scene not loaded. MapError: ${error.toString()}');
        return;
      }


      locatePosition();


      hereMapController.camera.lookAtPointWithGeoOrientationAndDistance(GeoCoordinates(userCoords.latitude, userCoords.longitude), GeoOrientationUpdate(90, 0), 5000);
  }

    );
  }

}
