import 'package:fluttertoast/fluttertoast.dart';

Future<void> showToast(String message) async {
  showLongToast(message);
}

Future<void> showLongToast(String message) async {
  await Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: message,
    gravity: ToastGravity.TOP,
    toastLength: Toast.LENGTH_LONG,
    timeInSecForIosWeb: 3,
  );
}

Future<void> cancelToast() async {
  await Fluttertoast.cancel();
}
