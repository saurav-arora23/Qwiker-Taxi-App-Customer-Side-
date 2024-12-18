import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qwiker_customer_app/appStyles/app_colors.dart';
import 'package:qwiker_customer_app/appStyles/app_dimensions.dart';
import 'package:qwiker_customer_app/appStyles/app_fonts.dart';
import 'package:qwiker_customer_app/appStyles/app_images.dart';
import 'package:qwiker_customer_app/appStyles/app_strings.dart';
import 'package:qwiker_customer_app/common.dart';
import 'package:qwiker_customer_app/pages/bookRide/message_screen.dart';
import 'package:qwiker_customer_app/pages/bookRide/rating_screen.dart';
import 'package:qwiker_customer_app/pages/homepage_screen.dart';
import 'package:qwiker_customer_app/pages/location/select_location_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class TrackDriverScreen extends StatefulWidget {
  const TrackDriverScreen({super.key});

  @override
  State<TrackDriverScreen> createState() => _TrackDriverScreenState();
}

class _TrackDriverScreenState extends State<TrackDriverScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  PolylinePoints polylinePoints = PolylinePoints();
  String googleApi = 'AIzaSyBKIKPgJLtqbICSp1zi4mwdIh0F-9dSCFM';

  String? userId;
  Position? position;
  LatLng? currentLocation;
  late Timer _timer;
  List<LatLng> locations = [];
  List<Marker> marker = [];
  List<Polyline> polyline = [];
  List<Marker> markerList = [];

  getId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('UserID');
    getCurrentLocation();
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
    final Uint8List driverLocationIcon =
        await getImages(AppImages.driverLocation, 50, 50);
    markerList.add(
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
    markerList.add(
      Marker(
        markerId: const MarkerId('Drop Location'),
        icon: BitmapDescriptor.bytes(driverLocationIcon),
        position: currentLocation == null
            ? const LatLng(30.704649, 76.717873)
            : const LatLng(30.742467733796488, 76.66561576061855),
        infoWindow: const InfoWindow(
          title: 'Drop : ${AppStrings.address3}',
        ),
      ),
    );
    locations
        .add(LatLng(currentLocation!.latitude, currentLocation!.longitude));
    locations.add(const LatLng(30.7358098323453, 76.66240783863283));
    setMarkers();
    setState(() {});
  }

  setMarkers() {
    marker.addAll(markerList);
    setState(() {});
  }

  computePath() async {
    var pickup =
        PointLatLng(currentLocation!.latitude, currentLocation!.longitude);
    var drop = const PointLatLng(30.7358098323453, 76.66240783863283);
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
  }

  _makingPhoneCall() async {
    var url = Uri.parse("tel:+91 6549848014");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    getId();
    computePath();
    _timer = Timer(
      const Duration(seconds: 10),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const RatingScreen(),
        ),
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
                  polylines: polyline.toSet(),
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.cabAcceptTitle,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height *
                                AppDimensions.fontSize20,
                            fontFamily: AppFonts.poppinsMedium,
                            color: AppColors.blackColor,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height *
                                      AppDimensions.borderRadius39,
                                ),
                                child: Image.asset(
                                  AppImages.driver,
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                ),
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.02),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        AppStrings.driverName,
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              AppDimensions.fontSize20,
                                          fontFamily: AppFonts.poppinsMedium,
                                          color: AppColors.blackColor,
                                        ), //
                                      ),
                                      Icon(
                                        Icons.star_rate_rounded,
                                        size:
                                            MediaQuery.of(context).size.height *
                                                0.022,
                                        color: AppColors.yellowColor,
                                      ),
                                      Text(
                                        '4',
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              AppDimensions.fontSize14,
                                          fontFamily: AppFonts.poppinsBold,
                                          color: AppColors.greyColor,
                                        ), //
                                      ),
                                    ],
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Volkswagen  - ',
                                          style: TextStyle(
                                              fontFamily:
                                                  AppFonts.poppinsRegular,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  AppDimensions.fontSize12,
                                              color:
                                                  AppColors.mediumGreyColor), //
                                        ),
                                        TextSpan(
                                          text: 'HG5045',
                                          style: TextStyle(
                                              fontFamily: AppFonts.poppinsBold,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  AppDimensions.fontSize12,
                                              color: AppColors.blackColor), //
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25),
                              CircleAvatar(
                                radius: MediaQuery.of(context).size.height *
                                    AppDimensions.borderRadius20,
                                backgroundColor: AppColors.blueColor,
                                child: IconButton(
                                  onPressed: () {
                                    debugPrint('Click on Call');
                                    _makingPhoneCall();
                                  },
                                  icon: Icon(
                                    Icons.phone,
                                    color: AppColors.whiteColor,
                                    size: MediaQuery.of(context).size.height *
                                        0.022,
                                  ),
                                ),
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.02),
                              CircleAvatar(
                                radius: MediaQuery.of(context).size.height *
                                    AppDimensions.borderRadius20,
                                backgroundColor: AppColors.blueColor,
                                child: IconButton(
                                  onPressed: () {
                                    debugPrint('Click on Message');
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const MessageScreen(),
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.message,
                                    color: AppColors.whiteColor,
                                    size: MediaQuery.of(context).size.height *
                                        0.022,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.026,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                        decoration: BoxDecoration(
                                          color: AppColors.blueColor,
                                          borderRadius: BorderRadius.circular(
                                            MediaQuery.of(context).size.height *
                                                AppDimensions.borderRadius39,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom:
                                            MediaQuery.of(context).size.height *
                                                0.0035,
                                        left:
                                            MediaQuery.of(context).size.height *
                                                0.0035,
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.007,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.015,
                                          decoration: BoxDecoration(
                                            color: AppColors.whiteColor,
                                            borderRadius: BorderRadius.circular(
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  AppDimensions.borderRadius39,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02),
                                  Text(
                                    AppStrings.address4,
                                    style: TextStyle(
                                      fontFamily: AppFonts.segoeRegular,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              AppDimensions.fontSize12,
                                      color: AppColors.blackColor,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.026,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                        decoration: BoxDecoration(
                                          color: AppColors.whiteColor,
                                          border: Border.all(
                                            color: AppColors.lightWhiteColor,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.004,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            MediaQuery.of(context).size.height *
                                                AppDimensions.borderRadius39,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.0035,
                                        left:
                                            MediaQuery.of(context).size.height *
                                                0.0035,
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.007,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.015,
                                          decoration: BoxDecoration(
                                            color: AppColors.blackColor,
                                            borderRadius: BorderRadius.circular(
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  AppDimensions.borderRadius39,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02),
                                  Text(
                                    AppStrings.address3,
                                    style: TextStyle(
                                      fontFamily: AppFonts.segoeRegular,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              AppDimensions.fontSize12,
                                      color: AppColors.blackColor,
                                    ),
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.28),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const SelectLocationScreen(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      AppStrings.change,
                                      style: TextStyle(
                                        fontFamily: AppFonts.segoeBold,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                AppDimensions.fontSize12,
                                        color: AppColors.textGreyColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Card(
                          color: AppColors.ultraLightWhiteColor,
                          elevation: 3,
                          margin: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height * 0.02,
                          ),
                          child: ListTile(
                            onTap: () {
                              null;
                            },
                            leading: Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.047,
                              width: MediaQuery.of(context).size.width * 0.1,
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height *
                                      AppDimensions.borderRadius28,
                                ),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  AppImages.cash,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            title: Text(
                              AppStrings.cash,
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.height *
                                    AppDimensions.fontSize16,
                                fontFamily: AppFonts.poppinsBold,
                                color: AppColors.blackColor,
                              ),
                            ),
                            subtitle: Text(
                              AppStrings.changePaymentMethod,
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.height *
                                    AppDimensions.fontSize10,
                                fontFamily: AppFonts.poppinsMedium,
                                color: AppColors.mediumTextGreyColor,
                              ),
                            ),
                            trailing: Icon(
                              Icons.navigate_next_rounded,
                              color: AppColors.blackColor,
                              size: MediaQuery.of(context).size.height * 0.024,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.056,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '\$52',
                                    style: TextStyle(
                                      fontFamily: AppFonts.poppinsBold,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              AppDimensions.fontSize24,
                                      color: AppColors.blueColor,
                                    ),
                                  ),
                                  Text(
                                    AppStrings.price,
                                    style: TextStyle(
                                      fontFamily: AppFonts.poppinsMedium,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              AppDimensions.fontSize14,
                                      color: AppColors.blackColor,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const HomepageScreen(),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.055,
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.height *
                                        AppDimensions.padding1,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.height *
                                          AppDimensions.borderRadius28,
                                    ),
                                    border:
                                        Border.all(color: AppColors.redColor),
                                  ),
                                  child: Center(
                                    child: Text(
                                      AppStrings.cancelRideButton,
                                      style: TextStyle(
                                        color: AppColors.redColor,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
