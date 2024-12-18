import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:qwiker_customer_app/appStyles/app_colors.dart';
import 'package:qwiker_customer_app/appStyles/app_dimensions.dart';
import 'package:qwiker_customer_app/appStyles/app_fonts.dart';
import 'package:qwiker_customer_app/appStyles/app_strings.dart';
import 'package:qwiker_customer_app/common.dart';
import 'package:qwiker_customer_app/pages/homepage_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpVerification extends StatefulWidget {
  const OtpVerification({super.key});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
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
        '',
        Common.backButton(context),
        AppColors.backgroundColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              AppStrings.verificationPageTitle,
              style: TextStyle(
                color: AppColors.blackColor,
                fontFamily: AppFonts.poppinsMedium,
                fontSize: MediaQuery.of(context).size.height *
                    AppDimensions.fontSize20,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Text(
            AppStrings.verificationPageDes,
            style: TextStyle(
              color: AppColors.greyColor,
              fontFamily: AppFonts.poppinsMedium,
              fontSize:
                  MediaQuery.of(context).size.height * AppDimensions.fontSize14,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          PinCodeTextField(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            appContext: context,
            length: 4,
            enableActiveFill: true,
            keyboardType: TextInputType.number,
            pinTheme: PinTheme(
              disabledBorderWidth: MediaQuery.of(context).size.height * 0.002,
              activeBorderWidth: MediaQuery.of(context).size.height * 0.002,
              inactiveFillColor: AppColors.whiteColor,
              selectedFillColor: AppColors.whiteColor,
              activeFillColor: AppColors.whiteColor,
              activeColor: AppColors.blueColor,
              disabledColor: AppColors.alternateWhiteColor,
              selectedColor: AppColors.alternateWhiteColor,
              inactiveColor: AppColors.alternateWhiteColor,
              fieldHeight: MediaQuery.of(context).size.height * 0.066,
              fieldWidth: MediaQuery.of(context).size.width * 0.14,
              shape: PinCodeFieldShape.box,
              borderWidth: MediaQuery.of(context).size.width * 0.1,
              borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.height *
                    AppDimensions.borderRadius10,
              ),
            ),
            onCompleted: (v) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomepageScreen(),
                ),
              );
            },
            beforeTextPaste: (text) {
              return true;
            },
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: AppStrings.notReceiveCode,
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: MediaQuery.of(context).size.height *
                        AppDimensions.fontSize16,
                    fontFamily: AppFonts.poppinsMedium,
                  ),
                ),
                TextSpan(
                  text: AppStrings.resend,
                  style: TextStyle(
                    color: AppColors.blueColor,
                    fontSize: MediaQuery.of(context).size.height *
                        AppDimensions.fontSize16,
                    fontFamily: AppFonts.poppinsBold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
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
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.85,
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
                  AppStrings.verifyNowButton,
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
