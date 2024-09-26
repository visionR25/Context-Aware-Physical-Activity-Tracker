//Created by MansoorSatti 8/7/2024
import 'package:get/get.dart';

String? isEmailVerified(String? value) {
  if (value!.isEmpty) {
    return "Required";
  } else if (!GetUtils.isEmail(value)) {
    return "Enter a valid email";
  }
  return null;
}

String? isNameVerified(String? value) {
  if (value!.isEmpty) {
    return "Required";
  } else if (!GetUtils.isUsername(value)) {
    return "Enter a valid user name";
  }
  return null;
}
