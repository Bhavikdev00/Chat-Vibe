import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileDataController extends GetxController {
  final box = GetStorage();
  Map<String, dynamic> profileData = {};
  bool b = false;
  Future getProfileData() async {
    b = true;
    update();
    var data = await FirebaseFirestore.instance
        .collection("users")
        .doc(box.read("uId"))
        .get();
    profileData = data.data() as Map<String, dynamic>;
    b = false;
    update();
  }
}
