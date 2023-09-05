import 'package:get/get.dart';

class ImageSendIndicator {
  static RxBool bool = false.obs;

  static void isLoading() {
    bool.value = !bool.value;
  }
}
