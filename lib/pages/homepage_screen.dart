import 'dart:async';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qwiker_customer_app/appStyles/app_colors.dart';
import 'package:qwiker_customer_app/appStyles/app_dimensions.dart';
import 'package:qwiker_customer_app/appStyles/app_fonts.dart';
import 'package:qwiker_customer_app/appStyles/app_images.dart';
import 'package:qwiker_customer_app/appStyles/app_strings.dart';
import 'package:qwiker_customer_app/common.dart';
import 'package:qwiker_customer_app/pages/location/select_location_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  TextEditingController pickup = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String? userId;
  String? name;
  String? phoneNumber;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Position? position;
  LatLng? currentLocation;
  String? currentAddress;
  List<Marker> marker = [];

  getId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('UserID');
    getDetails();
    getCurrentLocation();
  }

  getDetails() async {
    DocumentSnapshot<Map<String, dynamic>> snapShotData =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (snapShotData.toString().isNotEmpty) {
      setState(() {
        name = snapShotData.get("username");
        phoneNumber =
            (snapShotData.get("countryCode") + snapShotData.get("phoneNumber"))
                .toString();
      });
    }
  }

  getCurrentLocation() async {
    position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    double currentLat = position!.latitude;
    double currentLon = position!.longitude;
    setState(() {
      currentLocation = LatLng(currentLat, currentLon);
    });
    getAddressFromLatLng();
    getMarker();
  }

  getAddressFromLatLng() async {
    await placemarkFromCoordinates(
            currentLocation!.latitude, currentLocation!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        currentAddress =
            '${place.name}, ${place.subLocality},${place.locality}, ${place.postalCode}';
        pickup.text = currentAddress!;
      });
    }).catchError((e) {
      debugPrint(e);
    });
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
    marker.add(
      Marker(
        markerId: const MarkerId('Current Location'),
        icon: BitmapDescriptor.bytes(currentLocationIcon),
        position: currentLocation == null
            ? const LatLng(30.704649, 76.717873)
            : LatLng(currentLocation!.latitude, currentLocation!.longitude),
        infoWindow: const InfoWindow(
          title: 'Pick up : ${AppStrings.address4}',
        ),
      ),
    );
    setState(() {});
  }

  @override
  void initState() {
    getId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.backgroundColor,
      drawer: name != null
          ? Common.sideDrawer(
              context,
              name.toString(),
            )
          : const Center(
              child: CircularProgressIndicator(
                color: AppColors.whiteColor,
              ),
            ),
      body: currentLocation == null
          ? const CircularProgressIndicator(
              color: AppColors.whiteColor,
            )
          : Stack(
              children: [
                GoogleMap(
                  markers: marker.toSet(),
                  mapType: MapType.terrain,
                  initialCameraPosition: CameraPosition(
                    target: currentLocation!,
                    zoom: 14,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.04,
                  left: MediaQuery.of(context).size.height * 0.02,
                  child: Common.menuBar(context, scaffoldKey),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.21,
                    width: MediaQuery.of(context).size.width * double.infinity,
                    padding: EdgeInsets.all(MediaQuery.of(context).size.height *
                        AppDimensions.padding1),
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
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.005),
                        Text(
                          AppStrings.homePageTitle,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height *
                                AppDimensions.fontSize20,
                            fontFamily: AppFonts.poppinsMedium,
                            color: AppColors.blackColor,
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width:
                                      MediaQuery.of(context).size.width * 0.06,
                                  decoration: BoxDecoration(
                                    color: AppColors.blueColor,
                                    borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.height *
                                          AppDimensions.borderRadius39,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: MediaQuery.of(context).size.height *
                                      0.006,
                                  left: MediaQuery.of(context).size.height *
                                      0.006,
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.017,
                                    width: MediaQuery.of(context).size.width *
                                        0.035,
                                    decoration: BoxDecoration(
                                      color: AppColors.whiteColor,
                                      borderRadius: BorderRadius.circular(
                                        MediaQuery.of(context).size.height *
                                            AppDimensions.borderRadius39,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: TextFormField(
                                controller: pickup,
                                style: TextStyle(
                                  fontFamily: AppFonts.poppinsMedium,
                                  fontSize: MediaQuery.of(context).size.height *
                                      AppDimensions.fontSize12,
                                  color: AppColors.blackColor,
                                ),
                                readOnly: true,
                                onTap: () async {
                                  showModalBottomSheet(
                                    scrollControlDisabledMaxHeightRatio: 1,
                                    context: context,
                                    builder: (context) =>
                                        const SelectLocationScreen(),
                                  );
                                  await FirebaseFirestore.instance
                                      .collection('rides')
                                      .doc(DateTime.now().second.toString())
                                      .set({
                                    'userid': userId,
                                    'username': name,
                                    'user_phoneNumber': phoneNumber,
                                    'pickup_address': currentAddress.toString(),
                                    'pickup_latitude':
                                        currentLocation?.latitude.toString(),
                                    'pickup_longitude':
                                        currentLocation?.longitude.toString(),
                                    'drop_address': '',
                                    'drop_latitude': '',
                                    'drop_longitude': '',
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: AppStrings.currentLocation,
                                  hintStyle: TextStyle(
                                    fontFamily: AppFonts.poppinsMedium,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            AppDimensions.fontSize12,
                                    color: AppColors.lightGreyColor,
                                  ),
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  disabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: AppColors.mediumWhiteColor,
                          indent: MediaQuery.of(context).size.width * 0.15,
                          endIndent: MediaQuery.of(context).size.width * 0.05,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width:
                                      MediaQuery.of(context).size.width * 0.06,
                                  decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    border: Border.all(
                                      color: AppColors.lightWhiteColor,
                                      width: MediaQuery.of(context).size.width *
                                          0.004,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.height *
                                          AppDimensions.borderRadius39,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: MediaQuery.of(context).size.height *
                                      0.006,
                                  left: MediaQuery.of(context).size.height *
                                      0.006,
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.017,
                                    width: MediaQuery.of(context).size.width *
                                        0.035,
                                    decoration: BoxDecoration(
                                      color: AppColors.blackColor,
                                      borderRadius: BorderRadius.circular(
                                        MediaQuery.of(context).size.height *
                                            AppDimensions.borderRadius39,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: TextFormField(
                                style: TextStyle(
                                  fontFamily: AppFonts.poppinsMedium,
                                  fontSize: MediaQuery.of(context).size.height *
                                      AppDimensions.fontSize12,
                                  color: AppColors.blackColor,
                                ),
                                readOnly: true,
                                onTap: () async {
                                  showModalBottomSheet(
                                    scrollControlDisabledMaxHeightRatio: 1,
                                    context: context,
                                    builder: (context) =>
                                        const SelectLocationScreen(),
                                  );

                                  String docId =
                                      DateTime.now().second.toString();
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setString('docId', docId);

                                  await FirebaseFirestore.instance
                                      .collection('rides')
                                      .doc(docId)
                                      .set({
                                    'userid': userId,
                                    'username': name,
                                    'user_phoneNumber': phoneNumber,
                                    'pickup_address': currentAddress.toString(),
                                    'pickup_latitude':
                                        currentLocation?.latitude.toString(),
                                    'pickup_longitude':
                                        currentLocation?.longitude.toString(),
                                    'drop_address': '',
                                    'drop_latitude': '',
                                    'drop_longitude': '',
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: AppStrings.searchDestination,
                                  hintStyle: TextStyle(
                                    fontFamily: AppFonts.poppinsMedium,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            AppDimensions.fontSize12,
                                    color: AppColors.greyColor,
                                  ),
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  disabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
