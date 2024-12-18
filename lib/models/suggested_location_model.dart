import 'package:qwiker_customer_app/appStyles/app_strings.dart';

class SuggestedLocationModel {
  String address;
  SuggestedLocationModel(this.address);
}

List<SuggestedLocationModel> suggestedLocationModel = [
  SuggestedLocationModel(
    AppStrings.address1,
  ),
  SuggestedLocationModel(
    AppStrings.address2,
  ),
  SuggestedLocationModel(
    AppStrings.address3,
  ),
  SuggestedLocationModel(
    AppStrings.address4,
  ),
];
