import 'package:flutter/material.dart';
import 'package:qwiker_customer_app/appStyles/app_colors.dart';
import 'package:qwiker_customer_app/appStyles/app_dimensions.dart';
import 'package:qwiker_customer_app/appStyles/app_fonts.dart';
import 'package:qwiker_customer_app/appStyles/app_strings.dart';
import 'package:qwiker_customer_app/common.dart';
import 'package:qwiker_customer_app/models/contact_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewAllContact extends StatefulWidget {
  const ViewAllContact({super.key});

  @override
  State<ViewAllContact> createState() => _ViewAllContactState();
}

class _ViewAllContactState extends State<ViewAllContact> {
  String? userId;

  getId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('UserID');
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
        AppStrings.suggestedContact,
        Common.backButton(context),
        AppColors.backgroundColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(
          MediaQuery.of(context).size.height * AppDimensions.padding1,
        ),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: contactModel.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              color: AppColors.whiteColor,
              elevation: 3,
              child: ListTile(
                title: Text(
                  contactModel[index].contactName,
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: MediaQuery.of(context).size.height *
                        AppDimensions.fontSize16,
                    fontFamily: AppFonts.poppinsMedium,
                  ),
                ),
                leading: Container(
                  height: MediaQuery.of(context).size.height * 0.04,
                  width: MediaQuery.of(context).size.width * 0.08,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.lightWhiteColor,
                  ),
                  child: Center(
                    child: Text(
                      contactModel[index].contactProfile,
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: MediaQuery.of(context).size.height *
                            AppDimensions.fontSize14,
                        fontFamily: AppFonts.poppinsMedium,
                      ),
                    ),
                  ),
                ),
                trailing: TextButton(
                  onPressed: () {
                    if (contactModel[index].contactInvited == true) {
                      setState(() {
                        contactModel[index].contactInvited = false;
                      });
                    } else {
                      setState(() {
                        contactModel[index].contactInvited = true;
                      });
                    }
                  },
                  child: Text(
                    contactModel[index].contactInvited == true
                        ? 'Invited'
                        : AppStrings.inviteButton,
                    style: TextStyle(
                      color: contactModel[index].contactInvited == true
                          ? AppColors.textGreyColor
                          : AppColors.blueColor,
                      fontSize: MediaQuery.of(context).size.height *
                          AppDimensions.fontSize16,
                      fontFamily: AppFonts.poppinsMedium,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
