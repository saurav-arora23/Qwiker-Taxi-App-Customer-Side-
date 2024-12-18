class MessageModel {
  String messageContent;
  String messageType;
  MessageModel(this.messageContent, this.messageType);
}

List<MessageModel> messageModel = [
  MessageModel('Hello, are you nearby?', 'user'),
  MessageModel('I will be there in a few mins', 'driver'),
  MessageModel('Okay, I am waiting at my location', 'user'),
  MessageModel(
      'Sorry, I am stuck in traffic. Please give me a more time', 'driver')
];

class SosMessageModel {
  String messageContent;
  String messageType;
  double lat;
  double long;
  SosMessageModel(this.messageContent, this.messageType, this.lat, this.long);
}

List<SosMessageModel> sosMessageModel = [
  SosMessageModel(
    'Someone is following me i can not focus but the have been on me. I will be sharing me location with you guys',
    'user',
    0,
    0,
  ),
  SosMessageModel(
    'Its my location now',
    'user',
    30.704649,
    76.717873,
  ),
  SosMessageModel(
    'Okay i am coming ',
    'contact',
    0,
    0,
  ),
];
