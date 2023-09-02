import 'package:easy_localization/easy_localization.dart';

extension StringExtension on String {
  String localize({Map<String, String>? namedArgs}) {
    return tr(this, namedArgs: namedArgs);
  }

  bool isNetworkImage() {
    final RegExp regExp = RegExp(r"^https?:\/\/");
    return regExp.hasMatch(this);
  }

  //이메일 포맷 검증
  bool isValidEmailFormat() {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(this);
  }

  //대쉬를 포함하는 010 휴대폰 번호 포맷 검증 (010-1234-5678)
  bool isValidPhoneNumberFormat() {
    return RegExp(r'^010-?([0-9]{4})-?([0-9]{4})$').hasMatch(this);
  }
}

extension StringExtensions on String? {
  bool isNullOrEmpty() => this == null || this?.isEmpty == true;
  bool isNotEmpty() => this != null && this?.isEmpty == false;
  int? parseInt() => this == null ? null : int.parse(this!);
  double parseDouble() => this == null ? 0 : double.parse(this!);
}

int compareVersions(String version1, String version2) {
  // 버전을 각각의 세그먼트로 분할
  List<int> segments1 = version1.split('.').map(int.parse).toList();
  List<int> segments2 = version2.split('.').map(int.parse).toList();

  // 각 세그먼트를 순서대로 비교
  for (int i = 0; i < segments1.length; i++) {
    if (i >= segments2.length) {
      // version1은 더 많은 세그먼트를 가지고 있으므로 version2는 더 이전 버전
      return 1;
    }

    if (segments1[i] < segments2[i]) {
      // 현재 세그먼트에서 version1이 더 작으므로 version1은 더 이전 버전
      return -1;
    } else if (segments1[i] > segments2[i]) {
      // 현재 세그먼트에서 version1이 더 크므로 version1은 더 최신 버전
      return 1;
    }
  }

  if (segments1.length < segments2.length) {
    // version1은 더 적은 세그먼트를 가지고 있으므로 version1은 더 이전 버전
    return -1;
  }

  // 모든 세그먼트가 동일하므로 두 버전은 동일한 버전
  return 0;
}
