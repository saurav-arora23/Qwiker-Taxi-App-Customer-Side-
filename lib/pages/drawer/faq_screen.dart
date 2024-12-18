import 'package:flutter/material.dart';
import 'package:qwiker_customer_app/appStyles/app_colors.dart';
import 'package:qwiker_customer_app/appStyles/app_dimensions.dart';
import 'package:qwiker_customer_app/appStyles/app_fonts.dart';
import 'package:qwiker_customer_app/appStyles/app_strings.dart';
import 'package:qwiker_customer_app/common.dart';
import 'package:qwiker_customer_app/models/faq_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {

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
        AppStrings.faqTitle,
        Common.backButton(context),
        AppColors.backgroundColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(
          MediaQuery.of(context).size.height * AppDimensions.padding1,
        ),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: faqModel.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      faqModel[index].question,
                      style: TextStyle(
                        fontFamily: AppFonts.poppinsMedium,
                        fontSize: MediaQuery.of(context).size.height *
                            AppDimensions.fontSize16,
                        color: faqModel[index].selected == true
                            ? AppColors.blueColor
                            : AppColors.blackColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        for (int i = 0; i < faqModel.length; i++) {
                          faqModel[i].selected = false;
                          setState(() {});
                        }
                        faqModel[index].selected = !faqModel[index].selected;
                        setState(() {});
                      },
                      icon: faqModel[index].selected == true
                          ? Icon(
                              Icons.remove,
                              color: AppColors.darkGreyColor,
                              size: MediaQuery.of(context).size.height * 0.028,
                            )
                          : Icon(
                              Icons.add,
                              color: AppColors.blueColor,
                              size: MediaQuery.of(context).size.height * 0.028,
                            ),
                    ),
                  ],
                ),
                if (faqModel[index].selected == true)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Text(
                      faqModel[index].answer,
                      style: TextStyle(
                        color: AppColors.mediumTextGreyColor,
                        fontSize: MediaQuery.of(context).size.height *
                            AppDimensions.fontSize14,
                        fontFamily: AppFonts.poppinsMedium,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                Divider(
                  color: AppColors.textGreyColor,
                  endIndent: MediaQuery.of(context).size.width * 0.03,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
