import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qwiker_customer_app/appStyles/app_colors.dart';
import 'package:qwiker_customer_app/appStyles/app_dimensions.dart';
import 'package:qwiker_customer_app/appStyles/app_fonts.dart';
import 'package:qwiker_customer_app/appStyles/app_images.dart';
import 'package:qwiker_customer_app/appStyles/app_strings.dart';
import 'package:qwiker_customer_app/common.dart';
import 'package:qwiker_customer_app/pages/authentication/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  String countryCode = '+91';
  bool visiblePassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: Common.appBar(
        context,
        '',
        Container(),
        AppColors.backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                AppImages.logo,
                height: MediaQuery.of(context).size.height * 0.06,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Text(
              AppStrings.signUpPageTitle,
              style: TextStyle(
                color: AppColors.blackColor,
                fontFamily: AppFonts.medel,
                fontSize: MediaQuery.of(context).size.height *
                    AppDimensions.fontSize36,
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
                controller: username,
                style: TextStyle(
                  fontFamily: AppFonts.poppinsMedium,
                  fontSize: MediaQuery.of(context).size.height *
                      AppDimensions.fontSize14,
                  color: AppColors.blackColor,
                ),
                cursorColor: AppColors.textGreyColor,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: AppStrings.fullName,
                  hintStyle: TextStyle(
                    fontFamily: AppFonts.poppinsMedium,
                    fontSize: MediaQuery.of(context).size.height *
                        AppDimensions.fontSize14,
                    color: AppColors.lightGreyColor,
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
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
                controller: email,
                style: TextStyle(
                  fontFamily: AppFonts.poppinsMedium,
                  fontSize: MediaQuery.of(context).size.height *
                      AppDimensions.fontSize14,
                  color: AppColors.blackColor,
                ),
                cursorColor: AppColors.textGreyColor,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: AppStrings.email,
                  hintStyle: TextStyle(
                    fontFamily: AppFonts.poppinsMedium,
                    fontSize: MediaQuery.of(context).size.height *
                        AppDimensions.fontSize14,
                    color: AppColors.lightGreyColor,
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CountryCodePicker(
                    showCountryOnly: false,
                    showFlag: false,
                    initialSelection: countryCode,
                    onChanged: (value) {
                      setState(() {
                        countryCode = value.toString();
                      });
                    },
                    textStyle: TextStyle(
                      fontFamily: AppFonts.poppinsMedium,
                      fontSize: MediaQuery.of(context).size.height *
                          AppDimensions.fontSize14,
                      color: AppColors.blackColor,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextFormField(
                      controller: phoneNumber,
                      style: TextStyle(
                        fontFamily: AppFonts.poppinsMedium,
                        fontSize: MediaQuery.of(context).size.height *
                            AppDimensions.fontSize14,
                        color: AppColors.blackColor,
                      ),
                      keyboardType: TextInputType.number,
                      cursorColor: AppColors.textGreyColor,
                      decoration: InputDecoration(
                        hintText: AppStrings.phoneNumber,
                        hintStyle: TextStyle(
                          fontFamily: AppFonts.poppinsMedium,
                          fontSize: MediaQuery.of(context).size.height *
                              AppDimensions.fontSize14,
                          color: AppColors.greyColor,
                        ),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        disabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
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
                controller: password,
                onChanged: (value) {
                  setState(() {
                    password.text = value;
                  });
                },
                style: TextStyle(
                  fontFamily: AppFonts.poppinsMedium,
                  fontSize: MediaQuery.of(context).size.height *
                      AppDimensions.fontSize14,
                  color: AppColors.blackColor,
                ),
                cursorColor: AppColors.textGreyColor,
                keyboardType: TextInputType.visiblePassword,
                obscureText: visiblePassword == false ? true : false,
                decoration: InputDecoration(
                  hintText: AppStrings.password,
                  hintStyle: TextStyle(
                    fontFamily: AppFonts.poppinsMedium,
                    fontSize: MediaQuery.of(context).size.height *
                        AppDimensions.fontSize14,
                    color: AppColors.greyColor,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      visiblePassword == false
                          ? setState(() {
                              visiblePassword = true;
                            })
                          : setState(() {
                              visiblePassword = false;
                            });
                    },
                    icon: Icon(
                      visiblePassword == false
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.lightGreyColor,
                      size: MediaQuery.of(context).size.height * 0.025,
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
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
                controller: confirmPassword,
                onChanged: (value) {
                  setState(() {
                    confirmPassword.text = value;
                  });
                },
                style: TextStyle(
                  fontFamily: AppFonts.poppinsMedium,
                  fontSize: MediaQuery.of(context).size.height *
                      AppDimensions.fontSize14,
                  color: AppColors.blackColor,
                ),
                cursorColor: AppColors.textGreyColor,
                keyboardType: TextInputType.visiblePassword,
                obscureText: visiblePassword == false ? true : false,
                decoration: InputDecoration(
                  hintText: AppStrings.confirmPassword,
                  hintStyle: TextStyle(
                    fontFamily: AppFonts.poppinsMedium,
                    fontSize: MediaQuery.of(context).size.height *
                        AppDimensions.fontSize14,
                    color: AppColors.greyColor,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      visiblePassword == false
                          ? setState(() {
                              visiblePassword = true;
                            })
                          : setState(() {
                              visiblePassword = false;
                            });
                    },
                    icon: Icon(
                      visiblePassword == false
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.lightGreyColor,
                      size: MediaQuery.of(context).size.height * 0.025,
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            GestureDetector(
              onTap: () async {
                try {
                  final credential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: email.text,
                    password: password.text,
                  );
                  User? user = credential.user;
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user!.uid)
                      .set({
                    'username': username.text,
                    'email': email.text,
                    'password': password.text,
                    'phoneNumber': phoneNumber.text,
                    'countryCode': countryCode,
                    'userType': 1,
                  });
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    debugPrint('The password provided is too weak.');
                  } else if (e.code == 'email-already-in-use') {
                    debugPrint('The account already exists for that email.');
                  }
                } catch (e) {
                  debugPrint(e.toString());
                }
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
                    AppStrings.signUpPageTitle,
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: AppStrings.haveAccount,
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontFamily: AppFonts.poppinsMedium,
                        fontSize: MediaQuery.of(context).size.height *
                            AppDimensions.fontSize16,
                      ),
                    ),
                    TextSpan(
                      text: AppStrings.signIn,
                      style: TextStyle(
                        color: AppColors.blueColor,
                        fontFamily: AppFonts.poppinsBold,
                        fontSize: MediaQuery.of(context).size.height *
                            AppDimensions.fontSize16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
