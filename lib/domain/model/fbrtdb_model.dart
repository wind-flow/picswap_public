import 'package:firebase_database/firebase_database.dart';

class FbrtdbModel {
  final DatabaseReference roomRef;
  final DatabaseReference messageRef;

  FbrtdbModel({
    required this.roomRef,
    required this.messageRef,
  });
}
