import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qwiker_customer_app/appStyles/app_colors.dart';
import 'package:qwiker_customer_app/appStyles/app_dimensions.dart';
import 'package:qwiker_customer_app/appStyles/app_fonts.dart';
import 'package:qwiker_customer_app/appStyles/app_images.dart';
import 'package:qwiker_customer_app/appStyles/app_strings.dart';
import 'package:qwiker_customer_app/main.dart';
import 'package:qwiker_customer_app/models/drawer_menu_model.dart';
import 'package:qwiker_customer_app/pages/authentication/login_screen.dart';
import 'package:qwiker_customer_app/pages/drawer/about_screen.dart';
import 'package:qwiker_customer_app/pages/drawer/faq_screen.dart';
import 'package:qwiker_customer_app/pages/drawer/invite_friend/invite_friend_screen.dart';
import 'package:qwiker_customer_app/pages/drawer/make_complaint_screen.dart';
import 'package:qwiker_customer_app/pages/drawer/my_account/my_account_screen.dart';
import 'package:qwiker_customer_app/pages/drawer/notification_screen.dart';
import 'package:qwiker_customer_app/pages/drawer/privacy_policy_screen.dart';
import 'package:qwiker_customer_app/pages/drawer/sos/sos_screen.dart';
import 'package:qwiker_customer_app/pages/drawer/terms_condition_screen.dart';
import 'package:qwiker_customer_app/pages/homepage_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Common {
  static menuBar(BuildContext context, key) {
    return IconButton(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              MediaQuery.of(context).size.height * AppDimensions.borderRadius10,
            ),
            side: BorderSide(
                color: AppColors.alternateWhiteColor,
                width: MediaQuery.of(context).size.height * 0.002),
          ),
        ),
        surfaceTintColor:
            const WidgetStatePropertyAll(AppColors.backgroundColor),
        backgroundColor: const WidgetStatePropertyAll(AppColors.whiteColor),
      ),
      onPressed: () {
        key.currentState!.openDrawer();
      },
      icon: Image.asset(
        AppImages.menu,
        height: MediaQuery.of(context).size.height * 0.016,
      ),
    );
  }

  static backButton(BuildContext context) {
    return IconButton(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              MediaQuery.of(context).size.height * AppDimensions.borderRadius10,
            ),
            side: BorderSide(
                color: AppColors.alternateWhiteColor,
                width: MediaQuery.of(context).size.height * 0.002),
          ),
        ),
        surfaceTintColor:
            const WidgetStatePropertyAll(AppColors.backgroundColor),
        backgroundColor: const WidgetStatePropertyAll(AppColors.whiteColor),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(
        Icons.arrow_back_ios_new_rounded,
        size: MediaQuery.of(context).size.height * 0.02,
        color: AppColors.blackColor,
      ),
    );
  }

  static sideDrawer(BuildContext context, String name) {
    return Drawer(
      backgroundColor: AppColors.blueColor,
      width: MediaQuery.of(context).size.width * 0.8,
      surfaceTintColor: AppColors.blueColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * double.infinity,
            padding: EdgeInsets.all(
              MediaQuery.of(context).size.height * AppDimensions.padding1p5,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Image.asset(
                    AppImages.menu,
                    color: AppColors.whiteColor,
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                CircleAvatar(
                  radius: MediaQuery.of(context).size.height *
                      AppDimensions.borderRadius6p2,
                  backgroundColor: AppColors.whiteColor,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.height *
                          AppDimensions.borderRadius6,
                    ),
                    child: Image.asset(
                      AppImages.user,
                      height: MediaQuery.of(context).size.height * 0.12,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width *
                        AppDimensions.padding5,
                  ),
                  child: Text(
                    name.toString(),
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height *
                          AppDimensions.fontSize20,
                      fontFamily: AppFonts.poppinsBold,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.58,
            width: MediaQuery.of(context).size.width * double.infinity,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: drawerMenuModel.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () {
                    switch (drawerMenuModel[index].menu) {
                      case 'My Account':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyAccountScreen(),
                          ),
                        );
                        break;

                      case 'Invite Friends':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InviteFriendScreen(),
                          ),
                        );
                        break;

                      case 'FAQ':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FaqScreen(),
                          ),
                        );
                        break;

                      case 'SOS':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SosScreen(),
                          ),
                        );
                        break;

                      case 'Make Complaints':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MakeComplaintScreen(),
                          ),
                        );
                        break;

                      case 'Notification':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationScreen(),
                          ),
                        );
                        break;

                      case 'About':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AboutScreen(),
                          ),
                        );
                        break;

                      case 'Privacy Policy':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PrivacyPolicyScreen(),
                          ),
                        );
                        break;

                      case 'Terms & Condition':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TermsConditionScreen(),
                          ),
                        );
                        break;

                      default:
                        'Invalid Condition';
                    }
                  },
                  minTileHeight: MediaQuery.of(context).size.height * 0.05,
                  title: Text(
                    drawerMenuModel[index].menu,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height *
                          AppDimensions.fontSize16,
                      fontFamily: AppFonts.poppinsMedium,
                      color: AppColors.whiteColor,
                    ),
                    textAlign: TextAlign.left,
                  ),
                );
              },
            ),
          ),
          ListTile(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => logoutDialog(context),
              );
            },
            title: Text(
              AppStrings.logoutButton,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height *
                    AppDimensions.fontSize16,
                fontFamily: AppFonts.poppinsMedium,
                color: AppColors.whiteColor,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  static logoutDialog(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.whiteColor,
      surfaceTintColor: AppColors.whiteColor,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * double.infinity,
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(
            MediaQuery.of(context).size.height * AppDimensions.borderRadius30,
          ),
        ),
        padding: EdgeInsets.all(
          MediaQuery.of(context).size.height * AppDimensions.padding6,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppStrings.logout,
              style: TextStyle(
                color: AppColors.blackColor,
                fontFamily: AppFonts.medel,
                fontSize: MediaQuery.of(context).size.height *
                    AppDimensions.fontSize24,
                fontWeight: FontWeight.w800,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () async {
                    FirebaseAuth.instance.signOut();
                    final prefs = await SharedPreferences.getInstance();
                    prefs.remove('UserID');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.04,
                    width: MediaQuery.of(context).size.width * 0.15,
                    decoration: BoxDecoration(
                      color: AppColors.redColor,
                      borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height *
                            AppDimensions.borderRadius10,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        AppStrings.yes,
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontFamily: AppFonts.medel,
                          fontSize: MediaQuery.of(context).size.height *
                              AppDimensions.fontSize20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.04,
                    width: MediaQuery.of(context).size.width * 0.15,
                    decoration: BoxDecoration(
                      color: AppColors.blueColor,
                      borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height *
                            AppDimensions.borderRadius10,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        AppStrings.no,
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontFamily: AppFonts.medel,
                          fontSize: MediaQuery.of(context).size.height *
                              AppDimensions.fontSize20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static deleteDialog(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.whiteColor,
      surfaceTintColor: AppColors.whiteColor,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * double.infinity,
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(
            MediaQuery.of(context).size.height * AppDimensions.borderRadius30,
          ),
        ),
        padding: EdgeInsets.all(
          MediaQuery.of(context).size.height * AppDimensions.padding6,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppStrings.deleteAccount,
              style: TextStyle(
                color: AppColors.blackColor,
                fontFamily: AppFonts.medel,
                fontSize: MediaQuery.of(context).size.height *
                    AppDimensions.fontSize24,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () async {
                    FirebaseAuth.instance.currentUser!.delete();
                    final prefs = await SharedPreferences.getInstance();
                    prefs.remove('UserID');
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .delete();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.04,
                    width: MediaQuery.of(context).size.width * 0.15,
                    decoration: BoxDecoration(
                      color: AppColors.redColor,
                      borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height *
                            AppDimensions.borderRadius10,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        AppStrings.yes,
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontFamily: AppFonts.medel,
                          fontSize: MediaQuery.of(context).size.height *
                              AppDimensions.fontSize20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.04,
                    width: MediaQuery.of(context).size.width * 0.15,
                    decoration: BoxDecoration(
                      color: AppColors.blueColor,
                      borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height *
                            AppDimensions.borderRadius10,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        AppStrings.no,
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontFamily: AppFonts.medel,
                          fontSize: MediaQuery.of(context).size.height *
                              AppDimensions.fontSize20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static rideCancelDialog(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.whiteColor,
      surfaceTintColor: AppColors.whiteColor,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * double.infinity,
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(
            MediaQuery.of(context).size.height * AppDimensions.borderRadius30,
          ),
        ),
        padding: EdgeInsets.all(
          MediaQuery.of(context).size.height * AppDimensions.padding6,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppStrings.cancelRide,
              style: TextStyle(
                color: AppColors.blackColor,
                fontFamily: AppFonts.medel,
                fontSize: MediaQuery.of(context).size.height *
                    AppDimensions.fontSize24,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    FirebaseFirestore.instance
                        .collection('rides')
                        .doc(prefs.getString('docId'))
                        .update({
                      'status': 'Canceled By User',
                    });
                    prefs.remove('docId');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomepageScreen(),
                      ),
                    );
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.04,
                    width: MediaQuery.of(context).size.width * 0.15,
                    decoration: BoxDecoration(
                      color: AppColors.redColor,
                      borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height *
                            AppDimensions.borderRadius10,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        AppStrings.yes,
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontFamily: AppFonts.medel,
                          fontSize: MediaQuery.of(context).size.height *
                              AppDimensions.fontSize20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.04,
                    width: MediaQuery.of(context).size.width * 0.15,
                    decoration: BoxDecoration(
                      color: AppColors.blueColor,
                      borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height *
                            AppDimensions.borderRadius10,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        AppStrings.no,
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontFamily: AppFonts.medel,
                          fontSize: MediaQuery.of(context).size.height *
                              AppDimensions.fontSize20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static timeOut(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width * double.infinity,
      color: AppColors.whiteColor,
      padding: EdgeInsets.all(
        MediaQuery.of(context).size.height * AppDimensions.padding2,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.requestExpired,
            style: TextStyle(
              color: AppColors.blackColor,
              fontFamily: AppFonts.segoeRegular,
              fontSize:
                  MediaQuery.of(context).size.height * AppDimensions.fontSize26,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Text(
            AppStrings.driverNotAvailable,
            style: TextStyle(
              color: AppColors.darkGreyColor,
              fontFamily: AppFonts.segoeRegular,
              fontSize:
                  MediaQuery.of(context).size.height * AppDimensions.fontSize20,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          GestureDetector(
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              prefs.remove('docId');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomepageScreen(),
                ),
              );
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * double.infinity,
              color: AppColors.blackColor,
              child: Center(
                child: Text(
                  AppStrings.ok,
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontFamily: AppFonts.segoeBold,
                    fontSize: MediaQuery.of(context).size.height *
                        AppDimensions.fontSize24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static appBar(
      BuildContext context, String title, Widget leading, Color color) {
    return AppBar(
      backgroundColor: color,
      surfaceTintColor: color,
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.blackColor,
          fontFamily: AppFonts.medel,
          fontSize:
              MediaQuery.of(context).size.height * AppDimensions.fontSize28,
        ),
      ),
      centerTitle: true,
      leading: leading,
      leadingWidth: MediaQuery.of(context).size.width * 0.2,
      toolbarHeight: MediaQuery.of(context).size.height * 0.1,
    );
  }
}
