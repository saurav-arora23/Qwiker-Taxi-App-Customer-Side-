class LanguageModel {
  String language;
  bool languageSelected;
  LanguageModel(this.language, this.languageSelected);
}

List<LanguageModel> languageModel = [
  LanguageModel('English', true),
  LanguageModel('Hindi', false),
  LanguageModel('Spanish', false),
  LanguageModel('Arabic', false),
  LanguageModel('French', false),
  LanguageModel('Turkish', false),
  LanguageModel('Russian', false),
  LanguageModel('Italian', false),
  LanguageModel('German', false),
  LanguageModel('Korean', false),
  LanguageModel('Chinese(PRC)', false),
  LanguageModel('Portuguese', false),
];
