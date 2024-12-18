import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qwiker_customer_app/appStyles/app_colors.dart';
import 'package:qwiker_customer_app/appStyles/app_dimensions.dart';
import 'package:qwiker_customer_app/appStyles/app_fonts.dart';
import 'package:qwiker_customer_app/appStyles/app_images.dart';
import 'package:qwiker_customer_app/appStyles/app_strings.dart';
import 'package:qwiker_customer_app/common.dart';
import 'package:qwiker_customer_app/models/firebase_model.dart';
import 'package:qwiker_customer_app/models/payment_method_model.dart';
import 'package:qwiker_customer_app/pages/bookRide/apply_coupon_screen.dart';
import 'package:qwiker_customer_app/pages/bookRide/find_driver_screen.dart';
import 'package:qwiker_customer_app/pages/drawer/my_account/add_new_card_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  TextEditingController couponCode = TextEditingController();
  double fare = 52.0;
  double totalFare = 0.0;
  int discount = 0;
  int validity = 0;
  String? userId;
  String? docId;
  bool couponApplied = false;
  List<FirebaseModel> coupon = [];

  getId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('UserID');
    docId = prefs.getString('docId');
    debugPrint('doc Id -- $docId');
  }

  getCoupons() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('UserID');
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('coupons').get();
    if (snapshot.toString().isNotEmpty) {
      for (int i = 0; i < snapshot.docs.length; i++) {
        setState(() {
          coupon.add(
              FirebaseModel(snapshot: snapshot.docs[i], isSelected: false));
        });
      }
    }
    for (int i = 0; i < coupon.length; i++) {
      if (coupon[i].snapshot.get('coupon_selected') == true) {
        setState(() {
          totalFare = fare;
          couponCode.text = coupon[i].snapshot.get('coupon_name');
          validity = coupon[i].snapshot.get('coupon_validity');
          discount = coupon[i].snapshot.get('coupon_discount');
        });
      } else {
        debugPrint('No Coupon is Selected');
      }
    }
  }

  applyCoupon() async {
    for (int i = 0; i < coupon.length; i++) {
      if (couponCode.text == coupon[i].snapshot.get('coupon_name')) {
        if (coupon[i].snapshot.get('coupon_validity') <= 10 &&
            coupon[i].snapshot.get('coupon_validity') > 0) {
          setState(() {
            totalFare = fare - (fare * discount / 100);
            validity = validity - 1;
          });
          await FirebaseFirestore.instance
              .collection('coupons')
              .doc(coupon[i].snapshot.id)
              .update({'coupon_validity': validity});
          await FirebaseFirestore.instance
              .collection('rides')
              .doc(docId)
              .update({
            'coupon_applied_id': coupon[i].snapshot.id,
            'coupon_discount': "${coupon[i].snapshot.get('coupon_discount')}%",
          });
          setState(() {
            couponCode.text = '';
            couponApplied = true;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.whiteColor,
              content: Text(
                'Your Coupon is INVALID !! Please Choose a VALID Coupon',
                style: TextStyle(
                  color: AppColors.blueColor,
                  fontSize: MediaQuery.of(context).size.height *
                      AppDimensions.fontSize14,
                  fontFamily: AppFonts.poppinsBold,
                ),
              ),
            ),
          );
        }
      }
    }
  }

  removeCoupon() async {
    for (int i = 0; i < coupon.length; i++) {
      if (coupon[i].snapshot.get('coupon_selected') == true) {
        if (coupon[i].snapshot.get('coupon_validity') < 10 &&
            coupon[i].snapshot.get('coupon_validity') >= 0) {
          setState(() {
            totalFare = fare;
            validity = validity + 1;
          });
          await FirebaseFirestore.instance
              .collection('coupons')
              .doc(coupon[i].snapshot.id)
              .update({'coupon_validity': validity});
          await FirebaseFirestore.instance
              .collection('rides')
              .doc(docId)
              .update({
            'coupon_applied_id': "",
            'coupon_discount': "",
          });
          setState(() {
            couponApplied = false;
          });
        }
      } else {
        debugPrint('No Coupon is Selected');
      }
    }
    getCoupons();
  }

  @override
  void initState() {
    getId();
    getCoupons();
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(
          MediaQuery.of(context).size.height * AppDimensions.padding2,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppImages.paymentScreen,
              height: MediaQuery.of(context).size.height * 0.21,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            GestureDetector(
              onTap: () async {
                await Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ApplyCouponScreen(),
                  ),
                );
              },
              child: Card(
                elevation: 3,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.054,
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.height *
                        AppDimensions.padding3,
                    right: MediaQuery.of(context).size.height *
                        AppDimensions.padding1,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.height *
                          AppDimensions.borderRadius14,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.applyCouponTitle,
                        style: TextStyle(
                          fontFamily: AppFonts.poppinsMedium,
                          fontSize: MediaQuery.of(context).size.height *
                              AppDimensions.fontSize16,
                          color: AppColors.blackColor,
                        ),
                      ),
                      Icon(
                        Icons.navigate_next_rounded,
                        color: AppColors.blackColor,
                        size: MediaQuery.of(context).size.height * 0.025,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.015),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.055,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.055,
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.height *
                          AppDimensions.padding3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height *
                            AppDimensions.borderRadius28,
                      ),
                    ),
                    child: TextFormField(
                      style: TextStyle(
                        fontFamily: AppFonts.poppinsMedium,
                        fontSize: MediaQuery.of(context).size.height *
                            AppDimensions.fontSize14,
                        color: AppColors.blackColor,
                      ),
                      controller: couponCode,
                      cursorColor: AppColors.textGreyColor,
                      decoration: InputDecoration(
                        hintText: AppStrings.enterCouponCode,
                        hintStyle: TextStyle(
                          fontFamily: AppFonts.poppinsMedium,
                          fontSize: MediaQuery.of(context).size.height *
                              AppDimensions.fontSize14,
                          color: AppColors.greyColor,
                        ),
                        border: const UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        disabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      couponApplied == true ? removeCoupon() : applyCoupon();
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.055,
                      width: MediaQuery.of(context).size.width * 0.25,
                      padding: EdgeInsets.all(
                        MediaQuery.of(context).size.height *
                            AppDimensions.padding1,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.blueColor,
                        borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.height *
                              AppDimensions.borderRadius28,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          couponApplied == true
                              ? AppStrings.removeButton
                              : AppStrings.applyButton,
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.addNewCard,
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontFamily: AppFonts.poppinsMedium,
                    fontSize: MediaQuery.of(context).size.height *
                        AppDimensions.fontSize18,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddNewCardScreen(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.add,
                    color: AppColors.blueColor,
                    size: MediaQuery.of(context).size.height * 0.03,
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.34,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: paymentMethodModel.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    color: paymentMethodModel[index].paymentSelected == true
                        ? AppColors.blueColor
                        : AppColors.whiteColor,
                    elevation: 3,
                    margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.02,
                    ),
                    child: ListTile(
                      onTap: () async {
                        for (int i = 0; i < paymentMethodModel.length; i++) {
                          paymentMethodModel[i].paymentSelected = false;
                          setState(() {});
                        }
                        paymentMethodModel[index].paymentSelected =
                            !paymentMethodModel[index].paymentSelected;
                        if (paymentMethodModel[index].paymentSelected == true) {
                          await FirebaseFirestore.instance
                              .collection('rides')
                              .doc(docId)
                              .update({
                            'payment_method':
                                paymentMethodModel[index].categoryName
                          });
                        }
                        setState(() {});
                      },
                      leading: Container(
                        height: MediaQuery.of(context).size.height * 0.047,
                        width: MediaQuery.of(context).size.width * 0.1,
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.height *
                                AppDimensions.borderRadius28,
                          ),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            paymentMethodModel[index].categoryImage,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      title: Text(
                        paymentMethodModel[index].categoryName,
                        style: TextStyle(
                          fontSize: paymentMethodModel[index].categoryImage ==
                                  AppImages.visa
                              ? MediaQuery.of(context).size.height *
                                  AppDimensions.fontSize14
                              : MediaQuery.of(context).size.height *
                                  AppDimensions.fontSize16,
                          fontFamily: paymentMethodModel[index].categoryImage ==
                                  AppImages.visa
                              ? AppFonts.poppinsMedium
                              : AppFonts.poppinsBold,
                          color:
                              paymentMethodModel[index].paymentSelected == true
                                  ? AppColors.whiteColor
                                  : AppColors.blackColor,
                        ),
                      ),
                      subtitle: paymentMethodModel[index].categoryImage ==
                              AppImages.visa
                          ? Text(
                              paymentMethodModel[index].categoryExpiryDate,
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.height *
                                    AppDimensions.fontSize10,
                                fontFamily: AppFonts.poppinsMedium,
                                color:
                                    paymentMethodModel[index].paymentSelected ==
                                            true
                                        ? AppColors.whiteColor
                                        : AppColors.mediumTextGreyColor,
                              ),
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.056,
              width: MediaQuery.of(context).size.width * 0.88,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '\$$totalFare',
                        style: TextStyle(
                          fontFamily: AppFonts.poppinsBold,
                          fontSize: MediaQuery.of(context).size.height *
                              AppDimensions.fontSize24,
                          color: AppColors.blueColor,
                        ),
                      ),
                      Text(
                        AppStrings.price,
                        style: TextStyle(
                          fontFamily: AppFonts.poppinsMedium,
                          fontSize: MediaQuery.of(context).size.height *
                              AppDimensions.fontSize14,
                          color: AppColors.blackColor,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      await FirebaseFirestore.instance
                          .collection('rides')
                          .doc(docId)
                          .update({
                        'ride_total_fare': totalFare,
                      });
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FindDriverScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.055,
                      width: MediaQuery.of(context).size.width * 0.7,
                      padding: EdgeInsets.all(
                        MediaQuery.of(context).size.height *
                            AppDimensions.padding1,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.blueColor,
                        borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.height *
                              AppDimensions.borderRadius28,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          AppStrings.bookRideButton,
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
          ],
        ),
      ),
    );
  }
}
