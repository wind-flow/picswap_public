class ImageAsset {
  static const String splashLogo = "logo_white.svg";
  static const String mainLogoPink = "logo_pink.svg";
  static const String emptyImage = "empty_image.svg";
  static const String errorImage = "error_image.svg";
  static const String generateImage = "generate_button.svg";
  static const String waitIconImage = "wait_icon.svg";
  static const String versionImage = "version.svg";
  static const String loadingImage = "loading_spinner.gif";

  static String tutorial({required String locale, required int step}) {
    return 'ko_KR_tutorial_$step.png';
  }
}
