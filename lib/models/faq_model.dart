import 'package:qwiker_customer_app/appStyles/app_strings.dart';

class FaqModel {
  String question;
  String answer;
  bool selected;
  FaqModel(this.question, this.answer, this.selected);
}

List<FaqModel> faqModel = [
  FaqModel(
    AppStrings.faqQuestionTitle1,
    AppStrings.faqAnswerDes,
    false,
  ),
  FaqModel(
    AppStrings.faqQuestionTitle2,
    AppStrings.faqAnswerDes,
    false,
  ),
  FaqModel(
    AppStrings.faqQuestionTitle3,
    AppStrings.faqAnswerDes,
    false,
  ),
  FaqModel(
    AppStrings.faqQuestionTitle1,
    AppStrings.faqAnswerDes,
    false,
  ),
  FaqModel(
    AppStrings.faqQuestionTitle4,
    AppStrings.faqAnswerDes,
    false,
  ),
  FaqModel(
    AppStrings.faqQuestionTitle1,
    AppStrings.faqAnswerDes,
    false,
  ),
];
