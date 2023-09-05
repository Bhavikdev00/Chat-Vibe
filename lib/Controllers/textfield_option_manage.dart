import 'package:get/get.dart';

class TextFieldOptionManage {
  static RxBool show = true.obs;

  static void setTrue() {
    show.value = true;
    print("${show.value}");
  }

  static void setFrue() {
    show.value = false;
    print("${show.value}");
  }
}
