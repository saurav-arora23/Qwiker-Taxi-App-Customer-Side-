import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseModel {
  QueryDocumentSnapshot snapshot;
  bool isSelected;

  FirebaseModel({
    required this.snapshot,
    required this.isSelected,
  });
}
