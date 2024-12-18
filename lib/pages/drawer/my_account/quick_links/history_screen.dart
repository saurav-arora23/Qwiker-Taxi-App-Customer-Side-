import 'package:flutter/material.dart';
import 'package:qwiker_customer_app/appStyles/app_colors.dart';
import 'package:qwiker_customer_app/appStyles/app_dimensions.dart';
import 'package:qwiker_customer_app/appStyles/app_fonts.dart';
import 'package:qwiker_customer_app/appStyles/app_strings.dart';
import 'package:qwiker_customer_app/common.dart';
import 'package:qwiker_customer_app/models/history_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
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
        AppStrings.historyTitle,
        Common.backButton(context),
        AppColors.backgroundColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.height * AppDimensions.padding2,
          right: MediaQuery.of(context).size.height * AppDimensions.padding2,
        ),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: historyModel.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 5,
              color: AppColors.whiteColor,
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height *
                      AppDimensions.padding3),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.21,
                width: MediaQuery.of(context).size.width * double.infinity,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height *
                      AppDimensions.padding2,
                  left: MediaQuery.of(context).size.height *
                      AppDimensions.padding1,
                  right: MediaQuery.of(context).size.height *
                      AppDimensions.padding1,
                  bottom: MediaQuery.of(context).size.height *
                      AppDimensions.padding2,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height *
                        AppDimensions.borderRadius28,
                  ),
                  color: AppColors.whiteColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.035,
                      width: MediaQuery.of(context).size.width * 0.22,
                      margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.height *
                            AppDimensions.padding1p5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.height *
                              AppDimensions.borderRadius28,
                        ),
                        border: Border.all(
                          color: historyModel[index].rideStatus == 'Cancel'
                              ? AppColors.redColor.withOpacity(0.3)
                              : AppColors.greenColor.withOpacity(0.3),
                        ),
                        color: historyModel[index].rideStatus == 'Cancel'
                            ? AppColors.redColor.withOpacity(0.15)
                            : AppColors.greenColor.withOpacity(0.15),
                      ),
                      child: Center(
                        child: Text(
                          historyModel[index].rideStatus,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height *
                                AppDimensions.fontSize14,
                            fontFamily: AppFonts.poppinsMedium,
                            color: historyModel[index].rideStatus == 'Cancel'
                                ? AppColors.redColor
                                : AppColors.greenColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02),
                        Stack(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.03,
                              width: MediaQuery.of(context).size.width * 0.035,
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
                                  MediaQuery.of(context).size.height * 0.0035,
                              left: MediaQuery.of(context).size.height * 0.0035,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                                width: MediaQuery.of(context).size.width * 0.02,
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
                            width: MediaQuery.of(context).size.width * 0.02),
                        Text(
                          historyModel[index].pickUpLocation,
                          style: TextStyle(
                            fontFamily: AppFonts.poppinsMedium,
                            fontSize: MediaQuery.of(context).size.height *
                                AppDimensions.fontSize12,
                            color: AppColors.blackColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02),
                        Stack(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.03,
                              width: MediaQuery.of(context).size.width * 0.035,
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                border: Border.all(
                                  color: AppColors.lightWhiteColor,
                                  width:
                                      MediaQuery.of(context).size.width * 0.004,
                                ),
                                borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height *
                                      AppDimensions.borderRadius39,
                                ),
                              ),
                            ),
                            Positioned(
                              top: MediaQuery.of(context).size.height * 0.0035,
                              left: MediaQuery.of(context).size.height * 0.0035,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                                width: MediaQuery.of(context).size.width * 0.02,
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
                            width: MediaQuery.of(context).size.width * 0.02),
                        Text(
                          historyModel[index].dropLocation,
                          style: TextStyle(
                            fontFamily: AppFonts.poppinsMedium,
                            fontSize: MediaQuery.of(context).size.height *
                                AppDimensions.fontSize12,
                            color: AppColors.blackColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02),
                        Text(
                          historyModel[index].rideFare,
                          style: TextStyle(
                            fontFamily: AppFonts.poppinsBold,
                            fontSize: MediaQuery.of(context).size.height *
                                AppDimensions.fontSize24,
                            color: AppColors.blueColor,
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.56),
                        Text(
                          historyModel[index].rideDate,
                          style: TextStyle(
                            fontFamily: AppFonts.poppinsMedium,
                            fontSize: MediaQuery.of(context).size.height *
                                AppDimensions.fontSize14,
                            color: AppColors.textGreyColor,
                          ),
                        ),
                      ],
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
