import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:users_app/assistants/assistant_methods.dart';
import 'package:users_app/authentication/login_screen.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/infoHandler/app_info.dart';
import 'package:users_app/mainScreens/search_places_screen.dart';
import 'package:users_app/widgets/my_drawer.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController tolocationTextEditingController =
      TextEditingController();
  TextEditingController fromlocationTextEditingController =
      TextEditingController();

  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;
  // final PanelController panelController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  double searchLocationContainerHeight = 400;

  Position? userCurrentPosition;
  var geolocator = Geolocator();

  LocationPermission? _locationPermission;
  double bottomPaddingofMap = 0;

  List<LatLng> pLineCoOrdinatesList = [];
  Set<Polyline> polyLineSet = {};

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  String userName = "Name";
  String userEmail = "Email";

  bool openNavigationDrawer = true;

  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
  }

  locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition =
        LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress =
        await AssistantMethods.searchAddressForGoegraphicCoOrdinates(
            userCurrentPosition!, context);

    userName = userModelCurrentInfo!.name!;
    userEmail = userModelCurrentInfo!.email!;
  }

  @override
  void initState() {
    super.initState();
    AssistantMethods.readCurrentOnlineUserInfo();
    checkIfLocationPermissionAllowed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: sKey,
      drawer: Container(
        width: 270,
        child: MyDrawer(
          name: userName,
          email: userEmail,
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: const EdgeInsets.only(bottom: 240),
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            initialCameraPosition: _kGooglePlex,
            polylines: polyLineSet,
            markers: markersSet,
            circles: circlesSet,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              locateUserPosition();

              setState(() {
                bottomPaddingofMap = 120;
              });
            },
          ),

          //custom hamburger button
          Positioned(
            top: 40,
            left: 10,
            child: GestureDetector(
              onTap: () {
                // sKey.currentState!.openDrawer();
                // openNavigationDrawer;
                if (openNavigationDrawer) {
                  sKey.currentState!.openDrawer();
                } else {
                  //refresh the app programatically
                  SystemNavigator.pop();
                  // polyLineSet.remove(polyLineSet);
                  // polyLineSet.clear();
                  // polyLineSet.remove(polyLineSet);
                }
              },
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 5,
                        color: Color.fromARGB(19, 0, 0, 0),
                        spreadRadius: 6)
                  ],
                ),
                child: CircleAvatar(
                  maxRadius: 25,
                  backgroundColor: Colors.white,
                  child: Icon(
                    openNavigationDrawer ? Icons.menu : Icons.close,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),

          // UI for searching location
          Positioned(
              height: 230,
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedSize(
                curve: Curves.easeIn,
                duration: Duration(milliseconds: 120),
                child: Container(
                  height: searchLocationContainerHeight,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 20,
                    ),
                    child: Column(
                      //From Location
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.indigoAccent,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "From",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                //go to search places screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (c) => SearchPlacesScreen()),
                                );
                              },
                              child: Container(
                                width: 350,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    Provider.of<AppInfo>(context)
                                                .userPickUpLocation !=
                                            null
                                        ? (Provider.of<AppInfo>(context)
                                                    .userPickUpLocation!
                                                    .locationName!)
                                                .substring(0, 24) +
                                            "..."
                                        : "not getting address",
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 12,
                        ),

                        //To location
                        GestureDetector(
                          onTap: () async {
                            //go to search places screen
                            var responseFromSearchScreen = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => SearchPlacesScreen()));

                            if (responseFromSearchScreen == "obtainedDropoff") {
                              setState(() {
                                openNavigationDrawer = false;
                              });

                              //draw routes - draw polyline
                              await drawPolyLineFromSourceToDestination();
                            }
                          },
                          child: Container(
                            width: 350,
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                Provider.of<AppInfo>(context)
                                            .userDropOffLocation !=
                                        null
                                    ? Provider.of<AppInfo>(context)
                                        .userDropOffLocation!
                                        .locationName!
                                    : "Where to?",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  // fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // from location
                        // Row(
                        //   children: [
                        //     const Icon(
                        //       Icons.add_location_alt_outlined,
                        //       color: Colors.grey,
                        //     ),
                        //     const SizedBox(
                        //       width: 12,
                        //     ),
                        //     Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         const Text(
                        //           "From",
                        //           style: TextStyle(
                        //               color: Colors.grey, fontSize: 12),
                        //         ),
                        //         Text(
                        //           Provider.of<AppInfo>(context)
                        //                       .userPickUpLocation !=
                        //                   null
                        //               ? (Provider.of<AppInfo>(context)
                        //                           .userPickUpLocation!
                        //                           .locationName!)
                        //                       .substring(0, 24) +
                        //                   "..."
                        //               : "not getting address",
                        //           style: TextStyle(
                        //               color: Colors.grey, fontSize: 14),
                        //         ),
                        //       ],
                        //     ),
                        //   ],
                        // ),

                        // const SizedBox(
                        //   height: 10,
                        // ),
                        // const Divider(
                        //   height: 1,
                        //   thickness: 1,
                        //   color: Colors.grey,
                        // ),
                        // const SizedBox(
                        //   height: 16,
                        // ),

                        //to location
                        // GestureDetector(
                        //   onTap: () {
                        //     //go to search places screen
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (c) => SearchPlacesScreen()));
                        //   },
                        //   child: Row(
                        //     children: [
                        //       const Icon(
                        //         Icons.add_location_alt_outlined,
                        //         color: Colors.grey,
                        //       ),
                        //       const SizedBox(
                        //         width: 12,
                        //       ),
                        //       Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           const Text(
                        //             "To",
                        //             style: TextStyle(
                        //                 color: Colors.grey, fontSize: 12),
                        //           ),
                        //           Text(
                        //             "User dropoff location",
                        //             style: TextStyle(
                        //                 color: Colors.grey, fontSize: 14),
                        //           ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),

                        // const SizedBox(
                        //   height: 10,
                        // ),
                        // const Divider(
                        //   height: 1,
                        //   thickness: 1,
                        //   color: Colors.grey,
                        // ),
                        // const SizedBox(
                        //   height: 16,
                        // ),

                        const SizedBox(
                          height: 15,
                        ),

                        SizedBox(
                          width: 350,
                          height: 40,
                          child: ElevatedButton(
                            child: const Text("Request Ride"),
                            onPressed: () {}, //
                            style: ElevatedButton.styleFrom(
                                primary: Colors.lightBlueAccent),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )),

          // SlidingUpPanel(
          //   // maxHeight: MediaQuery.of(context).size.height,
          //   // minHeight: MediaQuery.of(context).size.height * 0.32,
          //   panel: Padding(
          //     padding: const EdgeInsets.only(
          //       top: 10,
          //     ),
          //     child: Column(
          //       children: [
          //         buildDragHandle(),
          //         SizedBox(
          //           height: 10,
          //         ),
          //         // SizedBox(
          //         //   width: 320,
          //         //   // height: 50,
          //         //   child: TextFormField(
          //         //     controller: fromlocationTextEditingController,
          //         //     keyboardType: TextInputType.text,
          //         //     style: const TextStyle(color: Colors.black, fontSize: 17),
          //         //     decoration: InputDecoration(
          //         //       // labelText: "From?",
          //         //       hintText:
          //         //           Provider.of<AppInfo>(context).userPickUpLocation !=
          //         //                   null
          //         //               ? (Provider.of<AppInfo>(context)
          //         //                   .userPickUpLocation!
          //         //                   .locationName!)
          //         //               : "not getting address",
          //         //       isDense: true,
          //         //       contentPadding: const EdgeInsets.symmetric(
          //         //         horizontal: 10,
          //         //         vertical: 10,
          //         //       ),
          //         //       enabledBorder: OutlineInputBorder(
          //         //         borderSide: const BorderSide(color: Colors.grey),
          //         //         borderRadius: BorderRadius.circular(5),
          //         //       ),
          //         //       focusedBorder: OutlineInputBorder(
          //         //         borderSide: const BorderSide(color: Colors.blue),
          //         //         borderRadius: BorderRadius.circular(5.0),
          //         //       ),
          //         //       labelStyle: const TextStyle(
          //         //         color: Colors.grey,
          //         //         fontSize: 17,
          //         //       ),
          //         //     ),
          //         //   ),
          //         // ),
          //         const SizedBox(
          //           height: 20,
          //         ),
          //         SizedBox(
          //           width: 320,
          //           child: TextFormField(
          //             controller: tolocationTextEditingController,
          //             keyboardType: TextInputType.text,
          //             style: const TextStyle(color: Colors.black, fontSize: 17),
          //             decoration: InputDecoration(
          //               hintText: "Where To?",
          //               isDense: true,
          //               contentPadding: const EdgeInsets.symmetric(
          //                 horizontal: 10,
          //                 vertical: 10,
          //               ),
          //               enabledBorder: OutlineInputBorder(
          //                 borderSide: const BorderSide(color: Colors.grey),
          //                 borderRadius: BorderRadius.circular(5),
          //               ),
          //               focusedBorder: OutlineInputBorder(
          //                 borderSide: const BorderSide(color: Colors.blue),
          //                 borderRadius: BorderRadius.circular(5.0),
          //               ),
          //               labelStyle: const TextStyle(
          //                 color: Colors.grey,
          //                 fontSize: 17,
          //               ),
          //             ),
          //           ),
          //         ),
          //         const SizedBox(
          //           height: 20,
          //         ),
          //       ],
          //     ),
          //   ),
          //   collapsed: Container(
          //     decoration: const BoxDecoration(
          //       borderRadius: BorderRadius.only(
          //         topLeft: Radius.circular(24.0),
          //         topRight: Radius.circular(24.0),
          //       ),
          //     ),
          //   ),
          //   borderRadius: const BorderRadius.only(
          //     topLeft: Radius.circular(24.0),
          //     topRight: Radius.circular(24.0),
          //   ),
          //   // padding: const EdgeInsets.symmetric(
          //   //   horizontal: 24,
          //   //   vertical: 18,
          //   // ),
          // )
        ],
      ),
    );
  }

  Future<void> drawPolyLineFromSourceToDestination() async {
    var originPosition =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationPosition =
        Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    var originLatLng = LatLng(
        originPosition!.locationLatitude!, originPosition.locationLongitude!);

    var destinationLatLng = LatLng(destinationPosition!.locationLatitude!,
        destinationPosition.locationLongitude!);

    var directionDetailsInfo =
        await AssistantMethods.obtainOriginDestinationDirectionDetails(
            originLatLng, destinationLatLng);
    print(
        "These are the points =================================================================================================================");
    print(directionDetailsInfo!.e_points);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResultList =
        pPoints.decodePolyline(directionDetailsInfo.e_points!);

    pLineCoOrdinatesList.clear();

    if (decodedPolyLinePointsResultList.isNotEmpty) {
      decodedPolyLinePointsResultList.forEach((PointLatLng pointLatLng) {
        pLineCoOrdinatesList
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polyLineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.black,
        polylineId: const PolylineId("PolylineID"),
        jointType: JointType.round,
        width: 3,
        points: pLineCoOrdinatesList,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polyLineSet.add(polyline);
    });

    LatLngBounds boundsLatLng;
    if (originLatLng.latitude > destinationLatLng.latitude &&
        originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng =
          LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    } else if (originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude),
      );
    } else if (originLatLng.latitude > destinationLatLng.latitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
        northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      boundsLatLng =
          LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }

    newGoogleMapController!
        .animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));

    Marker originMarker = Marker(
      markerId: const MarkerId("originID"),
      infoWindow:
          InfoWindow(title: originPosition.locationName, snippet: "Origin"),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"),
      infoWindow: InfoWindow(
          title: destinationPosition.locationName, snippet: "Destination"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );

    setState(() {
      markersSet.add(originMarker);
      markersSet.add(destinationMarker);
    });

    Circle originCircle = Circle(
      circleId: const CircleId("originID"),
      fillColor: Color.fromARGB(63, 76, 175, 79),
      radius: 12,
      strokeWidth: 1,
      strokeColor: Colors.black38,
      center: originLatLng,
    );

    Circle destinationCircle = Circle(
      circleId: const CircleId("destinationID"),
      fillColor: Color.fromARGB(103, 244, 67, 54),
      radius: 12,
      strokeWidth: 1,
      strokeColor: Colors.black38,
      center: destinationLatLng,
    );

    setState(() {
      circlesSet.add(originCircle);
      circlesSet.add(destinationCircle);
    });
  }
}
