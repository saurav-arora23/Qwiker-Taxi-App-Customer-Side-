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
import 'package:qwiker_customer_app/pages/bookRide/payment_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplyCouponScreen extends StatefulWidget {
  const ApplyCouponScreen({super.key});

  @override
  State<ApplyCouponScreen> createState() => _ApplyCouponScreenState();
}

class _ApplyCouponScreenState extends State<ApplyCouponScreen> {
  String? userId;
  List<FirebaseModel> coupon = [];

  getId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('UserID');
    getCoupons();
  }

  getCoupons() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('coupons').get();
    if (snapshot.toString().isNotEmpty) {
      for (int i = 0; i < snapshot.docs.length; i++) {
        setState(() {
          coupon.add(
            FirebaseModel(
              snapshot: snapshot.docs[i],
              isSelected: snapshot.docs[i].get('coupon_selected'),
            ),
          );
        });
      }
    }
    debugPrint("Total Coupons --- ${coupon.length}");
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
        AppStrings.applyCouponTitle,
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
                builder: (context) => const PaymentScreen(),
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
                AppStrings.applyCouponTitle,
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
                  decoration: InputDecoration(
                    hintText: AppStrings.enterCouponCode,
                    hintStyle: TextStyle(
                      fontFamily: AppFonts.poppinsMedium,
                      fontSize: MediaQuery.of(context).size.height *
                          AppDimensions.fontSize14,
                      color: AppColors.greyColor,
                    ),
                    border:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                    enabledBorder:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                    disabledBorder:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: EdgeInsets.all(
                  MediaQuery.of(context).size.height * AppDimensions.padding2),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: coupon.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    color: AppColors.backgroundColor,
                    elevation: 3,
                    margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.02,
                    ),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.112,
                      width: MediaQuery.of(context).size.width * 0.08,
                      decoration: BoxDecoration(
                        color: coupon[index].isSelected == true
                            ? AppColors.blueColor
                            : AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.height *
                              AppDimensions.borderRadius18,
                        ),
                      ),
                      child: Center(
                        child: ListTile(
                          onTap: () {
                            for (int i = 0; i < coupon.length; i++) {
                              coupon[i].isSelected = coupon[index].isSelected;
                              FirebaseFirestore.instance
                                  .collection('coupons')
                                  .doc(coupon[i].snapshot.id)
                                  .update({
                                'coupon_selected': coupon[i].isSelected
                              });
                              setState(() {});
                            }
                            coupon[index].isSelected =
                                !coupon[index].isSelected;
                            FirebaseFirestore.instance
                                .collection('coupons')
                                .doc(coupon[index].snapshot.id)
                                .update({
                              'coupon_selected': coupon[index].isSelected
                            });
                            setState(() {});
                          },
                          leading: Container(
                            height: MediaQuery.of(context).size.height * 0.068,
                            width: MediaQuery.of(context).size.width * 0.135,
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.height *
                                    AppDimensions.borderRadius39,
                              ),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                AppImages.couponScreen,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          title: Text(
                            "${coupon[index].snapshot.get('coupon_discount')}% off up to ${coupon[index].snapshot.get('coupon_validity')} trips use \nCode : ${coupon[index].snapshot.get('coupon_name')}",
                            style: TextStyle(
                              color: coupon[index].isSelected == true
                                  ? AppColors.whiteColor
                                  : AppColors.blackColor,
                              fontSize: MediaQuery.of(context).size.height *
                                  AppDimensions.fontSize16,
                              fontFamily: AppFonts.poppinsSemiBold,
                            ),
                          ),
                          subtitle: Text(
                            "${coupon[index].snapshot.get('coupon_validity')}+ Trips Left",
                            style: TextStyle(
                              color: coupon[index].isSelected == true
                                  ? AppColors.whiteColor
                                  : AppColors.blackColor,
                              fontSize: MediaQuery.of(context).size.height *
                                  AppDimensions.fontSize12,
                              fontFamily: AppFonts.poppinsMedium,
                            ),
                          ),
                        ),
                      ),
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
