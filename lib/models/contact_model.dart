class ContactModel {
  String contactProfile;
  String contactName;
  String contactNumber;
  bool contactInvited;
  ContactModel(this.contactProfile, this.contactName, this.contactNumber,
      this.contactInvited);
}

List<ContactModel> contactModel = [
  ContactModel('JR', 'Johnny Rios', '+92 8554449874', false),
  ContactModel('MK', 'Manoj Kumar', '+92 9554449874', true),
  ContactModel('JR', 'Johnny Rios', '+92 8554449874', true),
  ContactModel('JR', 'Johnny Rios', '+92 8554449874', false),
  ContactModel('JR', 'Johnny Rios', '+92 8554449874', false),
  ContactModel('JR', 'Johnny Rios', '+92 8554449874', false),
  ContactModel('JR', 'Johnny Rios', '+92 8554449874', true),
  ContactModel('JR', 'Johnny Rios', '+92 8554449874', false),
  ContactModel('JR', 'Johnny Rios', '+92 8554449874', false),
  ContactModel('JR', 'Johnny Rios', '+92 8554449874', false),
];
