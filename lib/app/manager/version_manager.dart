import 'package:upgrader/upgrader.dart';

class OtherMessages extends UpgraderMessages {
  /// Override the message function to provide custom language localization.
  @override
  String message(UpgraderMessage messageKey) {
    if (languageCode == 'es') {
      switch (messageKey) {
        case UpgraderMessage.body:
          return 'es A new version of {{appName}} is available!';
        case UpgraderMessage.buttonTitleIgnore:
          return 'es Ignore';
        case UpgraderMessage.buttonTitleLater:
          return 'es Later';
        case UpgraderMessage.buttonTitleUpdate:
          return 'es Update Now';
        case UpgraderMessage.prompt:
          return 'es Want to update?';
        case UpgraderMessage.title:
          return 'es Update App?';
        case UpgraderMessage.releaseNotes:
          return 'es Update releaseNote?';
      }
    }
    // Messages that are not provided above can still use the default values.
    return super.message(messageKey)!;
  }
}
