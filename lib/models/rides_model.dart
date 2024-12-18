import 'package:qwiker_customer_app/appStyles/app_images.dart';
import 'package:qwiker_customer_app/appStyles/app_strings.dart';

class RidesModel {
  String vehicleImage;
  String vehicleCategory;
  String vehicleCapacity;
  String rideFare;
  bool rideSelected;
  RidesModel(this.vehicleImage, this.vehicleCategory, this.vehicleCapacity,
      this.rideFare,this.rideSelected);
}

List<RidesModel> ridesModel = [
  RidesModel(
    AppImages.microCab,
    AppStrings.micro,
    AppStrings.fivePersons,
    '\$20.00',
    false,
  ),
  RidesModel(
    AppImages.auto,
    AppStrings.balaJi,
    AppStrings.fourPersons,
    '\$10.00',
    false
  ),
  RidesModel(
    AppImages.bike,
    AppStrings.bike,
    AppStrings.onePerson,
    '\$5.00',
    false,
  ),
  RidesModel(
    AppImages.miniCab,
    AppStrings.mini,
    AppStrings.fivePersons,
    '\$15.00',
    false,
  ),
];
