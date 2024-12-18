// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qwiker_customer_app/appStyles/app_colors.dart';
import 'package:qwiker_customer_app/appStyles/app_dimensions.dart';
import 'package:qwiker_customer_app/appStyles/app_fonts.dart';
import 'package:qwiker_customer_app/appStyles/app_images.dart';
import 'package:qwiker_customer_app/appStyles/app_strings.dart';
import 'package:qwiker_customer_app/common.dart';
import 'package:qwiker_customer_app/models/payment_method_model.dart';
import 'package:qwiker_customer_app/pages/drawer/my_account/add_new_card_screen.dart';
import 'package:qwiker_customer_app/pages/drawer/my_account/my_account_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditCardScreen extends StatefulWidget {
  CardModel cardDetails;
  EditCardScreen({super.key, required this.cardDetails});

  @override
  State<EditCardScreen> createState() => _EditCardScreenState();
}

class _EditCardScreenState extends State<EditCardScreen> {
  TextEditingController cardHolderName = TextEditingController();
  TextEditingController cardNumber = TextEditingController();
  TextEditingController cardExpiryDate = TextEditingController();
  TextEditingController cardCVV = TextEditingController();

  String? userId;

  getId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('UserID');
    getDetails();
  }

  getDetails() {
    cardHolderName.text = widget.cardDetails.cardHolderName;
    cardNumber.text = widget.cardDetails.cardNumber;
    cardExpiryDate.text = widget.cardDetails.cardExpiryDate;
    cardCVV.text = widget.cardDetails.cardCVV;
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
        AppStrings.editCardTitle,
        Common.backButton(context),
        AppColors.backgroundColor,
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNewCardScreen(),
            ),
          );
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.2,
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.blackColor.withOpacity(0.5),
                blurStyle: BlurStyle.outer,
                blurRadius: MediaQuery.of(context).size.height * 0.1,
              ),
            ],
          ),
          child: Icon(
            Icons.add,
            color: AppColors.blueColor,
            size: MediaQuery.of(context).size.height * 0.05,
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(
            MediaQuery.of(context).size.height * AppDimensions.padding2),
        child: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MyAccountScreen(),
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
                AppStrings.saveCardButton,
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
              child: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: AppColors.blueColor,
                  borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height *
                        AppDimensions.borderRadius28,
                  ),
                ),
                padding: EdgeInsets.all(
                  MediaQuery.of(context).size.height * AppDimensions.padding3,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      widget.cardDetails.cardImage,
                      color: AppColors.whiteColor,
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Text(
                      cardNumber.text,
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: MediaQuery.of(context).size.height *
                            AppDimensions.fontSize22,
                        fontFamily: AppFonts.poppinsBold,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          cardHolderName.text,
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: MediaQuery.of(context).size.height *
                                AppDimensions.fontSize14,
                            fontFamily: AppFonts.poppinsMedium,
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.12),
                        Text(
                          cardExpiryDate.text,
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: MediaQuery.of(context).size.height *
                                AppDimensions.fontSize14,
                            fontFamily: AppFonts.poppinsMedium,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
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
                controller: cardHolderName,
                onChanged: (value) {
                  setState(() {
                    cardHolderName.text = value;
                  });
                },
                style: TextStyle(
                  fontFamily: AppFonts.poppinsMedium,
                  fontSize: MediaQuery.of(context).size.height *
                      AppDimensions.fontSize14,
                  color: AppColors.blackColor,
                ),
                cursorColor: AppColors.textGreyColor,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  prefixIcon: Image.asset(
                    AppImages.cardHolderName,
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.1,
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
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  CardNumberFormater(),
                ],
                controller: cardNumber,
                onChanged: (value) {
                  setState(() {
                    cardNumber.text = value;
                  });
                },
                style: TextStyle(
                  fontFamily: AppFonts.poppinsMedium,
                  fontSize: MediaQuery.of(context).size.height *
                      AppDimensions.fontSize14,
                  color: AppColors.blackColor,
                ),
                cursorColor: AppColors.textGreyColor,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Image.asset(
                    AppImages.cardNumber,
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.1,
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
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                  CardExpiryDateFormater()
                ],
                controller: cardExpiryDate,
                onChanged: (value) {
                  setState(() {
                    cardExpiryDate.text = value;
                  });
                },
                style: TextStyle(
                  fontFamily: AppFonts.poppinsMedium,
                  fontSize: MediaQuery.of(context).size.height *
                      AppDimensions.fontSize14,
                  color: AppColors.blackColor,
                ),
                cursorColor: AppColors.textGreyColor,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  prefixIcon: Image.asset(
                    AppImages.cardExpiry,
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.1,
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
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3)
                ],
                controller: cardCVV,
                onChanged: (value) {
                  setState(() {
                    cardCVV.text = value;
                  });
                },
                style: TextStyle(
                  fontFamily: AppFonts.poppinsMedium,
                  fontSize: MediaQuery.of(context).size.height *
                      AppDimensions.fontSize14,
                  color: AppColors.blackColor,
                ),
                cursorColor: AppColors.textGreyColor,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Image.asset(
                    AppImages.cardCVV,
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.1,
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
          ],
        ),
      ),
    );
  }
}

class CardNumberFormater extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    String enteredData = newValue.text; // get data enter by used in textField
    StringBuffer buffer = StringBuffer();

    for (int i = 0; i < enteredData.length; i++) {
      buffer.write(enteredData[i]);
      int index = i + 1;
      if (index % 4 == 0 && enteredData.length != index) {
        buffer.write("      ");
      }
    }

    return TextEditingValue(
        text: buffer.toString(), // final generated credit card number
        selection: TextSelection.collapsed(
            offset: buffer.toString().length) // keep the cursor at end
        );
  }
}

class CardExpiryDateFormater extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    String enteredData = newValue.text; // get data enter by used in textField
    StringBuffer buffer = StringBuffer();

    for (int i = 0; i < enteredData.length; i++) {
      buffer.write(enteredData[i]);
      int index = i + 1;
      if (index % 2 == 0 && enteredData.length != index) {
        buffer.write("/");
      }
    }

    return TextEditingValue(
        text: buffer.toString(), // final generated credit card number
        selection: TextSelection.collapsed(
            offset: buffer.toString().length) // keep the cursor at end
        );
  }
}
