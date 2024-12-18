import 'package:qwiker_customer_app/appStyles/app_images.dart';
import 'package:qwiker_customer_app/appStyles/app_strings.dart';

class SliderModel {
  String image;
  String name;
  String des;
  SliderModel(this.image, this.name, this.des);
}

List<SliderModel> contents = [
  SliderModel(
    AppImages.onBoarding1,
    AppStrings.onBoardingTitle1,
    AppStrings.onBoardingDes1,
  ),
  SliderModel(
    AppImages.onBoarding2,
    AppStrings.onBoardingTitle2,
    AppStrings.onBoardingDes2,
  ),
  SliderModel(
    AppImages.onBoarding3,
    AppStrings.onBoardingTitle3,
    AppStrings.onBoardingDes3,
  ),
];
