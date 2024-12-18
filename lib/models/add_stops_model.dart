import 'package:qwiker_customer_app/appStyles/app_strings.dart';

class AddStopsModel {
  String time;
  String hint;
  AddStopsModel(this.time,this.hint);
}

List<AddStopsModel> addStopsModel = [
  AddStopsModel(
    '02:30 PM',
    AppStrings.enterDestination,
  ),
];
