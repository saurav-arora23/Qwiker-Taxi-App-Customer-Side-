import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qwiker_customer_app/appStyles/app_colors.dart';
import 'package:qwiker_customer_app/appStyles/app_dimensions.dart';
import 'package:qwiker_customer_app/appStyles/app_fonts.dart';
import 'package:qwiker_customer_app/appStyles/app_images.dart';
import 'package:qwiker_customer_app/appStyles/app_strings.dart';
import 'package:qwiker_customer_app/common.dart';
import 'package:qwiker_customer_app/pages/authentication/sign_up_screen.dart';
import 'package:qwiker_customer_app/pages/drawer/my_account/quick_links/change_password_screen.dart';
import 'package:qwiker_customer_app/pages/homepage_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
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
            logoView(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Text(
              AppStrings.loginPageTitle,
              style: TextStyle(
                color: AppColors.blackColor,
                fontFamily: AppFonts.medel,
                fontSize: MediaQuery.of(context).size.height *
                    AppDimensions.fontSize36,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text(
              AppStrings.loginPageDes,
              style: TextStyle(
                color: AppColors.blackColor,
                fontFamily: AppFonts.poppinsMedium,
                fontSize: MediaQuery.of(context).size.height *
                    AppDimensions.fontSize16,
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
                    color: AppColors.greyColor,
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.005),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangePasswordScreen(),
                    ),
                  );
                },
                child: Text(
                  AppStrings.forgotPasswordTitle,
                  style: TextStyle(
                    color: AppColors.redColor,
                    fontFamily: AppFonts.poppinsMedium,
                    fontSize: MediaQuery.of(context).size.height *
                        AppDimensions.fontSize16,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            GestureDetector(
              onTap: () async {
                try {
                  final credential =
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email.text,
                    password: password.text,
                  );

                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('UserID', credential.user!.uid);

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomepageScreen(),
                    ),
                  );
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    debugPrint('No user found for that email.');
                  } else if (e.code == 'wrong-password') {
                    debugPrint('Wrong password provided for that user.');
                  }
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
                    AppStrings.loginPageTitle,
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.18),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignUpScreen(),
                  ),
                );
              },
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: AppStrings.doNotHaveAccount,
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontFamily: AppFonts.poppinsMedium,
                        fontSize: MediaQuery.of(context).size.height *
                            AppDimensions.fontSize16,
                      ),
                    ),
                    TextSpan(
                      text: AppStrings.signUpPageTitle,
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

  Widget logoView() {
    return Center(
      child: Image.asset(
        AppImages.logo,
        height: MediaQuery.of(context).size.height * 0.06,
      ),
    );
  }
}
