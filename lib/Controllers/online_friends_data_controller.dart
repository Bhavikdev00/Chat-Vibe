import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OnlineFrdDataController extends GetxController {
  List onlineFrdData = [];

  // Function to retrieve online friend data
  void getData() async {
    final box = GetStorage();

    // Reference to the user's friends collection in Firestore
    CollectionReference myFriendsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(box.read("uId"))
        .collection('friends');

    // Retrieve the list of friend UIDs
    QuerySnapshot querySnapshot = await myFriendsCollection.get();
    List<String> friendUids = querySnapshot.docs.map((doc) => doc.id).toList();

    // Iterate through each friend UID to check their online status
    friendUids.forEach((element) {
      var d = FirebaseFirestore.instance
          .collection("users")
          .doc(element)
          .snapshots();

      // Listen for changes in the friend's document
      d.listen((event) {
        onlineFrdData.clear(); // Clear the list before updating
        update();

        Map data = event.data() as Map;

        if (data['status'] == "Online") {
          onlineFrdData.add(event.data()); // Add online friend data
        }

        update(); // Notify the UI of changes
      });
    });
  }
}
