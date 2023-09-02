import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../../../app/utils/log.dart';
import 'signin_manager_interface.dart';

class FacebookLoginManager extends LoginManagerInterface {
  @override
  Future<String?> login() async {
    try {
      final user = await signInWithFacebook();
      return user.credential?.accessToken;
    } catch (e) {
      Log.e('failed to login with apple = $e');
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<UserCredential> signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      // Once signed in, return the UserCredential
      return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    } catch (e) {
      throw e.toString();
    }
  }
}
