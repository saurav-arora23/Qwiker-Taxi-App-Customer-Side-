import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:qwiker_customer_app/appStyles/app_colors.dart';
import 'package:qwiker_customer_app/appStyles/app_dimensions.dart';
import 'package:qwiker_customer_app/appStyles/app_fonts.dart';
import 'package:qwiker_customer_app/appStyles/app_images.dart';
import 'package:qwiker_customer_app/appStyles/app_strings.dart';
import 'package:qwiker_customer_app/common.dart';
import 'package:qwiker_customer_app/models/tip_model.dart';
import 'package:qwiker_customer_app/pages/homepage_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
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
        AppStrings.ratingTitle,
        Common.backButton(context),
        AppColors.backgroundColor,
      ),
      body: Stack(
        children: [
          Center(
            child: Card(
              color: AppColors.backgroundColor,
              elevation: 5,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.687,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.height *
                          AppDimensions.borderRadius28),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    Text(
                      AppStrings.driverName,
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontFamily: AppFonts.poppinsMedium,
                        fontSize: MediaQuery.of(context).size.height *
                            AppDimensions.fontSize20,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Volkswagen  - ',
                            style: TextStyle(
                                fontFamily: AppFonts.poppinsMedium,
                                fontSize: MediaQuery.of(context).size.height *
                                    AppDimensions.fontSize14,
                                color: AppColors.mediumGreyColor), //
                          ),
                          TextSpan(
                            text: 'HG5045',
                            style: TextStyle(
                                fontFamily: AppFonts.poppinsBold,
                                fontSize: MediaQuery.of(context).size.height *
                                    AppDimensions.fontSize14,
                                color: AppColors.blackColor), //
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    Text(
                      AppStrings.ratingDes1,
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontFamily: AppFonts.poppinsMedium,
                        fontSize: MediaQuery.of(context).size.height *
                            AppDimensions.fontSize20,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    RatingBar(
                      allowHalfRating: true,
                      initialRating: 1,
                      ratingWidget: RatingWidget(
                        full: Icon(
                          Icons.star_rate_rounded,
                          size: MediaQuery.of(context).size.height * 0.03,
                          color: AppColors.yellowColor,
                        ),
                        half: Icon(
                          Icons.star_half_rounded,
                          size: MediaQuery.of(context).size.height * 0.03,
                          color: AppColors.yellowColor,
                        ),
                        empty: Icon(
                          Icons.star_rate_rounded,
                          size: MediaQuery.of(context).size.height * 0.03,
                          color: AppColors.mediumWhiteColor,
                        ),
                      ),
                      onRatingUpdate: (value) => value,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.055,
                      width: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.height *
                              AppDimensions.borderRadius28,
                        ),
                        border: Border.all(
                          color: AppColors.alternateWhiteColor,
                        ),
                      ),
                      child: TextFormField(
                        style: TextStyle(
                          fontFamily: AppFonts.poppinsMedium,
                          fontSize: MediaQuery.of(context).size.height *
                              AppDimensions.fontSize14,
                          color: AppColors.blackColor,
                        ),
                        cursorColor: AppColors.textGreyColor,
                        decoration: InputDecoration(
                          hintText: AppStrings.additionalComments,
                          hintStyle: TextStyle(
                            fontFamily: AppFonts.poppinsMedium,
                            fontSize: MediaQuery.of(context).size.height *
                                AppDimensions.fontSize14,
                            color: AppColors.greyColor,
                          ),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          disabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    Text(
                      AppStrings.ratingDes2,
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontFamily: AppFonts.poppinsMedium,
                        fontSize: MediaQuery.of(context).size.height *
                            AppDimensions.fontSize20,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.08,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Center(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: tipModel.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                for (int i = 0; i < tipModel.length; i++) {
                                  tipModel[i].tipSelected = false;
                                  setState(() {});
                                }
                                tipModel[index].tipSelected =
                                    !tipModel[index].tipSelected;
                                setState(() {});
                              },
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                width: MediaQuery.of(context).size.width * 0.18,
                                decoration: BoxDecoration(
                                  color: tipModel[index].tipSelected == true
                                      ? AppColors.blueColor
                                      : AppColors.ultraLightWhiteColor,
                                  borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.height *
                                        AppDimensions.borderRadius18,
                                  ),
                                ),
                                margin: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.05),
                                child: Center(
                                  child: Text(
                                    tipModel[index].tipPrice,
                                    style: TextStyle(
                                      color: tipModel[index].tipSelected
                                          ? AppColors.whiteColor
                                          : AppColors.blackColor,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              AppDimensions.fontSize20,
                                      fontFamily: AppFonts.poppinsMedium,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        AppStrings.addCustom,
                        style: TextStyle(
                          color: AppColors.blueColor,
                          fontFamily: AppFonts.poppinsMedium,
                          fontSize: MediaQuery.of(context).size.height *
                              AppDimensions.fontSize16,
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomepageScreen(),
                          ),
                        );
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.055,
                        width: MediaQuery.of(context).size.width * 0.7,
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
                            AppStrings.submitReviewButton,
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
          ),
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.height *
                      AppDimensions.borderRadius50,
                ),
                child: Image.asset(
                  AppImages.driver,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
