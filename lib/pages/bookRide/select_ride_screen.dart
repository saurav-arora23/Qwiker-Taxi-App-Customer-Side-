import 'dart:async';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qwiker_customer_app/appStyles/app_colors.dart';
import 'package:qwiker_customer_app/appStyles/app_dimensions.dart';
import 'package:qwiker_customer_app/appStyles/app_fonts.dart';
import 'package:qwiker_customer_app/appStyles/app_images.dart';
import 'package:qwiker_customer_app/appStyles/app_strings.dart';
import 'package:qwiker_customer_app/common.dart';
import 'package:qwiker_customer_app/models/firebase_model.dart';
import 'package:qwiker_customer_app/models/rides_model.dart';
import 'package:qwiker_customer_app/pages/bookRide/payment_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectRideScreen extends StatefulWidget {
  const SelectRideScreen({super.key});

  @override
  State<SelectRideScreen> createState() => _SelectRideScreenState();
}

class _SelectRideScreenState extends State<SelectRideScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  PolylinePoints polylinePoints = PolylinePoints();
  String googleApi = 'AIzaSyBKIKPgJLtqbICSp1zi4mwdIh0F-9dSCFM';

  String? userId;
  String? docId;
  String? pickUpAddress;
  String? dropAddress;

  LatLng? pickUpLocation;
  LatLng? dropLocation;

  List<LatLng> locations = [];
  List<Marker> marker = [];
  List<Marker> markerList = [];
  List<FirebaseModel> rides = [];
  /*List<Polyline> polyline = [];*/

  getId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('UserID');
    docId = prefs.getString('docId');
    debugPrint('doc Id -- $docId');
    getLocations();
  }

  getLocations() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('rides').doc(docId).get();
    if (snapshot.toString().isNotEmpty) {
      setState(() {
        pickUpAddress = snapshot.get('pickup_address');
        dropAddress = snapshot.get('drop_address');
        pickUpLocation = LatLng(
          double.parse(
            snapshot.get('pickup_latitude'),
          ),
          double.parse(
            snapshot.get('pickup_longitude'),
          ),
        );
        dropLocation = LatLng(
          double.parse(
            snapshot.get('drop_latitude'),
          ),
          double.parse(
            snapshot.get('drop_longitude'),
          ),
        );
      });
    }
    getMarker();
  }

  Future<Uint8List> getImages(String path, int height, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetHeight: height,
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  getMarker() async {
    final Uint8List currentLocationIcon =
        await getImages(AppImages.location, 15, 15);
    final Uint8List dropLocationIcon =
        await getImages(AppImages.dropLocation, 15, 15);
    markerList.add(
      Marker(
        markerId: const MarkerId('Pick Up Location'),
        icon: BitmapDescriptor.bytes(currentLocationIcon),
        position: pickUpLocation == null
            ? const LatLng(0, 0)
            : LatLng(pickUpLocation!.latitude, pickUpLocation!.longitude),
        infoWindow: const InfoWindow(
          title: 'Pick up : ${AppStrings.address4}',
        ),
      ),
    );
    markerList.add(
      Marker(
        markerId: const MarkerId('Drop Location'),
        icon: BitmapDescriptor.bytes(dropLocationIcon),
        position: dropLocation == null
            ? const LatLng(0, 0)
            : LatLng(dropLocation!.latitude, dropLocation!.longitude),
        infoWindow: const InfoWindow(
          title: 'Drop : ${AppStrings.address3}',
        ),
      ),
    );
    /*locations.add(LatLng(pickUpLocation!.latitude, pickUpLocation!.longitude));
    locations.add(LatLng(dropLocation!.latitude, dropLocation!.longitude));*/
    setMarkers();
    setState(() {});
  }

  setMarkers() {
    marker.addAll(markerList);
    setState(() {});
  }

  getAvailableRides() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('available_rides').get();

    if (snapshot.toString().isNotEmpty) {
      for (int i = 0; i < snapshot.docs.length; i++) {
        setState(() {
          rides.add(
            FirebaseModel(
              snapshot: snapshot.docs[i],
              isSelected: false,
            ),
          );
        });
      }
    }

    debugPrint('Length of Rides --- ${rides.length}');
  }

  /*computePath() async {
    PointLatLng pickup =
        PointLatLng(currentLocation!.latitude, currentLocation!.longitude);
    PointLatLng drop = const PointLatLng(30.7358098323453, 76.66240783863283);
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: googleApi,
      request: PolylineRequest(
        origin: pickup,
        destination: drop,
        mode: TravelMode.driving,
      ),
    );
    if (result.points.isNotEmpty) {
      for (int i = 0; i < result.points.length; i++) {
        setState(() {
          locations.add(
            LatLng(
              result.points[i].latitude,
              result.points[i].longitude,
            ),
          );
        });
      }
    }

    setState(() {
      polyline.add(
        Polyline(
          polylineId: const PolylineId('Locations'),
          visible: true,
          jointType: JointType.round,
          points: locations,
          width: 4,
          color: Colors.blue,
        ),
      );
    });
  }*/

  @override
  void initState() {
    getId();
    getAvailableRides();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: pickUpLocation == null
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.blueColor,
              ),
            )
          : Stack(
              children: [
                GoogleMap(
                  markers: marker.toSet(),
                  mapType: MapType.normal,
                  // polylines: polyline.toSet(),
                  initialCameraPosition: CameraPosition(
                    target: pickUpLocation!,
                    zoom: 14,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.04,
                  left: MediaQuery.of(context).size.height * 0.02,
                  child: Common.backButton(context),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.48,
                    width: MediaQuery.of(context).size.width * double.infinity,
                    padding: EdgeInsets.all(MediaQuery.of(context).size.height *
                        AppDimensions.padding2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          MediaQuery.of(context).size.height *
                              AppDimensions.borderRadius24,
                        ),
                        topRight: Radius.circular(
                          MediaQuery.of(context).size.height *
                              AppDimensions.borderRadius24,
                        ),
                      ),
                      color: AppColors.whiteColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.availableRides,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height *
                                AppDimensions.fontSize20,
                            fontFamily: AppFonts.poppinsMedium,
                            color: AppColors.blackColor,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.38,
                          width: MediaQuery.of(context).size.width *
                              double.infinity,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: rides.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                color: rides[index].isSelected == true
                                    ? AppColors.ultraLightWhiteColor
                                    : AppColors.whiteColor,
                                margin: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).size.height *
                                      0.015,
                                ),
                                elevation: 1,
                                child: ListTile(
                                  onTap: () async {
                                    for (int i = 0; i < rides.length; i++) {
                                      rides[i].isSelected = false;
                                      setState(() {});
                                    }
                                    rides[index].isSelected =
                                        !rides[index].isSelected;
                                    if (rides[index].isSelected == true) {
                                      await FirebaseFirestore.instance
                                          .collection('rides')
                                          .doc(docId)
                                          .update({
                                        'ride_type_id':
                                            rides[index].snapshot.id,
                                        'ride_type': rides[index]
                                            .snapshot
                                            .get('ride_name'),
                                        'ride_fare': 52.0,
                                      });
                                    }
                                  },
                                  leading: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: Center(
                                      child: Image.asset(
                                        rides[index]
                                                    .snapshot
                                                    .get('ride_name') ==
                                                'Bala Ji'
                                            ? AppImages.auto
                                            : rides[index]
                                                        .snapshot
                                                        .get('ride_name') ==
                                                    'Bike'
                                                ? AppImages.bike
                                                : rides[index]
                                                            .snapshot
                                                            .get('ride_name') ==
                                                        'Micro'
                                                    ? AppImages.microCab
                                                    : AppImages.miniCab,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.055,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    rides[index].snapshot.get('ride_name'),
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              AppDimensions.fontSize16,
                                      fontFamily: AppFonts.poppinsMedium,
                                      color: AppColors.blackColor,
                                    ),
                                  ),
                                  subtitle: Text(
                                    rides[index].snapshot.get('person_allowed'),
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              AppDimensions.fontSize12,
                                      fontFamily: AppFonts.poppinsRegular,
                                      color: rides[index].isSelected == true
                                          ? AppColors.blackColor
                                          : AppColors.textGreyColor,
                                    ),
                                  ),
                                  trailing: Text(
                                    ridesModel[index].rideFare,
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              AppDimensions.fontSize14,
                                      fontFamily: AppFonts.poppinsMedium,
                                      color: AppColors.blackColor,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.01,
                  right: MediaQuery.of(context).size.height * 0.02,
                  left: MediaQuery.of(context).size.height * 0.02,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaymentScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        color: AppColors.blueColor,
                        borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.height *
                              AppDimensions.borderRadius28,
                        ),
                        border: Border.all(
                          color: AppColors.alternateWhiteColor,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          AppStrings.bookRideButton,
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: MediaQuery.of(context).size.height *
                                AppDimensions.fontSize18,
                            fontFamily: AppFonts.poppinsMedium,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
