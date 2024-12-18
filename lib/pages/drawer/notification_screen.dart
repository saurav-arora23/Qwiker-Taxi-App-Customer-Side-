import 'package:flutter/material.dart';
import 'package:qwiker_customer_app/appStyles/app_colors.dart';
import 'package:qwiker_customer_app/appStyles/app_dimensions.dart';
import 'package:qwiker_customer_app/appStyles/app_fonts.dart';
import 'package:qwiker_customer_app/appStyles/app_strings.dart';
import 'package:qwiker_customer_app/common.dart';
import 'package:qwiker_customer_app/models/notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

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
        AppStrings.notificationTitle,
        Common.backButton(context),
        AppColors.backgroundColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(
          MediaQuery.of(context).size.height * AppDimensions.padding1,
        ),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: notificationModel.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              color: AppColors.backgroundColor,
              margin: EdgeInsets.only(
                bottom:
                    MediaQuery.of(context).size.height * AppDimensions.padding2,
              ),
              elevation: 5,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.082,
                width: MediaQuery.of(context).size.width * double.infinity,
                decoration: BoxDecoration(
                  color: notificationModel[index].notificationSeen == true
                      ? AppColors.whiteColor.withOpacity(0.7)
                      : AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.height *
                          AppDimensions.borderRadius28),
                ),
                padding: EdgeInsets.all(
                  MediaQuery.of(context).size.height * AppDimensions.padding1p5,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notificationModel[index].notificationTitle,
                      style: TextStyle(
                        color: notificationModel[index].notificationSeen == true
                            ? AppColors.textGreyColor
                            : AppColors.blackColor,
                        fontFamily: AppFonts.poppinsBold,
                        fontSize: MediaQuery.of(context).size.height *
                            AppDimensions.fontSize18,
                      ),
                    ),
                    Text(
                      notificationModel[index].notificationDes,
                      style: TextStyle(
                        color: notificationModel[index].notificationSeen == true
                            ? AppColors.textGreyColor
                            : AppColors.blackColor,
                        fontFamily: AppFonts.poppinsMedium,
                        fontSize: MediaQuery.of(context).size.height *
                            AppDimensions.fontSize18,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
