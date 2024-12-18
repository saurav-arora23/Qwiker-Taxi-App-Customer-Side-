import 'package:qwiker_customer_app/appStyles/app_strings.dart';

class HistoryModel {
  String pickUpLocation;
  String dropLocation;
  String rideFare;
  String rideDate;
  String rideStatus;

  HistoryModel(this.pickUpLocation, this.dropLocation, this.rideFare,
      this.rideDate, this.rideStatus);
}

List<HistoryModel> historyModel = [
  HistoryModel(
    AppStrings.address3,
    AppStrings.address4,
    '\$52',
    '12/11/2024',
    AppStrings.completed,
  ),
  HistoryModel(
    AppStrings.address3,
    AppStrings.address4,
    '\$52',
    '12/11/2024',
    AppStrings.cancel,
  ),
];
