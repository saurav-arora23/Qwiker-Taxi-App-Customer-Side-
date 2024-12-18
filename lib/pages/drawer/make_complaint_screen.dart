import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qwiker_customer_app/appStyles/app_colors.dart';
import 'package:qwiker_customer_app/appStyles/app_dimensions.dart';
import 'package:qwiker_customer_app/appStyles/app_fonts.dart';
import 'package:qwiker_customer_app/appStyles/app_images.dart';
import 'package:qwiker_customer_app/appStyles/app_strings.dart';
import 'package:qwiker_customer_app/common.dart';
import 'package:qwiker_customer_app/pages/homepage_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MakeComplaintScreen extends StatefulWidget {
  const MakeComplaintScreen({super.key});

  @override
  State<MakeComplaintScreen> createState() => _MakeComplaintScreenState();
}

class _MakeComplaintScreenState extends State<MakeComplaintScreen> {
  String? dropDownValue = "Select Problem";
  var items = ['Select Problem', 'Vehicle Not Clean', 'Driver Problem'];

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
        AppStrings.complaintsTitle,
        Common.backButton(context),
        AppColors.backgroundColor,
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(
            MediaQuery.of(context).size.height * AppDimensions.padding2),
        child: GestureDetector(
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
            width: MediaQuery.of(context).size.width * 0.9,
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
                AppStrings.submitButton,
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
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SvgPicture.asset(
                AppImages.complaintScreen,
                height: MediaQuery.of(context).size.height * 0.2,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.06),
            Container(
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.only(
                left:
                    MediaQuery.of(context).size.height * AppDimensions.padding2,
                right:
                    MediaQuery.of(context).size.height * AppDimensions.padding2,
              ),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                border: Border.all(
                  width: MediaQuery.of(context).size.width * 0.003,
                  color: AppColors.alternateWhiteColor,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    MediaQuery.of(context).size.height *
                        AppDimensions.borderRadius28,
                  ),
                ),
              ),
              child: DropdownButton(
                isExpanded: true,
                focusColor: AppColors.whiteColor,
                dropdownColor: AppColors.whiteColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    MediaQuery.of(context).size.height *
                        AppDimensions.borderRadius20,
                  ),
                ),
                value: dropDownValue ?? "",
                underline: const SizedBox(),
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  size: MediaQuery.of(context).size.height * 0.03,
                  color: AppColors.blackColor,
                ),
                items: items.map((String? items) {
                  return DropdownMenuItem(
                    value: items ?? "",
                    child: Text(
                      items ?? "",
                      style: TextStyle(
                        fontFamily: AppFonts.poppinsRegular,
                        color: AppColors.blackColor,
                        fontSize: MediaQuery.of(context).size.height *
                            AppDimensions.fontSize14,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    dropDownValue = newValue;
                  });
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.all(
                MediaQuery.of(context).size.height * AppDimensions.padding1,
              ),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                border: Border.all(
                  width: MediaQuery.of(context).size.width * 0.003,
                  color: AppColors.alternateWhiteColor,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    MediaQuery.of(context).size.height *
                        AppDimensions.borderRadius28,
                  ),
                ),
              ),
              child: TextField(
                cursorColor: AppColors.mediumGreyColor,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height *
                      AppDimensions.fontSize14,
                  color: AppColors.blackColor,
                  fontFamily: AppFonts.poppinsMedium,
                ),
                maxLines: 9,
                decoration: InputDecoration(
                  hintText: AppStrings.complaintBox,
                  hintStyle: TextStyle(
                    fontSize: MediaQuery.of(context).size.height *
                        AppDimensions.fontSize14,
                    color: AppColors.mediumGreyColor,
                    fontFamily: AppFonts.poppinsMedium,
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(style: BorderStyle.none),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      style: BorderStyle.none,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      style: BorderStyle.none,
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
