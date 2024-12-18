import 'package:qwiker_customer_app/appStyles/app_strings.dart';

class RecentLocationModel {
  String title;
  String address;
  bool selected;
  RecentLocationModel(this.title, this.address, this.selected);
}

List<RecentLocationModel> recentLocationModel = [
  RecentLocationModel(
    AppStrings.home,
    AppStrings.address3,
    true,
  ),
  RecentLocationModel(
    AppStrings.work,
    AppStrings.address4,
    false,
  ),
];