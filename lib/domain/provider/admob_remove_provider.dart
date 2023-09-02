import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/manager/storage/preference_storage.dart';

final adRemoveState = StateProvider<bool>((ref) {
  final store = ref.watch(preferenceStorageProvider);
  return false;
});
