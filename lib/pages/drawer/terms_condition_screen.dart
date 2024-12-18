import 'package:flutter/material.dart';
import 'package:qwiker_customer_app/appStyles/app_colors.dart';
import 'package:qwiker_customer_app/appStyles/app_dimensions.dart';
import 'package:qwiker_customer_app/appStyles/app_fonts.dart';
import 'package:qwiker_customer_app/appStyles/app_strings.dart';
import 'package:qwiker_customer_app/common.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TermsConditionScreen extends StatefulWidget {
  const TermsConditionScreen({super.key});

  @override
  State<TermsConditionScreen> createState() => _TermsConditionScreenState();
}

class _TermsConditionScreenState extends State<TermsConditionScreen> {
  bool isCheck = false;

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
        AppStrings.termsConditionTitle,
        Common.backButton(context),
        AppColors.backgroundColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(
          MediaQuery.of(context).size.height * AppDimensions.padding2,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.termsConditionTitle,
              style: TextStyle(
                fontFamily: AppFonts.poppinsBold,
                fontSize: MediaQuery.of(context).size.height *
                    AppDimensions.fontSize16,
                color: AppColors.blackColor,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Text(
              '${AppStrings.termsConditionDes}\n\n${AppStrings.termsConditionDes}',
              style: TextStyle(
                fontFamily: AppFonts.poppinsMedium,
                fontSize: MediaQuery.of(context).size.height *
                    AppDimensions.fontSize14,
                color: AppColors.mediumGreyColor,
              ),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                  value: isCheck,
                  checkColor: AppColors.whiteColor,
                  activeColor: AppColors.greenColor,
                  onChanged: (bool? value) {
                    setState(() {
                      isCheck = value!;
                    });
                  },
                ),
                Text(
                  AppStrings.acceptTermsCondition,
                  style: TextStyle(
                    fontFamily: AppFonts.poppinsMedium,
                    fontSize: MediaQuery.of(context).size.height *
                        AppDimensions.fontSize16,
                    color: AppColors.blackColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
