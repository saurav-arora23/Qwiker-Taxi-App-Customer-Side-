import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qwiker_customer_app/appStyles/app_colors.dart';
import 'package:qwiker_customer_app/appStyles/app_dimensions.dart';
import 'package:qwiker_customer_app/appStyles/app_fonts.dart';
import 'package:qwiker_customer_app/appStyles/app_images.dart';
import 'package:qwiker_customer_app/appStyles/app_strings.dart';
import 'package:qwiker_customer_app/common.dart';
import 'package:qwiker_customer_app/models/contact_model.dart';
import 'package:qwiker_customer_app/pages/drawer/invite_friend/view_all_contact.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InviteFriendShareScreen extends StatefulWidget {
  const InviteFriendShareScreen({super.key});

  @override
  State<InviteFriendShareScreen> createState() =>
      _InviteFriendShareScreenState();
}

class _InviteFriendShareScreenState extends State<InviteFriendShareScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: Common.appBar(
        context,
        AppStrings.inviteFriendsTitle,
        Common.backButton(context),
        AppColors.backgroundColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.22,
            width: MediaQuery.of(context).size.width * double.infinity,
            color: AppColors.blueColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.height * 0.22,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.referEarn,
                        style: TextStyle(
                          fontFamily: AppFonts.poppinsBold,
                          fontSize: MediaQuery.of(context).size.height *
                              AppDimensions.fontSize24,
                          color: AppColors.whiteColor,
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      Text(
                        AppStrings.inviteFriendDes2,
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: MediaQuery.of(context).size.height *
                              AppDimensions.fontSize16,
                          fontFamily: AppFonts.poppinsMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                SvgPicture.asset(
                  AppImages.inviteFriendGift,
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.21,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.inviteButton,
                  style: TextStyle(
                    fontFamily: AppFonts.poppinsBold,
                    fontSize: MediaQuery.of(context).size.height *
                        AppDimensions.fontSize16,
                    color: AppColors.blackColor,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    sharingPlatforms(AppImages.whatsapp, AppStrings.whatsapp),
                    sharingPlatforms(AppImages.messenger, AppStrings.messenger),
                    sharingPlatforms(AppImages.instagram, AppStrings.instagram),
                    sharingPlatforms(AppImages.copyLink, AppStrings.copyLink),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                const Divider(
                  color: AppColors.alternateWhiteColor,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.suggestedContact,
                      style: TextStyle(
                        fontFamily: AppFonts.poppinsBold,
                        fontSize: MediaQuery.of(context).size.height *
                            AppDimensions.fontSize16,
                        color: AppColors.blackColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ViewAllContact(),
                          ),
                        );
                      },
                      child: Text(
                        AppStrings.viewAll,
                        style: TextStyle(
                          fontFamily: AppFonts.poppinsMedium,
                          fontSize: MediaQuery.of(context).size.height *
                              AppDimensions.fontSize14,
                          color: AppColors.textGreyColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.9,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 6,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                    contactModel[index].contactName,
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: MediaQuery.of(context).size.height *
                          AppDimensions.fontSize16,
                      fontFamily: AppFonts.poppinsMedium,
                    ),
                  ),
                  leading: Container(
                    height: MediaQuery.of(context).size.height * 0.04,
                    width: MediaQuery.of(context).size.width * 0.08,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.lightWhiteColor,
                    ),
                    child: Center(
                      child: Text(
                        contactModel[index].contactProfile,
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: MediaQuery.of(context).size.height *
                              AppDimensions.fontSize14,
                          fontFamily: AppFonts.poppinsMedium,
                        ),
                      ),
                    ),
                  ),
                  trailing: TextButton(
                    onPressed: () {
                      if (contactModel[index].contactInvited == true) {
                        setState(() {
                          contactModel[index].contactInvited = false;
                        });
                      } else {
                        setState(() {
                          contactModel[index].contactInvited = true;
                        });
                      }
                    },
                    child: Text(
                      contactModel[index].contactInvited == true
                          ? 'Invited'
                          : AppStrings.inviteButton,
                      style: TextStyle(
                        color: contactModel[index].contactInvited == true
                            ? AppColors.textGreyColor
                            : AppColors.blueColor,
                        fontSize: MediaQuery.of(context).size.height *
                            AppDimensions.fontSize16,
                        fontFamily: AppFonts.poppinsMedium,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget sharingPlatforms(String platformImage, String platformName) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          platformImage,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        Text(
          platformName,
          style: TextStyle(
            color: AppColors.lightBlackColor,
            fontFamily: AppFonts.poppinsMedium,
            fontSize:
                MediaQuery.of(context).size.height * AppDimensions.fontSize12,
          ),
        )
      ],
    );
  }
}
