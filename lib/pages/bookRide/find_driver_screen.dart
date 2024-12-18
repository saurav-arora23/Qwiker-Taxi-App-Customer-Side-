import 'dart:async';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qwiker_customer_app/appStyles/app_colors.dart';
import 'package:qwiker_customer_app/appStyles/app_dimensions.dart';
import 'package:qwiker_customer_app/appStyles/app_fonts.dart';
import 'package:qwiker_customer_app/appStyles/app_images.dart';
import 'package:qwiker_customer_app/appStyles/app_strings.dart';
import 'package:qwiker_customer_app/common.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FindDriverScreen extends StatefulWidget {
  const FindDriverScreen({super.key});

  @override
  State<FindDriverScreen> createState() => _FindDriverScreenState();
}

class _FindDriverScreenState extends State<FindDriverScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  // PolylinePoints polylinePoints = PolylinePoints();
  // String googleApi = 'AIzaSyBKIKPgJLtqbICSp1zi4mwdIh0F-9dSCFM';

  Timer? _timer;

  String? userId;
  String? docId;
  String? pickUpAddress;
  String? dropAddress;

  LatLng? pickUpLocation;
  LatLng? dropLocation;

  List<Marker> markerList = [];
  List<Marker> marker = [];
  // List<LatLng> locations = [];
  // List<Polyline> polyline = [];

  getId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('UserID');
    docId = prefs.getString('docId');
    debugPrint('Document ID -- $docId');
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

  /*computePath() async {
    PointLatLng pickup =
        PointLatLng(pickUpLocation!.latitude, pickUpLocation!.longitude);
    PointLatLng drop =
        PointLatLng(dropLocation!.latitude, dropLocation!.longitude);
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
    _timer = Timer(
      const Duration(minutes: 10),
      () => showModalBottomSheet(
        context: context,
        builder: (context) => Common.timeOut(context),
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
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
                  mapType: MapType.terrain,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(AppImages.waitingScreen),
                        LinearProgressIndicator(
                          value: 0.4,
                          minHeight: MediaQuery.of(context).size.height * 0.008,
                          borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.height *
                                AppDimensions.borderRadius12,
                          ),
                          color: AppColors.blueColor,
                          backgroundColor: AppColors.blueColor.withOpacity(0.2),
                        ),
                        Text(
                          AppStrings.waitingDes,
                          style: TextStyle(
                            color: AppColors.mediumBlackColor,
                            fontFamily: AppFonts.poppinsMedium,
                            fontSize: MediaQuery.of(context).size.height *
                                AppDimensions.fontSize18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  Common.rideCancelDialog(context),
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
                                AppStrings.cancelRideButton,
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
