import 'package:freezed_annotation/freezed_annotation.dart';

enum SocialType {
  apple,
  google,
  facebook,
}

enum MessageType {
  alert,
  message,
}

enum AdType {
  opening,
  banner,
  interstitial,
  native,
  rewarded,
  rewardedInterstitial,
}

enum MenuType {
  // share,
  chat,
  report,
  // refresh,
  // block,
}

enum ReportType {
  @JsonValue('abuse')
  abuse,
  @JsonValue('lewdness')
  lewdness,
  @JsonValue('etc')
  etc,
}

enum ItemGrade {
  bronze,
  silver,
  gold,
}

enum ItemType {
  token,
  chat,
}
