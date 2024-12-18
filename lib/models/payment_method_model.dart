import 'package:qwiker_customer_app/appStyles/app_images.dart';
import 'package:qwiker_customer_app/appStyles/app_strings.dart';

class PaymentMethodModel {
  String categoryImage;
  String categoryName;
  String categoryExpiryDate;
  bool paymentSelected;
  PaymentMethodModel(this.categoryImage, this.categoryName,
      this.categoryExpiryDate, this.paymentSelected);
}

List<PaymentMethodModel> paymentMethodModel = [
  PaymentMethodModel(
      AppImages.visa, '**** **** **52 2457', 'Expiry 04 july 2025', false),
  PaymentMethodModel(AppImages.payPal, AppStrings.paypal, '', false),
  PaymentMethodModel(AppImages.cash, AppStrings.cash, '', true),
];

class SelectPaymentMethodModel {
  String paymentMethodImage;
  bool paymentMethodSelected;
  SelectPaymentMethodModel(this.paymentMethodImage, this.paymentMethodSelected);
}

List<SelectPaymentMethodModel> selectPaymentMethodModel = [
  SelectPaymentMethodModel(AppImages.stripe, true),
  SelectPaymentMethodModel(AppImages.payStack, false),
  SelectPaymentMethodModel(AppImages.flutterWave, false),
  SelectPaymentMethodModel(AppImages.razorPay, false),
  SelectPaymentMethodModel(AppImages.cashFree, false),
];

class CardModel {
  String bankName;
  String cardImage;
  String cardNumber;
  String cardHolderName;
  String cardExpiryDate;
  String cardCVV;
  String accountType;

  CardModel(this.bankName, this.cardImage, this.cardNumber, this.cardHolderName,
      this.cardExpiryDate, this.cardCVV, this.accountType);
}

List<CardModel> cardModel = [
  CardModel(
      AppStrings.bankName,
      AppImages.visa,
      '5100      4560      4000      7587',
      'Mr. Frank Smith',
      '02/25',
      '522',
      AppStrings.primaryAccount)
];
