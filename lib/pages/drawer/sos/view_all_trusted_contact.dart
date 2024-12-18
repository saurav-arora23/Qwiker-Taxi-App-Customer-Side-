import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qwiker_customer_app/appStyles/app_colors.dart';
import 'package:qwiker_customer_app/appStyles/app_dimensions.dart';
import 'package:qwiker_customer_app/appStyles/app_fonts.dart';
import 'package:qwiker_customer_app/appStyles/app_images.dart';
import 'package:qwiker_customer_app/appStyles/app_strings.dart';
import 'package:qwiker_customer_app/common.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewAllTrustedContact extends StatefulWidget {
  const ViewAllTrustedContact({super.key});

  @override
  State<ViewAllTrustedContact> createState() => _ViewAllTrustedContactState();
}

class _ViewAllTrustedContactState extends State<ViewAllTrustedContact> {
  String countryCode = '+91';
  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();
  String? userId;
  List<dynamic> sc = [];

  getId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('UserID');
  }

  addContacts() {
    setState(() {
      sc.add({
        'contact_number': number.text,
        'country_code': countryCode,
        'contact_name': name.text
      });
    });

    try {
      FirebaseFirestore.instance.collection('sos_contacts').doc(userId).set({
        'contacts': sc,
      });
      debugPrint('Added');
    } catch (e) {
      debugPrint(e.toString());
    }
    getContacts();
  }

  getContacts() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('UserID');
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('sos_contacts')
        .doc(userId)
        .get();
    if (snapshot.toString().isNotEmpty) {
      sc.clear();
      setState(() {
        sc.addAll(snapshot.get('contacts'));
      });
    }
    debugPrint('SOS Contact Length is  --  ${sc.length}');
    setState(() {});
  }

  @override
  void initState() {
    getId();
    getContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: Common.appBar(
        context,
        AppStrings.sosTitle,
        Common.backButton(context),
        AppColors.backgroundColor,
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(
            MediaQuery.of(context).size.height * AppDimensions.padding2),
        child: GestureDetector(
          onTap: () async {
            var result = await showModalBottomSheet(
              context: context,
              builder: (context) => addEmergencyContact(),
            );

            if (result == true || result == null) {
              setState(() {
                getId();
              });
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
                AppStrings.addNewButton,
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
        padding: EdgeInsets.all(
          MediaQuery.of(context).size.height * AppDimensions.padding1,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.sosDes,
              style: TextStyle(
                color: AppColors.blackColor,
                fontFamily: AppFonts.poppinsMedium,
                fontSize: MediaQuery.of(context).size.height *
                    AppDimensions.fontSize24,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            sc.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: sc.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        elevation: 3,
                        color: AppColors.whiteColor,
                        margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height *
                              AppDimensions.padding2,
                        ),
                        child: ListTile(
                          leading: SvgPicture.asset(
                            AppImages.profile,
                            height: MediaQuery.of(context).size.height * 0.06,
                          ),
                          title: Text(
                            sc[index]['contact_name'],
                            style: TextStyle(
                              color: AppColors.blackColor,
                              fontFamily: AppFonts.poppinsMedium,
                              fontSize: MediaQuery.of(context).size.height *
                                  AppDimensions.fontSize18,
                            ),
                          ),
                          subtitle: Text(
                            "${sc[index]['country_code']}${sc[index]['contact_number']}",
                            style: TextStyle(
                              color: AppColors.textGreyColor,
                              fontFamily: AppFonts.poppinsMedium,
                              fontSize: MediaQuery.of(context).size.height *
                                  AppDimensions.fontSize18,
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(
                      "You Don't add any Contact into SOS",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height *
                            AppDimensions.fontSize14,
                        fontFamily: AppFonts.poppinsMedium,
                        color: AppColors.blueColor,
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Widget addEmergencyContact() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.32,
      width: MediaQuery.of(context).size.width * double.infinity,
      padding: EdgeInsets.all(
        MediaQuery.of(context).size.height * AppDimensions.padding2,
      ),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(
          MediaQuery.of(context).size.height * AppDimensions.borderRadius28,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.addTrustedContactTitle,
            style: TextStyle(
              color: AppColors.blackColor,
              fontFamily: AppFonts.poppinsMedium,
              fontSize:
                  MediaQuery.of(context).size.height * AppDimensions.fontSize24,
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
              controller: name,
              onChanged: (value) {
                setState(() {
                  name.text = value;
                });
              },
              style: TextStyle(
                fontFamily: AppFonts.poppinsMedium,
                fontSize: MediaQuery.of(context).size.height *
                    AppDimensions.fontSize14,
                color: AppColors.blackColor,
              ),
              cursorColor: AppColors.textGreyColor,
              decoration: InputDecoration(
                hintText: AppStrings.fullName,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CountryCodePicker(
                  initialSelection: countryCode,
                  onChanged: (value) {
                    setState(() {
                      countryCode = value.toString();
                    });
                  },
                  showCountryOnly: false,
                  showFlag: false,
                  textStyle: TextStyle(
                    color: AppColors.blueColor,
                    fontSize: MediaQuery.of(context).size.height *
                        AppDimensions.fontSize14,
                    fontFamily: AppFonts.poppinsBold,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: TextFormField(
                    controller: number,
                    onChanged: (value) {
                      setState(() {
                        number.text = value;
                      });
                    },
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
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          GestureDetector(
            onTap: () {
              setState(() {
                addContacts();
              });
              Navigator.pop(context);
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
                  AppStrings.saveButton,
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
    );
  }
}
