import 'dart:async';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qwiker_customer_app/appStyles/app_colors.dart';
import 'package:qwiker_customer_app/appStyles/app_dimensions.dart';
import 'package:qwiker_customer_app/appStyles/app_fonts.dart';
import 'package:qwiker_customer_app/appStyles/app_images.dart';
import 'package:qwiker_customer_app/appStyles/app_strings.dart';
import 'package:qwiker_customer_app/common.dart';
import 'package:qwiker_customer_app/pages/drawer/sos/view_all_trusted_contact.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SosContactScreen extends StatefulWidget {
  const SosContactScreen({super.key});

  @override
  State<SosContactScreen> createState() => _SosContactScreenState();
}

class _SosContactScreenState extends State<SosContactScreen> {

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Position? position;
  LatLng? currentLocation;
  List<Marker> marker = [];
  List<Marker> markerList = [];
  List<dynamic> sc = [];
  String? userId;
  String? name;

  getId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('UserID');
    getDetails();
    getCurrentLocation();
  }

  getContacts() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('UserID');
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('sos_contacts')
        .doc(userId)
        .get();
    if (snapshot.toString().isNotEmpty) {
      sc.clear();
      setState(() {
        sc.addAll(snapshot.get('contacts'));
      });
    }
    debugPrint('SOS Contact Length is  --  ${sc.length}');
    setState(() {});
  }

  getDetails() async {
    DocumentSnapshot<Map<String, dynamic>> snapShotData =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (snapShotData.toString().isNotEmpty) {
      setState(() {
        name = snapShotData.get("username");
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
    getContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
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
                  child: Common.backButton(context),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.18,
                    width: MediaQuery.of(context).size.width * double.infinity,
                    padding: EdgeInsets.all(
                      MediaQuery.of(context).size.height *
                          AppDimensions.padding1,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          MediaQuery.of(context).size.height *
                              AppDimensions.borderRadius28,
                        ),
                        topRight: Radius.circular(
                          MediaQuery.of(context).size.height *
                              AppDimensions.borderRadius28,
                        ),
                      ),
                      color: AppColors.whiteColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              AppStrings.sosDes,
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.height *
                                    AppDimensions.fontSize20,
                                fontFamily: AppFonts.poppinsMedium,
                                color: AppColors.blackColor,
                              ),
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.32),
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ViewAllTrustedContact(),
                                  ),
                                );
                              },
                              child: Text(
                                AppStrings.viewAll,
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height *
                                      AppDimensions.fontSize14,
                                  fontFamily: AppFonts.poppinsMedium,
                                  color: AppColors.textGreyColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        sc.isEmpty
                            ? Center(
                                child: Text(
                                  "You Don't add any Contact into SOS",
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            AppDimensions.fontSize14,
                                    fontFamily: AppFonts.poppinsMedium,
                                    color: AppColors.blueColor,
                                  ),
                                ),
                              )
                            : SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: sc.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.066,
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: ListTile(
                                        leading: SvgPicture.asset(
                                          AppImages.profile,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.06,
                                        ),
                                        title: Text(
                                          sc[index]['contact_name'],
                                          style: TextStyle(
                                            color: AppColors.blackColor,
                                            fontFamily: AppFonts.poppinsMedium,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                AppDimensions.fontSize18,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "${sc[index]['country_code']}${sc[index]['contact_number']}",
                                          style: TextStyle(
                                            color: AppColors.textGreyColor,
                                            fontFamily: AppFonts.poppinsMedium,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                AppDimensions.fontSize18,
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
              ],
            ),
    );
  }
}
