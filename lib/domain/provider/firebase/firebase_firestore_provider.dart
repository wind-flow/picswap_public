import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fbfsInstanceProvider = Provider<FirebaseFirestore>((ref) {
  final fbfs = FirebaseFirestore.instance;
  return fbfs;
});
