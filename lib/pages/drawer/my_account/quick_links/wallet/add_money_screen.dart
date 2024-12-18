import 'package:flutter/material.dart';
import 'package:qwiker_customer_app/appStyles/app_colors.dart';
import 'package:qwiker_customer_app/appStyles/app_dimensions.dart';
import 'package:qwiker_customer_app/appStyles/app_fonts.dart';
import 'package:qwiker_customer_app/appStyles/app_strings.dart';
import 'package:qwiker_customer_app/models/tip_model.dart';
import 'package:qwiker_customer_app/models/wallet_transaction_history_model.dart';
import 'package:qwiker_customer_app/pages/drawer/my_account/quick_links/wallet/wallet_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  int amount = 0;

  String? userId;

  getId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('UserID');
    getAmount();
  }

  getAmount() {
    for (int i = 0; i < addMoneyModel.length; i++) {
      if (addMoneyModel[i].amountSelected == true) {
        amount = addMoneyModel[i].amount;
      }
    }
    setState(() {});
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
              AppStrings.addMoneyButton,
              style: TextStyle(
                fontFamily: AppFonts.poppinsMedium,
                fontSize: MediaQuery.of(context).size.height *
                    AppDimensions.fontSize20,
                color: AppColors.blackColor,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Container(
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.9,
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
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'TZS$amount',
                  hintStyle: TextStyle(
                    fontFamily: AppFonts.poppinsMedium,
                    fontSize: MediaQuery.of(context).size.height *
                        AppDimensions.fontSize14,
                    color: AppColors.blackColor,
                  ),
                  suffix: Text(
                    'TZS',
                    style: TextStyle(
                      fontFamily: AppFonts.poppinsBold,
                      fontSize: MediaQuery.of(context).size.height *
                          AppDimensions.fontSize14,
                      color: AppColors.blueColor,
                    ),
                  ),
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                  enabledBorder:
                      const OutlineInputBorder(borderSide: BorderSide.none),
                  disabledBorder:
                      const OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                      const OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.033,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: addMoneyModel.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      for (int i = 0; i < addMoneyModel.length; i++) {
                        addMoneyModel[i].amountSelected = false;
                        setState(() {});
                      }
                      addMoneyModel[index].amountSelected =
                          !addMoneyModel[index].amountSelected;
                      getAmount();
                      setState(() {});
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.033,
                      width: MediaQuery.of(context).size.width * 0.18,
                      decoration: BoxDecoration(
                        color: addMoneyModel[index].amountSelected == true
                            ? AppColors.blueColor
                            : AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.height *
                              AppDimensions.borderRadius10,
                        ),
                        border: Border.all(
                          color: addMoneyModel[index].amountSelected == true
                              ? AppColors.blueColor
                              : AppColors.lightGreyColor,
                        ),
                      ),
                      margin: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.025,
                      ),
                      child: Center(
                        child: Text(
                          'TZS${addMoneyModel[index].amount}',
                          style: TextStyle(
                            color: addMoneyModel[index].amountSelected
                                ? AppColors.whiteColor
                                : AppColors.textGreyColor,
                            fontSize: MediaQuery.of(context).size.height *
                                AppDimensions.fontSize12,
                            fontFamily: AppFonts.poppinsMedium,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.038),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * 0.38,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height *
                            AppDimensions.borderRadius28,
                      ),
                      border: Border.all(
                        color: AppColors.redColor,
                        width: MediaQuery.of(context).size.width * 0.005,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        AppStrings.cancel,
                        style: TextStyle(
                          color: AppColors.redColor,
                          fontSize: MediaQuery.of(context).size.height *
                              AppDimensions.fontSize18,
                          fontFamily: AppFonts.poppinsMedium,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      walletTransactionHistoryModel.add(
                        WalletTransactionHistoryModel(
                          AppStrings.moneyDeposited,
                          amount,
                          '14th Sep 03:00 PM',
                        ),
                      );
                    });
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WalletScreen(),
                      ),
                    );
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * 0.48,
                    decoration: BoxDecoration(
                      color: AppColors.blueColor,
                      borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height *
                            AppDimensions.borderRadius28,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        AppStrings.addMoneyButton,
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
          ],
        ),
      ),
    );
  }
}
