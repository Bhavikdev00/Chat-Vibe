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
    CollectionReference myFriendsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('friends');

    myFriendsCollection.doc(friendUid).set({
      'Date': DateTime.now(),
    });

    CollectionReference friendFriendsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(friendUid)
        .collection('friends');

    // Add your UID to friend's friends collection
    friendFriendsCollection.doc(userUid).set({
      'timestamp': FieldValue.serverTimestamp(),
    });
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
