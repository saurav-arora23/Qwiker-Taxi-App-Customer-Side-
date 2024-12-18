import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qwiker_customer_app/appStyles/app_colors.dart';
import 'package:qwiker_customer_app/appStyles/app_dimensions.dart';
import 'package:qwiker_customer_app/appStyles/app_fonts.dart';
import 'package:qwiker_customer_app/appStyles/app_strings.dart';
import 'package:qwiker_customer_app/common.dart';
import 'package:qwiker_customer_app/models/add_stops_model.dart';
import 'package:qwiker_customer_app/models/recent_location_model.dart';
import 'package:qwiker_customer_app/models/suggested_location_model.dart';
import 'package:qwiker_customer_app/pages/bookRide/select_ride_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({super.key});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  TextEditingController pickup = TextEditingController();
  TextEditingController drop = TextEditingController();
  String? userId;
  String? docId;

  Position? position;
  LatLng? currentLocation;
  LatLng? pickupLocation;
  LatLng? dropLocation;
  String? pickupAddress;
  String? dropAddress;

  getId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('UserID');
    docId = prefs.getString('docId');
    debugPrint('doc Id -- $docId');
    getCurrentLocation();
  }

  getCurrentLocation() async {
    position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      currentLocation = LatLng(position!.latitude, position!.longitude);
    });
    getAddressFromLatLng();
  }

  getAddressFromLatLng() async {
    await placemarkFromCoordinates(
            currentLocation!.latitude, currentLocation!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        pickupAddress =
            '${place.name}, ${place.subLocality},${place.locality}, ${place.postalCode}';
        pickup.text = pickupAddress!;
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  getLatLngFromAddress(String address) async {
    address == pickup.text
        ? locationFromAddress(address).then((locations) {
            if (locations.isNotEmpty) {
              setState(() {
                pickupLocation =
                    LatLng(locations[0].latitude, locations[0].longitude);
              });
            }
          })
        : locationFromAddress(address).then((locations) {
            if (locations.isNotEmpty) {
              setState(() {
                dropLocation =
                    LatLng(locations[0].latitude, locations[0].longitude);
              });
            }
          });
    debugPrint('${pickupLocation?.latitude},${pickupLocation?.longitude}');
    debugPrint('$pickupAddress');
    debugPrint('${dropLocation?.latitude},${dropLocation?.longitude}');
    debugPrint('$dropAddress');
  }

  @override
  void initState() {
    getId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: Common.appBar(
        context,
        '',
        Common.backButton(context),
        AppColors.whiteColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.23,
              width: MediaQuery.of(context).size.width * double.infinity,
              color: AppColors.whiteColor,
              padding: EdgeInsets.only(
                left:
                    MediaQuery.of(context).size.height * AppDimensions.padding3,
                right: MediaQuery.of(context).size.height *
                    AppDimensions.padding05,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.06,
                            decoration: BoxDecoration(
                              color: AppColors.blueColor,
                              borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.height *
                                    AppDimensions.borderRadius39,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: MediaQuery.of(context).size.height * 0.006,
                            left: MediaQuery.of(context).size.height * 0.006,
                            child: Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.017,
                              width: MediaQuery.of(context).size.width * 0.035,
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
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                        width: MediaQuery.of(context).size.width * 0.72,
                        child: TextFormField(
                          controller: pickup,
                          style: TextStyle(
                            fontFamily: AppFonts.poppinsMedium,
                            fontSize: MediaQuery.of(context).size.height *
                                AppDimensions.fontSize12,
                            color: AppColors.blackColor,
                          ),
                          onChanged: (value) {
                            setState(() {
                              pickup.text = value;
                              pickupAddress = pickup.text;
                            });
                            getLatLngFromAddress(pickup.text);
                          },
                          onEditingComplete: () async {
                            await FirebaseFirestore.instance
                                .collection('rides')
                                .doc(docId)
                                .update({
                              'pickup_address': pickupAddress,
                              'pickup_latitude':
                                  pickupLocation?.latitude.toString(),
                              'pickup_longitude':
                                  pickupLocation?.longitude.toString(),
                            });
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(
                              MediaQuery.of(context).size.height *
                                  AppDimensions.padding1,
                            ),
                            hintText: AppStrings.currentLocation,
                            hintStyle: TextStyle(
                              fontFamily: AppFonts.poppinsMedium,
                              fontSize: MediaQuery.of(context).size.height *
                                  AppDimensions.fontSize12,
                              color: AppColors.lightGreyColor,
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: AppColors.alternateWhiteColor,
                              ),
                              borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.height *
                                    AppDimensions.borderRadius31,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: AppColors.alternateWhiteColor,
                              ),
                              borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.height *
                                    AppDimensions.borderRadius31,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: AppColors.alternateWhiteColor,
                              ),
                              borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.height *
                                    AppDimensions.borderRadius31,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: AppColors.alternateWhiteColor,
                              ),
                              borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.height *
                                    AppDimensions.borderRadius31,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.11,
                    width: MediaQuery.of(context).size.width * double.infinity,
                    child: ListView.builder(
                      controller: ScrollController(),
                      shrinkWrap: true,
                      itemCount: addStopsModel.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                                width:
                                    MediaQuery.of(context).size.width * 0.02),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.04,
                              width: MediaQuery.of(context).size.width * 0.72,
                              child: TextFormField(
                                controller: drop,
                                onChanged: (value) {
                                  setState(() {
                                    drop.text = value;
                                    dropAddress = drop.text;
                                  });
                                  getLatLngFromAddress(drop.text);
                                },
                                onEditingComplete: () async {
                                  try {
                                    await FirebaseFirestore.instance
                                        .collection('rides')
                                        .doc(docId)
                                        .update({
                                      'drop_address': dropAddress,
                                      'drop_latitude':
                                          dropLocation?.latitude.toString(),
                                      'drop_longitude':
                                          dropLocation?.longitude.toString(),
                                    });

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SelectRideScreen(),
                                      ),
                                    );
                                  } catch (e) {
                                    debugPrint(e.toString());
                                  }
                                },
                                readOnly: false,
                                style: TextStyle(
                                  fontFamily: AppFonts.poppinsMedium,
                                  fontSize: MediaQuery.of(context).size.height *
                                      AppDimensions.fontSize12,
                                  color: AppColors.blackColor,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(
                                    MediaQuery.of(context).size.height *
                                        AppDimensions.padding1,
                                  ),
                                  hintText: addStopsModel[index].hint,
                                  hintStyle: TextStyle(
                                    fontFamily: AppFonts.poppinsMedium,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            AppDimensions.fontSize12,
                                    color: AppColors.lightGreyColor,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors.alternateWhiteColor,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.height *
                                          AppDimensions.borderRadius31,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors.alternateWhiteColor,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.height *
                                          AppDimensions.borderRadius31,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors.alternateWhiteColor,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.height *
                                          AppDimensions.borderRadius31,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors.alternateWhiteColor,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.height *
                                          AppDimensions.borderRadius31,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (addStopsModel[index].hint == 'Add Stop') {
                                  setState(() {
                                    addStopsModel.remove(addStopsModel[index]);
                                  });
                                } else {
                                  setState(() {
                                    addStopsModel.add(
                                      AddStopsModel(
                                          '02:50 PM', AppStrings.addStop),
                                    );
                                  });
                                }
                              },
                              icon: Icon(
                                addStopsModel[index].hint == 'Add Stop'
                                    ? Icons.highlight_remove_rounded
                                    : Icons.add,
                                color: addStopsModel[index].hint == 'Add Stop'
                                    ? AppColors.textGreyColor
                                    : AppColors.blueColor,
                                size: MediaQuery.of(context).size.height * 0.02,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                  Text(
                    AppStrings.multipleStops,
                    style: TextStyle(
                      color: AppColors.textGreyColor,
                      fontFamily: AppFonts.segoeRegular,
                      fontSize: MediaQuery.of(context).size.height *
                          AppDimensions.fontSize12,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.18,
              width: MediaQuery.of(context).size.width * double.infinity,
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(
                  MediaQuery.of(context).size.height * AppDimensions.padding1,
                ),
                itemCount: recentLocationModel.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    minTileHeight: 1,
                    minVerticalPadding: 12,
                    leading: IconButton(
                      style: ButtonStyle(
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.height *
                                  AppDimensions.borderRadius10,
                            ),
                          ),
                        ),
                        surfaceTintColor: const WidgetStatePropertyAll(
                            AppColors.backgroundColor),
                        backgroundColor:
                            const WidgetStatePropertyAll(AppColors.whiteColor),
                      ),
                      onPressed: () {
                        if (recentLocationModel[index].selected == false) {
                          setState(() {
                            recentLocationModel[index].selected = true;
                          });
                        } else {
                          setState(() {
                            recentLocationModel[index].selected = false;
                          });
                        }
                      },
                      icon: Icon(
                        recentLocationModel[index].selected == true
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_outlined,
                        size: MediaQuery.of(context).size.height * 0.02,
                        color: recentLocationModel[index].selected == true
                            ? AppColors.redColor
                            : AppColors.blueColor,
                      ),
                    ),
                    title: Text(
                      recentLocationModel[index].title,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height *
                            AppDimensions.fontSize14,
                        fontFamily: AppFonts.poppinsMedium,
                        color: AppColors.blackColor,
                      ),
                    ),
                    subtitle: Text(
                      recentLocationModel[index].address,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height *
                            AppDimensions.fontSize12,
                        fontFamily: AppFonts.poppinsRegular,
                        color: AppColors.lightGreyColor,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.47,
              width: MediaQuery.of(context).size.width * double.infinity,
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(
                  MediaQuery.of(context).size.height * AppDimensions.padding1,
                ),
                itemCount: suggestedLocationModel.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    minTileHeight: 1,
                    minLeadingWidth: 1,
                    minVerticalPadding: 10,
                    leading: Icon(
                      Icons.circle,
                      size: MediaQuery.of(context).size.height * 0.015,
                      color: AppColors.blackColor,
                    ),
                    title: Text(
                      suggestedLocationModel[index].address,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height *
                            AppDimensions.fontSize12,
                        fontFamily: AppFonts.poppinsRegular,
                        color: AppColors.blackColor,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
