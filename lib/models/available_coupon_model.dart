import 'package:qwiker_customer_app/appStyles/app_images.dart';
import 'package:qwiker_customer_app/appStyles/app_strings.dart';

class AvailableCouponModel {
  String couponImage;
  String couponTitle;
  String couponSubtitle;
  bool couponSelected;
  AvailableCouponModel(this.couponImage, this.couponTitle, this.couponSubtitle,
      this.couponSelected);
}

List<AvailableCouponModel> availableCouponModel = [
  AvailableCouponModel(AppImages.couponScreen, AppStrings.couponTitle1,
      AppStrings.couponDes1, false),
  AvailableCouponModel(AppImages.couponScreen, AppStrings.couponTitle2,
      AppStrings.couponDes2, true),
  AvailableCouponModel(AppImages.couponScreen, AppStrings.couponTitle1,
      AppStrings.couponDes1, false),
];
