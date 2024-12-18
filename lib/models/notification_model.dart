import 'package:qwiker_customer_app/appStyles/app_strings.dart';

class NotificationModel {
  String notificationTitle;
  String notificationDes;
  bool notificationSeen;
  NotificationModel(
      this.notificationTitle, this.notificationDes, this.notificationSeen);
}

List<NotificationModel> notificationModel = [
  NotificationModel(
    AppStrings.notificationTitle1,
    AppStrings.notificationDes2,
    false,
  ),
  NotificationModel(
    AppStrings.notificationTitle2,
    AppStrings.notificationDes1,
    false,
  ),
  NotificationModel(
    AppStrings.notificationTitle1,
    AppStrings.notificationDes3,
    true,
  ),
  NotificationModel(
    AppStrings.notificationTitle2,
    AppStrings.notificationDes1,
    true,
  ),
  NotificationModel(
    AppStrings.notificationTitle1,
    AppStrings.notificationDes2,
    true,
  ),
  NotificationModel(
    AppStrings.notificationTitle2,
    AppStrings.notificationDes1,
    true,
  ),
];
