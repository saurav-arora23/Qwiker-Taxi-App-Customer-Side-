import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qwiker_customer_app/appStyles/app_colors.dart';
import 'package:qwiker_customer_app/appStyles/app_dimensions.dart';
import 'package:qwiker_customer_app/appStyles/app_fonts.dart';
import 'package:qwiker_customer_app/appStyles/app_images.dart';
import 'package:qwiker_customer_app/appStyles/app_strings.dart';
import 'package:qwiker_customer_app/common.dart';
import 'package:qwiker_customer_app/models/drawer_menu_model.dart';
import 'package:qwiker_customer_app/pages/drawer/my_account/edit_profile_screen.dart';
import 'package:qwiker_customer_app/pages/drawer/my_account/quick_links/change_password_screen.dart';
import 'package:qwiker_customer_app/pages/drawer/my_account/quick_links/change_language_screen.dart';
import 'package:qwiker_customer_app/pages/drawer/my_account/quick_links/history_screen.dart';
import 'package:qwiker_customer_app/pages/drawer/my_account/quick_links/wallet/wallet_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  String userId = '';
  String name = '';
  String email = '';
  String phoneNumber = '';
  String countryCode = '';

  getId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('UserID')!;
    getDetails();
    setState(() {});
  }

  removeId() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('UserID');
    setState(() {});
  }

  getDetails() async {
    DocumentSnapshot<Map<String, dynamic>> snapShotData =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (snapShotData.toString().isNotEmpty) {
      setState(() {
        name = snapShotData.get("username");
        email = snapShotData.get("email");
        phoneNumber = snapShotData.get("phoneNumber");
        countryCode = snapShotData.get("countryCode");
      });
    }
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
        AppStrings.myAccountTitle,
        Common.backButton(context),
        AppColors.backgroundColor,
      ),
      body: name.isNotEmpty
          ? SingleChildScrollView(
              padding: EdgeInsets.all(
                MediaQuery.of(context).size.height * AppDimensions.padding2,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 3,
                    color: AppColors.whiteColor,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.13,
                      width:
                          MediaQuery.of(context).size.width * double.infinity,
                      padding: EdgeInsets.all(
                        MediaQuery.of(context).size.height *
                            AppDimensions.padding1p5,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.height *
                                  AppDimensions.borderRadius50,
                            ),
                            child: Image.asset(AppImages.user),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.02),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  color: AppColors.blackColor,
                                  fontFamily: AppFonts.poppinsBold,
                                  fontSize: MediaQuery.of(context).size.height *
                                      AppDimensions.fontSize18,
                                ),
                              ),
                              Text(
                                email,
                                style: TextStyle(
                                  color: AppColors.textGreyColor,
                                  fontFamily: AppFonts.poppinsMedium,
                                  fontSize: MediaQuery.of(context).size.height *
                                      AppDimensions.fontSize14,
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.005),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.phone_outlined,
                                    color: AppColors.blueColor,
                                    size: MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02),
                                  Text(
                                    countryCode + phoneNumber,
                                    style: TextStyle(
                                      color: AppColors.darkGreyColor,
                                      fontFamily: AppFonts.poppinsMedium,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              AppDimensions.fontSize14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.157),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfileScreen(
                                    image: AppImages.user,
                                    name: name.toString(),
                                    number: phoneNumber.toString(),
                                    email: email.toString(),
                                    countryCode: countryCode.toString(),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.035,
                              width: MediaQuery.of(context).size.width * 0.073,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.whiteColor,
                                border: Border.all(
                                  color: AppColors.blueColor,
                                  width:
                                      MediaQuery.of(context).size.width * 0.005,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.edit,
                                  color: AppColors.blueColor,
                                  size: MediaQuery.of(context).size.height *
                                      0.025,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  /* Card(
              elevation: 3,
              color: AppColors.whiteColor,
              child: Container(
                height: cardModel.length > 1
                    ? MediaQuery.of(context).size.height * 0.32
                    : MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width * double.infinity,
                padding: EdgeInsets.all(
                  MediaQuery.of(context).size.height * AppDimensions.padding1p5,
                ),
                child: Container(
                  height: cardModel.length > 1
                      ? MediaQuery.of(context).size.height * 0.4
                      : MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * double.infinity,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.bankAccountDetails,
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: MediaQuery.of(context).size.height *
                              AppDimensions.fontSize16,
                          fontFamily: AppFonts.poppinsMedium,
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015),
                      SizedBox(
                        height: cardModel.length > 1
                            ? MediaQuery.of(context).size.height * 0.17
                            : MediaQuery.of(context).size.height * 0.075,
                        width:
                            MediaQuery.of(context).size.width * double.infinity,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: cardModel.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.075,
                              width: MediaQuery.of(context).size.width *
                                  double.infinity,
                              margin: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).size.height *
                                      0.02),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.075,
                                    width: MediaQuery.of(context).size.width *
                                        0.17,
                                    decoration: BoxDecoration(
                                      color: AppColors.ultraLightWhiteColor,
                                      borderRadius: BorderRadius.circular(
                                        MediaQuery.of(context).size.height *
                                            AppDimensions.borderRadius12,
                                      ),
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(AppImages.bank),
                                    ),
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cardModel[index].bankName,
                                        style: TextStyle(
                                          color: AppColors.blackColor,
                                          fontFamily: AppFonts.poppinsMedium,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              AppDimensions.fontSize16,
                                        ),
                                      ),
                                      Text(
                                        cardModel[index].accountType,
                                        style: TextStyle(
                                          color: AppColors.mediumTextGreyColor,
                                          fontFamily: AppFonts.poppinsMedium,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              AppDimensions.fontSize14,
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01),
                                      Text(
                                        AppStrings.delete,
                                        style: TextStyle(
                                          color: AppColors.redColor,
                                          fontFamily: AppFonts.poppinsMedium,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              AppDimensions.fontSize14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.15),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditCardScreen(
                                            cardDetails: cardModel[index],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.035,
                                      width: MediaQuery.of(context).size.width *
                                          0.073,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.whiteColor,
                                        border: Border.all(
                                          color: AppColors.blueColor,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.005,
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.edit,
                                          color: AppColors.blueColor,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.025,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddNewCardScreen(),
                            ),
                          );
                        },
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.065,
                          width: MediaQuery.of(context).size.width *
                              double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                width: MediaQuery.of(context).size.width * 0.15,
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundColor,
                                  borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.height *
                                        AppDimensions.borderRadius12,
                                  ),
                                ),
                                child: GFBorder(
                                  radius: Radius.circular(
                                    MediaQuery.of(context).size.height *
                                        AppDimensions.borderRadius10,
                                  ),
                                  dashedLine: const [6, 6],
                                  type: GFBorderType.rRect,
                                  color: AppColors.blueColor,
                                  child: Center(
                                    child: Icon(
                                      Icons.add,
                                      color: AppColors.blueColor,
                                      size: MediaQuery.of(context).size.height *
                                          0.03,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.02),
                              Text(
                                AppStrings.addBankAccount,
                                style: TextStyle(
                                  color: AppColors.mediumTextGreyColor,
                                  fontFamily: AppFonts.poppinsMedium,
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
              ),
            ),*/
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Text(
                    AppStrings.quickLinks,
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: MediaQuery.of(context).size.height *
                          AppDimensions.fontSize16,
                      fontFamily: AppFonts.poppinsMedium,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.45,
                    width: MediaQuery.of(context).size.width * double.infinity,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: quickLinkMenu.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 3,
                          color: AppColors.whiteColor,
                          child: ListTile(
                            onTap: () {
                              switch (quickLinkMenu[index].menu) {
                                case 'History':
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const HistoryScreen(),
                                    ),
                                  );
                                  break;

                                case 'Change Language':
                                  showModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    scrollControlDisabledMaxHeightRatio: 2 / 3,
                                    context: context,
                                    builder: (context) =>
                                        const ChangeLanguageScreen(),
                                  );
                                  break;

                                case 'Wallet':
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const WalletScreen(),
                                    ),
                                  );
                                  break;

                                case 'Change Password':
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ChangePasswordScreen(),
                                    ),
                                  );
                                  break;

                                default:
                                  'Invalid Choice';
                              }
                            },
                            leading: quickLinkMenu[index].menuIcons,
                            title: Text(
                              quickLinkMenu[index].menu,
                              style: TextStyle(
                                fontFamily: AppFonts.poppinsMedium,
                                fontSize: MediaQuery.of(context).size.height *
                                    AppDimensions.fontSize16,
                                color: AppColors.blackColor,
                              ),
                            ),
                            trailing: Icon(
                              Icons.navigate_next_rounded,
                              color: AppColors.blueColor,
                              size: MediaQuery.of(context).size.height * 0.025,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => Common.deleteDialog(context),
                        );
                      },
                      child: Text(
                        AppStrings.deleteButton,
                        style: TextStyle(
                          color: AppColors.redColor,
                          fontSize: MediaQuery.of(context).size.height *
                              AppDimensions.fontSize16,
                          fontFamily: AppFonts.poppinsMedium,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => Common.logoutDialog(context),
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
                          AppStrings.logoutButton,
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: MediaQuery.of(context).size.height *
                                AppDimensions.fontSize20,
                            fontFamily: AppFonts.poppinsMedium,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(
                color: AppColors.blueColor,
              ),
            ),
    );
  }
}
