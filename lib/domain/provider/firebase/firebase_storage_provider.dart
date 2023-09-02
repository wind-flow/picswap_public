import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fbstorageProvider = Provider<FirebaseStorage>((ref) {
  final FirebaseStorage storage = FirebaseStorage.instance;

  return storage;
});
