import 'package:flutter/material.dart';
import 'package:qwiker_customer_app/appStyles/app_colors.dart';
import 'package:qwiker_customer_app/appStyles/app_dimensions.dart';
import 'package:qwiker_customer_app/appStyles/app_fonts.dart';
import 'package:qwiker_customer_app/appStyles/app_strings.dart';
import 'package:qwiker_customer_app/common.dart';
import 'package:qwiker_customer_app/models/on_boarding_model.dart';
import 'package:qwiker_customer_app/pages/onBoarding/location_permission.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({super.key});

  @override
  State<OnBoard> createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  int currentIndex = 0;
  late PageController controller;

  @override
  void initState() {
    controller = PageController(initialPage: 0);
    super.initState();
  }

  void onPageChanged(int index) {
    currentIndex = index;
    setState(() {});
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: Common.appBar(
        context,
        '',
        Container(),
        AppColors.backgroundColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: PageView.builder(
              controller: controller,
              scrollDirection: Axis.horizontal,
              itemCount: contents.length,
              onPageChanged: (int index) {
                onPageChanged(index);
              },
              itemBuilder: (_, i) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(
                        MediaQuery.of(context).size.height *
                            AppDimensions.padding4,
                      ),
                      child: Column(
                        children: [
                          Text(
                            contents[i].name,
                            style: TextStyle(
                              fontFamily: AppFonts.medel,
                              fontSize: MediaQuery.of(context).size.height *
                                  AppDimensions.fontSize42,
                              color: AppColors.blackColor,
                            ),
                            textAlign: TextAlign.center, //
                          ),
                          Text(
                            contents[i].des,
                            style: TextStyle(
                              fontFamily: AppFonts.poppinsRegular,
                              fontSize: MediaQuery.of(context).size.height *
                                  AppDimensions.fontSize16,
                              color: AppColors.darkGreyColor,
                            ),
                            textAlign: TextAlign.center, //
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    SizedBox(
                      width:
                          MediaQuery.of(context).size.width * double.infinity,
                      child: Image.asset(
                        contents[i].image,
                        height: currentIndex == 0
                            ? MediaQuery.of(context).size.height * 0.2894
                            : currentIndex == 1
                                ? MediaQuery.of(context).size.height * 0.38706
                                : MediaQuery.of(context).size.height * 0.29712,
                        fit: currentIndex == 0
                            ? BoxFit.contain
                            : currentIndex == 1
                                ? BoxFit.fitWidth
                                : BoxFit.contain,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
          GestureDetector(
            onTap: () {
              if (currentIndex == contents.length - 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LocationPermission(),
                  ),
                );
              }
              controller.nextPage(
                duration: const Duration(milliseconds: 10),
                curve: Curves.bounceIn,
              );
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.055,
              width: MediaQuery.of(context).size.width * 0.45,
              decoration: BoxDecoration(
                color: AppColors.blueColor,
                borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.height *
                      AppDimensions.borderRadius4,
                ),
              ),
              child: Center(
                child: Text(
                  AppStrings.getStartedButton,
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
    );
  }
}
