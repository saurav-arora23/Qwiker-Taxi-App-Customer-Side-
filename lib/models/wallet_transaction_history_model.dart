import 'package:qwiker_customer_app/appStyles/app_strings.dart';

class WalletTransactionHistoryModel {
  String depositBy;
  int amount;
  String date;
  WalletTransactionHistoryModel(this.depositBy, this.amount, this.date);
}

List<WalletTransactionHistoryModel> walletTransactionHistoryModel = [
  WalletTransactionHistoryModel(
      AppStrings.moneyDeposited, 200000, '14th Sep 02:50 PM'),
];
