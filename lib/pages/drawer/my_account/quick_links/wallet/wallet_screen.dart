import 'package:flutter/material.dart';
import 'package:qwiker_customer_app/appStyles/app_colors.dart';
import 'package:qwiker_customer_app/appStyles/app_dimensions.dart';
import 'package:qwiker_customer_app/appStyles/app_fonts.dart';
import 'package:qwiker_customer_app/appStyles/app_strings.dart';
import 'package:qwiker_customer_app/common.dart';
import 'package:qwiker_customer_app/models/wallet_transaction_history_model.dart';
import 'package:qwiker_customer_app/pages/drawer/my_account/quick_links/wallet/select_payment_method_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int totalAmount = 0;

  String? userId;

  getId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('UserID');
    getTotalAmount();
  }

  getTotalAmount() {
    for (int i = 0; i < walletTransactionHistoryModel.length; i++) {
      if (walletTransactionHistoryModel.length > 1) {
        var firstAmount = totalAmount;
        var secondAmount = walletTransactionHistoryModel[i].amount;
        totalAmount = firstAmount + secondAmount;
      } else {
        totalAmount = walletTransactionHistoryModel[i].amount;
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
      backgroundColor: AppColors.backgroundColor,
      appBar: Common.appBar(
        context,
        AppStrings.walletTitle,
        Common.backButton(context),
        AppColors.backgroundColor,
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(
          MediaQuery.of(context).size.height * AppDimensions.padding2,
        ),
        child: GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              scrollControlDisabledMaxHeightRatio: 1.35 / 3,
              builder: (context) => const SelectPaymentMethodScreen(),
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
      ),
      body: Padding(
        padding: EdgeInsets.all(
          MediaQuery.of(context).size.height * AppDimensions.padding2,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.094,
              width: MediaQuery.of(context).size.width * double.infinity,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.height *
                      AppDimensions.borderRadius16,
                ),
              ),
              padding: EdgeInsets.all(
                MediaQuery.of(context).size.height * AppDimensions.padding1p5,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.availableBalance,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height *
                          AppDimensions.fontSize16,
                      fontFamily: AppFonts.poppinsMedium,
                      color: AppColors.textGreyColor,
                    ),
                  ),
                  Text(
                    'TZS$totalAmount',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height *
                          AppDimensions.fontSize24,
                      fontFamily: AppFonts.poppinsMedium,
                      color: AppColors.blackColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: walletTransactionHistoryModel.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.094,
                    width: MediaQuery.of(context).size.width * double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          walletTransactionHistoryModel[index].depositBy,
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontFamily: AppFonts.poppinsMedium,
                            fontSize: MediaQuery.of(context).size.height *
                                AppDimensions.fontSize16,
                          ),
                        ),
                        Text(
                          'TZS${walletTransactionHistoryModel[index].amount}',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height *
                                AppDimensions.fontSize24,
                            fontFamily: AppFonts.poppinsMedium,
                            color: AppColors.redColor,
                          ),
                        ),
                        Text(
                          walletTransactionHistoryModel[index].date,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height *
                                AppDimensions.fontSize12,
                            fontFamily: AppFonts.poppinsMedium,
                            color: AppColors.textGreyColor,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
