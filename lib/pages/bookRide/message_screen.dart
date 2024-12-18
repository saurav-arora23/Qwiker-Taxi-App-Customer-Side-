import 'package:flutter/material.dart';
import 'package:qwiker_customer_app/appStyles/app_colors.dart';
import 'package:qwiker_customer_app/appStyles/app_dimensions.dart';
import 'package:qwiker_customer_app/appStyles/app_fonts.dart';
import 'package:qwiker_customer_app/appStyles/app_images.dart';
import 'package:qwiker_customer_app/appStyles/app_strings.dart';
import 'package:qwiker_customer_app/models/message_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
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
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        surfaceTintColor: AppColors.backgroundColor,
        leadingWidth: MediaQuery.of(context).size.width * 0.2,
        titleSpacing: MediaQuery.of(context).size.width * 0.005,
        leading: IconButton(
          onPressed: null,
          icon: ClipRRect(
            borderRadius: BorderRadius.circular(
              MediaQuery.of(context).size.height * AppDimensions.borderRadius50,
            ),
            child: Image.asset(
              AppImages.driver,
            ),
          ),
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.driverName,
              style: TextStyle(
                color: AppColors.blackColor,
                fontSize: MediaQuery.of(context).size.height *
                    AppDimensions.fontSize16,
                fontFamily: AppFonts.poppinsMedium,
              ),
            ),
            Text(
              'Active Now',
              style: TextStyle(
                color: AppColors.mediumTextGreyColor,
                fontSize: MediaQuery.of(context).size.height *
                    AppDimensions.fontSize12,
                fontFamily: AppFonts.poppinsMedium,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close,
              size: MediaQuery.of(context).size.height * 0.025,
              color: AppColors.blackColor,
            ),
          ),
        ],
        toolbarHeight: MediaQuery.of(context).size.height * 0.07,
      ),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width * double.infinity,
            child: ListView.builder(
              itemCount: messageModel.length,
              shrinkWrap: true,
              padding: EdgeInsets.all(
                MediaQuery.of(context).size.height * AppDimensions.padding1,
              ),
              itemBuilder: (context, index) {
                return Align(
                  alignment: messageModel[index].messageType == "driver"
                      ? Alignment.topLeft
                      : Alignment.topRight,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.065,
                    width: MediaQuery.of(context).size.width * 0.55,
                    margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height *
                          AppDimensions.padding1,
                    ),
                    padding: EdgeInsets.all(
                      MediaQuery.of(context).size.height *
                          AppDimensions.padding1,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: messageModel[index].messageType == "driver"
                          ? BorderRadius.only(
                              topRight: Radius.circular(
                                MediaQuery.of(context).size.height * 0.02,
                              ),
                              topLeft: Radius.circular(
                                MediaQuery.of(context).size.height * 0.02,
                              ),
                              bottomRight: Radius.circular(
                                MediaQuery.of(context).size.height * 0.02,
                              ),
                            )
                          : BorderRadius.only(
                              topLeft: Radius.circular(
                                MediaQuery.of(context).size.height * 0.02,
                              ),
                              bottomLeft: Radius.circular(
                                MediaQuery.of(context).size.height * 0.02,
                              ),
                              topRight: Radius.circular(
                                MediaQuery.of(context).size.height * 0.02,
                              ),
                            ),
                      color: messageModel[index].messageType == "driver"
                          ? AppColors.whiteColor
                          : AppColors.blueColor,
                    ),
                    child: Center(
                      child: Text(
                        messageModel[index].messageContent,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height *
                              AppDimensions.fontSize16,
                          fontFamily: AppFonts.poppinsMedium,
                          color: messageModel[index].messageType == "driver"
                              ? AppColors.blackColor
                              : AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              elevation: 3,
              color: AppColors.whiteColor,
              margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
              child: TextField(
                cursorColor: AppColors.mediumGreyColor,
                decoration: InputDecoration(
                  fillColor: AppColors.whiteColor,
                  filled: true,
                  hintText: AppStrings.typeMessage,
                  hintStyle: TextStyle(
                      color: AppColors.mediumGreyColor,
                      fontFamily: AppFonts.poppinsMedium,
                      fontSize: MediaQuery.of(context).size.height * 0.016),
                  suffixIcon: IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.mic_rounded,
                      color: AppColors.greyColor,
                      size: MediaQuery.of(context).size.height * 0.028,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.height *
                          AppDimensions.borderRadius50,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.height *
                          AppDimensions.borderRadius50,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.height *
                          AppDimensions.borderRadius50,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.height *
                          AppDimensions.borderRadius50,
                    ),
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
