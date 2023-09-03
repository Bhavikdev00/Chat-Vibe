import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CountFrdRequest {
  final box = GetStorage();
  RxInt countRequests = 0.obs;
  RxInt countFriends = 0.obs;
  Future CountFrdRequestData() async {
    var data3 = await FirebaseFirestore.instance
        .collection("users")
        .doc(box.read("uId"))
        .collection("friend_requests")
        .snapshots();

    data3.listen((event) {
      countRequests.value = 0;
      print("CALL");
      event.docs.forEach((element) {
        countRequests.value++;
      });
    });

    var data2 = await FirebaseFirestore.instance
        .collection("users")
        .doc(box.read("uId"))
        .collection("friends")
        .snapshots();

    data2.listen((event) {
      countFriends.value = 0;
      event.docs.forEach((element) {
        countFriends.value++;
      });
    });
  }
}
