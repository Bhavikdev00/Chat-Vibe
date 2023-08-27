import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FriendServices {
  // Function to send a friend request
  Future<void> sendFriendRequest(String senderUid, String recipientUid) async {
    // Add a friend request document to recipient's subcollection
    await FirebaseFirestore.instance
        .collection('users')
        .doc(recipientUid)
        .collection('friend_requests')
        .doc(senderUid)
        .set({'timestamp': DateTime.now()});
  }

// Function to accept a friend request
  Future<void> acceptFriendRequest(String userUid, String friendUid) async {
    // Add each other's UIDs to friend lists
    var data = await FirebaseFirestore.instance
        .collection("users")
        .doc(friendUid)
        .get();

    Map<String, dynamic> frdData = data.data() as Map<String, dynamic>;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection("friends")
        .doc(friendUid)
        .set({
      "friendUid": friendUid,
      "username": frdData['username'],
    });
    var myData =
        await FirebaseFirestore.instance.collection("users").doc(userUid).get();

    Map<String, dynamic> myDataMap = myData.data() as Map<String, dynamic>;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(friendUid)
        .collection("friends")
        .doc(userUid)
        .set({
      "friendUid": userUid,
      "username": myDataMap['username'],
    });

    // Delete the friend request document
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('friend_requests')
        .doc(friendUid)
        .delete();
  }

// Function to reject a friend request
  Future<void> rejectFriendRequest(String userUid, String friendUid) async {
    // Delete the friend request document
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('friend_requests')
        .doc(friendUid)
        .delete();
  }
}

class FriendsServicesController extends GetxController {}
