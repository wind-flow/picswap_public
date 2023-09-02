import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageRepository {
  late FirebaseStorage storage;
  late Reference storageRef;

  FirebaseStorageRepository() {
    storage = FirebaseStorage.instance;
  }

  Future<String> uploadFile(File file, String uploadPath) async {
    try {
      storageRef = storage.ref(uploadPath);
      await storageRef.putFile(file);
      String downloadUrl = await storageRef.getDownloadURL();
      print(downloadUrl);
      return downloadUrl;
    } on FirebaseException catch (e) {
      throw e.toString();
    }
  }
}
