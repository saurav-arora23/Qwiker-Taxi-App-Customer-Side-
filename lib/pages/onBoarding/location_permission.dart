import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qwiker_customer_app/appStyles/app_colors.dart';
import 'package:qwiker_customer_app/appStyles/app_dimensions.dart';
import 'package:qwiker_customer_app/appStyles/app_fonts.dart';
import 'package:qwiker_customer_app/appStyles/app_images.dart';
import 'package:qwiker_customer_app/appStyles/app_strings.dart';
import 'package:qwiker_customer_app/pages/authentication/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationPermission extends StatefulWidget {
  const LocationPermission({super.key});

  @override
  State<LocationPermission> createState() => _LocationPermissionState();
}

class _LocationPermissionState extends State<LocationPermission> {
  String? userId;

  getId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('UserID');
  }

  @override
  void initState() {
    getId();
    super.initState();
  }

  getPermission() async {
    await Permission.location.request();
    Permission.location.serviceStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: EdgeInsets.all(
          MediaQuery.of(context).size.height * AppDimensions.padding5,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.12),
            Image.asset(
              AppImages.locationPermissionScreen,
              height: MediaQuery.of(context).size.height * 0.27893,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Text(
              AppStrings.locationPermissionDes,
              style: TextStyle(
                color: AppColors.blackColor,
                fontSize: MediaQuery.of(context).size.height *
                    AppDimensions.fontSize20,
                fontFamily: AppFonts.poppinsMedium,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.36),
            GestureDetector(
              onTap: () {
                getPermission();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.blueColor,
                  borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height *
                        AppDimensions.borderRadius39,
                  ),
                ),
                child: Center(
                  child: Text(
                    AppStrings.allowLocationButton,
                    style: TextStyle(
                      fontFamily: AppFonts.poppinsMedium,
                      fontSize: MediaQuery.of(context).size.height *
                          AppDimensions.fontSize18,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
