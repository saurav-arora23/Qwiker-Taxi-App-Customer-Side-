import 'package:flutter/material.dart';
import 'package:qwiker_customer_app/appStyles/app_colors.dart';
import 'package:qwiker_customer_app/appStyles/app_dimensions.dart';
import 'package:qwiker_customer_app/appStyles/app_fonts.dart';
import 'package:qwiker_customer_app/appStyles/app_strings.dart';
import 'package:qwiker_customer_app/models/language_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeLanguageScreen extends StatefulWidget {
  const ChangeLanguageScreen({super.key});

  @override
  State<ChangeLanguageScreen> createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
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
      backgroundColor: Colors.transparent,
      body: Container(
        padding: EdgeInsets.all(
          MediaQuery.of(context).size.height * AppDimensions.padding2,
        ),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(
              MediaQuery.of(context).size.height * AppDimensions.borderRadius28,
            ),
            topRight: Radius.circular(
              MediaQuery.of(context).size.height * AppDimensions.borderRadius28,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.selectLanguageTitle,
              style: TextStyle(
                fontFamily: AppFonts.poppinsMedium,
                fontSize: MediaQuery.of(context).size.height *
                    AppDimensions.fontSize20,
                color: AppColors.blackColor,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.537,
              width: MediaQuery.of(context).size.width * double.infinity,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: languageModel.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      for (int i = 0; i < languageModel.length; i++) {
                        languageModel[i].languageSelected = false;
                        setState(() {});
                      }
                      languageModel[index].languageSelected =
                          !languageModel[index].languageSelected;
                      setState(() {});
                    },
                    minTileHeight: MediaQuery.of(context).size.height * 0.048,
                    leading: languageModel[index].languageSelected == true
                        ? Container(
                            width: MediaQuery.of(context).size.width * 0.06,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.blueColor),
                              color: AppColors.whiteColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.circle_rounded,
                                size: MediaQuery.of(context).size.height * 0.02,
                                color: AppColors.blueColor,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.circle_outlined,
                            size: MediaQuery.of(context).size.height * 0.028,
                            color: AppColors.lightPurpleColor,
                          ),
                    title: Text(
                      languageModel[index].language,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height *
                            AppDimensions.fontSize16,
                        fontFamily: AppFonts.poppinsMedium,
                        color: languageModel[index].languageSelected == true
                            ? AppColors.blueColor
                            : AppColors.blackColor,
                      ),
                    ),
                  );
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
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
                    AppStrings.saveButton,
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
    );
  }
}
