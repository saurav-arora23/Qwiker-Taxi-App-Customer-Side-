import 'package:flutter/material.dart';
import 'package:qwiker_customer_app/appStyles/app_colors.dart';
import 'package:qwiker_customer_app/appStyles/app_dimensions.dart';
import 'package:qwiker_customer_app/appStyles/app_fonts.dart';
import 'package:qwiker_customer_app/appStyles/app_images.dart';
import 'package:qwiker_customer_app/appStyles/app_strings.dart';
import 'package:qwiker_customer_app/models/payment_method_model.dart';
import 'package:qwiker_customer_app/pages/drawer/my_account/quick_links/wallet/add_money_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectPaymentMethodScreen extends StatefulWidget {
  const SelectPaymentMethodScreen({super.key});

  @override
  State<SelectPaymentMethodScreen> createState() =>
      _SelectPaymentMethodScreenState();
}

class _SelectPaymentMethodScreenState extends State<SelectPaymentMethodScreen> {
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
              AppStrings.selectPaymentMethodTitle,
              style: TextStyle(
                fontFamily: AppFonts.poppinsMedium,
                fontSize: MediaQuery.of(context).size.height *
                    AppDimensions.fontSize20,
                color: AppColors.blackColor,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * double.infinity,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 8 / 3,
                  mainAxisSpacing: MediaQuery.of(context).size.height * 0.02,
                  crossAxisSpacing: MediaQuery.of(context).size.height * 0.02,
                ),
                shrinkWrap: true,
                itemCount: selectPaymentMethodModel.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      for (int i = 0;
                          i < selectPaymentMethodModel.length;
                          i++) {
                        selectPaymentMethodModel[i].paymentMethodSelected =
                            false;
                        setState(() {});
                      }
                      selectPaymentMethodModel[index].paymentMethodSelected =
                          !selectPaymentMethodModel[index]
                              .paymentMethodSelected;
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.height *
                              AppDimensions.borderRadius12,
                        ),
                        border: Border.all(
                          color: selectPaymentMethodModel[index]
                                      .paymentMethodSelected ==
                                  true
                              ? AppColors.blueColor
                              : AppColors.alternateMediumWhiteColor,
                          width: MediaQuery.of(context).size.width * 0.005,
                        ),
                      ),
                      padding: EdgeInsets.all(
                        MediaQuery.of(context).size.height *
                            AppDimensions.padding1,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          selectPaymentMethodModel[index]
                                      .paymentMethodSelected ==
                                  true
                              ? Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.06,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.blueColor,
                                      ),
                                      color: AppColors.whiteColor,
                                      shape: BoxShape.circle),
                                  child: Center(
                                    child: Icon(
                                      Icons.circle_rounded,
                                      size: MediaQuery.of(context).size.height *
                                          0.02,
                                      color: AppColors.blueColor,
                                    ),
                                  ),
                                )
                              : Icon(
                                  Icons.circle_outlined,
                                  size: MediaQuery.of(context).size.height *
                                      0.028,
                                  color: AppColors.alternateLightGreyColor,
                                ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.015),
                          Image.asset(
                            selectPaymentMethodModel[index].paymentMethodImage,
                            height: selectPaymentMethodModel[index]
                                        .paymentMethodImage ==
                                    AppImages.stripe
                                ? MediaQuery.of(context).size.height * 0.038
                                : MediaQuery.of(context).size.height * 0.02,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  scrollControlDisabledMaxHeightRatio: 0.9 / 3,
                  context: context,
                  builder: (context) => const AddMoneyScreen(),
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
                    AppStrings.nextButton,
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
