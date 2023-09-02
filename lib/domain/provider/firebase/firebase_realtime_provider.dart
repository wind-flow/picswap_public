import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/manager/constants.dart';
import '../../model/fbrtdb_model.dart';

final fbrtdbRoomProvider = Provider<FbrtdbModel>((ref) {
  final fbrtdbModel = FbrtdbModel(
      roomRef: FirebaseDatabase.instanceFor(
              databaseURL: AppConstants.firebaseDatabaseUrl,
              app: Firebase.app())
          .ref('rooms'),
      messageRef: FirebaseDatabase.instanceFor(
              databaseURL: AppConstants.firebaseDatabaseUrl,
              app: Firebase.app())
          .ref('messages'));

  return fbrtdbModel;
});
