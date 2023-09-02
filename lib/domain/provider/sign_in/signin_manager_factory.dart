import 'package:picswap/domain/provider/sign_in/apple_login_manager.dart';

import '../../../app/manager/enums.dart';
import 'facebook_login_manager.dart';
import 'google_login_manager.dart';
import 'signin_manager_interface.dart';

class LoginManagerFactory {
  LoginManagerInterface getManager(SocialType type) {
    switch (type) {
      case SocialType.apple:
        return AppleLoginManager();
      case SocialType.google:
        return GoogleLoginManager();
      case SocialType.facebook:
        return FacebookLoginManager();
    }
  }
}
