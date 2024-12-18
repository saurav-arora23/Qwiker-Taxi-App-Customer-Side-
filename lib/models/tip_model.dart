class TipModel {
  String tipPrice;
  bool tipSelected;
  TipModel(this.tipPrice, this.tipSelected);
}

List<TipModel> tipModel = [
  TipModel('\$10', false),
  TipModel('\$20', false),
  TipModel('\$30', false),
];

class AddMoneyModel {
  int amount;
  bool amountSelected;
  AddMoneyModel(this.amount, this.amountSelected);
}

List<AddMoneyModel> addMoneyModel = [
  AddMoneyModel(100, true),
  AddMoneyModel(500, false),
  AddMoneyModel(1000, false),
];
