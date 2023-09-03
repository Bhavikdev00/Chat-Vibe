// Import necessary packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// Define a class to manage counting friend requests and friends
class CountFrdRequest {
  final box = GetStorage();
  RxInt countRequests = 0.obs;
  RxInt countFriends = 0.obs;

  // A function to retrieve and update friend request and friend counts
  Future CountFrdRequestData() async {
    // Retrieve friend requests data from Firestore
    var friendRequestsData = await FirebaseFirestore.instance
        .collection("users")
        .doc(box.read("uId"))
        .collection("friend_requests")
        .snapshots();

    // Listen for changes in friend requests data
    friendRequestsData.listen((event) {
      // Reset the count before updating it
      countRequests.value = 0;
      print("CALL");
      // Count the number of friend requests
      event.docs.forEach((element) {
        countRequests.value++;
      });
    });

    // Retrieve friends data from Firestore
    var friendsData = await FirebaseFirestore.instance
        .collection("users")
        .doc(box.read("uId"))
        .collection("friends")
        .snapshots();

    // Listen for changes in friends data
    friendsData.listen((event) {
      // Reset the count before updating it
      countFriends.value = 0;
      // Count the number of friends
      event.docs.forEach((element) {
        countFriends.value++;
      });
    });
  }
}
