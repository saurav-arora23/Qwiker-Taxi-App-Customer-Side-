import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qwiker_customer_app/appStyles/app_colors.dart';
import 'package:qwiker_customer_app/appStyles/app_dimensions.dart';
import 'package:qwiker_customer_app/appStyles/app_fonts.dart';
import 'package:qwiker_customer_app/appStyles/app_strings.dart';
import 'package:qwiker_customer_app/common.dart';
import 'package:qwiker_customer_app/pages/drawer/my_account/my_account_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  String image;
  String name;
  String email;
  String number;
  String countryCode;
  EditProfileScreen(
      {super.key,
      required this.image,
      required this.name,
      required this.email,
      required this.number,
      required this.countryCode});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

  File? imageController;

  final _picker = ImagePicker();

  String userId = '';
  String countryCode = '';

  getId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('UserID')!;
    getDetails();
  }

  void _openImagePicker(ImageSource source) async {
    final XFile? pickedImage = await _picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        imageController = File(pickedImage.path);
      });
    }
  }

  getDetails() {
    name.text = widget.name;
    email.text = widget.email;
    phoneNumber.text = widget.number;
    countryCode = widget.countryCode;
    setState(() {});
  }

  updateProfile() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('UserID')!;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'username': name.text, 'phoneNumber': phoneNumber.text});
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
        AppStrings.editProfileTitle,
        Common.backButton(context),
        AppColors.backgroundColor,
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(
            MediaQuery.of(context).size.height * AppDimensions.padding2),
        child: GestureDetector(
          onTap: () {
            updateProfile();
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
                AppStrings.updateProfileButton,
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
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.height * 0.08,
                backgroundColor: AppColors.whiteColor,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    CircleAvatar(
                      radius: MediaQuery.of(context).size.height * 0.085,
                      backgroundColor: AppColors.blackColor,
                      child: Align(
                        alignment: Alignment.center,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.height *
                                AppDimensions.borderRadius50,
                          ),
                          child: imageController != null
                              ? Image.file(
                                  imageController!,
                                  fit: BoxFit.fill,
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                )
                              : Image.asset(
                                  widget.image,
                                  fit: BoxFit.fill,
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext dialogContext) {
                              return AlertDialog(
                                backgroundColor: AppColors.whiteColor,
                                title: Text(
                                  'Upload Your Photo',
                                  style: TextStyle(
                                    fontFamily: AppFonts.medel,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            AppDimensions.fontSize22,
                                  ),
                                ),
                                actions: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.photo_library_rounded,
                                      size: MediaQuery.of(context).size.height *
                                          0.025,
                                      color: AppColors.blackColor,
                                    ),
                                    onPressed: () {
                                      _openImagePicker(ImageSource.gallery);
                                      Navigator.of(context)
                                          .pop(); // Dismiss alert dialog
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.camera_alt_rounded,
                                      size: MediaQuery.of(context).size.height *
                                          0.025,
                                      color: AppColors.blackColor,
                                    ),
                                    onPressed: () {
                                      _openImagePicker(ImageSource.camera);
                                      Navigator.of(context)
                                          .pop(); // Dismiss alert dialog
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: CircleAvatar(
                          radius: MediaQuery.of(context).size.height *
                              AppDimensions.borderRadius20,
                          backgroundColor: AppColors.blueColor,
                          child: Icon(
                            Icons.camera_alt_rounded,
                            size: MediaQuery.of(context).size.height * 0.025,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),
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
                controller: name,
                onChanged: (value) async {
                  setState(() {
                    name.text = value;
                  });
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .update({'username': name.text});
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
                  prefixIcon: Icon(
                    Icons.person_outline_outlined,
                    color: AppColors.lightGreyColor,
                    size: MediaQuery.of(context).size.height * 0.038,
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
                controller: email,
                readOnly: true,
                style: TextStyle(
                  fontFamily: AppFonts.poppinsMedium,
                  fontSize: MediaQuery.of(context).size.height *
                      AppDimensions.fontSize14,
                  color: AppColors.blackColor,
                ),
                cursorColor: AppColors.textGreyColor,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: AppColors.lightGreyColor,
                    size: MediaQuery.of(context).size.height * 0.03,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                  Icon(
                    Icons.phone,
                    color: AppColors.lightGreyColor,
                    size: MediaQuery.of(context).size.height * 0.028,
                  ),
                  CountryCodePicker(
                    showCountryOnly: false,
                    showFlag: false,
                    initialSelection: countryCode,
                    onChanged: (value) async {
                      setState(() {
                        countryCode = value.toString();
                      });
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .update({
                        'countryCode': countryCode,
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
                    width: MediaQuery.of(context).size.width * 0.64,
                    child: TextFormField(
                      controller: phoneNumber,
                      onChanged: (value) async {
                        setState(() {
                          phoneNumber.text = value;
                        });
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(userId)
                            .update({
                          'phoneNumber': phoneNumber.text,
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
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        enabledBorder:
                            OutlineInputBorder(borderSide: BorderSide.none),
                        disabledBorder:
                            OutlineInputBorder(borderSide: BorderSide.none),
                        focusedBorder:
                            OutlineInputBorder(borderSide: BorderSide.none),
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
