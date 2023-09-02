import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import '../../../app/utils/log.dart';
import 'signin_manager_interface.dart';

class AppleLoginManager extends LoginManagerInterface {
  @override
  Future<String?> login() async {
    try {
      final AppleAuthProvider provider = AppleAuthProvider()
        ..addScope('email')
        ..addScope('name');
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithProvider(provider);
      if (Platform.isAndroid) {
        return await userCredential.user?.getIdToken();
      }
      return userCredential.credential?.accessToken;
    } catch (e) {
      Log.e('failed to login with apple = $e');
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
