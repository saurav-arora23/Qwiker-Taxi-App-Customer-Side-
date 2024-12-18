import 'package:flutter/material.dart';
import 'package:qwiker_customer_app/appStyles/app_colors.dart';
import 'package:qwiker_customer_app/appStyles/app_strings.dart';

class DrawerMenuModel {
  String menu;
  DrawerMenuModel(this.menu);
}

List<DrawerMenuModel> drawerMenuModel = [
  DrawerMenuModel(AppStrings.myAccountTitle),
  DrawerMenuModel(AppStrings.inviteFriendsTitle),
  DrawerMenuModel(AppStrings.faqTitle),
  DrawerMenuModel(AppStrings.sosTitle),
  DrawerMenuModel(AppStrings.complaintsTitle),
  DrawerMenuModel(AppStrings.notificationTitle),
  DrawerMenuModel(AppStrings.aboutTitle),
  DrawerMenuModel(AppStrings.privacyPolicyTitle),
  DrawerMenuModel(AppStrings.termsConditionTitle),
];

class QuickLinkMenu {
  Icon menuIcons;
  String menu;
  QuickLinkMenu(this.menuIcons, this.menu);
}

List<QuickLinkMenu> quickLinkMenu = [
  QuickLinkMenu(
    const Icon(
      Icons.history,
      color: AppColors.lightBlackColor,
      size: 22,
    ),
    AppStrings.historyTitle,
  ),
  QuickLinkMenu(
    const Icon(
      Icons.add_location_alt_outlined,
      color: AppColors.lightBlackColor,
      size: 22,
    ),
    AppStrings.changeLanguageTitle,
  ),
  QuickLinkMenu(
    const Icon(
      Icons.account_balance_wallet_outlined,
      color: AppColors.lightBlackColor,
      size: 22,
    ),
    AppStrings.walletTitle,
  ),
  QuickLinkMenu(
    const Icon(
      Icons.password_rounded,
      color: AppColors.lightBlackColor,
      size: 22,
    ),
    AppStrings.changePasswordTitle,
  ),
];
