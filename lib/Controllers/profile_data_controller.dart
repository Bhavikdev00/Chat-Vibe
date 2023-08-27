import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileDataController extends GetxController {
  final box = GetStorage();
  Map<String, dynamic> profileData = {};
  List friendsData = [];
  List friendRequests = [];
  bool b = false;
  Future getProfileData() async {
    b = true;
    update();
    var data = await FirebaseFirestore.instance
        .collection("users")
        .doc(box.read("uId"))
        .get();
    profileData = data.data() as Map<String, dynamic>;
    var data2 = await FirebaseFirestore.instance
        .collection("users")
        .doc(box.read("uId"))
        .collection("friends")
        .get();

    data2.docs.forEach((element) {
      Map dd = element.data();
      friendsData.add(dd);
    });
    var data3 = await FirebaseFirestore.instance
        .collection("users")
        .doc(box.read("uId"))
        .collection("friend_requests")
        .get();

    data3.docs.forEach((element) {
      Map dd = element.data();
      friendRequests.add(dd);
    });
    print(profileData);
    print(friendsData);
    b = false;
    update();
  }
}
