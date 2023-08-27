import 'package:fluttertoast/fluttertoast.dart';

void showCustomToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength:  Toast.LENGTH_LONG,
  );
}
