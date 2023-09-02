import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final preferenceStorageProvider = Provider((ref) {
  final pref = SharedPreferences.getInstance();

  return pref;
});
