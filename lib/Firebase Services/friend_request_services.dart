import 'package:chatvibe/Controllers/Friends_data_controller.dart';
import 'package:chatvibe/Firebase%20Services/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../Controllers/online_friends_data_controller.dart';

class FriendServices {
  static FriendsDataController _friendsDataController = Get.find();
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
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('friend_requests')
        .doc(friendUid)
        .delete();

    CollectionReference friendFriendsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(friendUid)
        .collection('friends');

    // Add your UID to friend's friends collection
    friendFriendsCollection.doc(userUid).set({
      'timestamp': FieldValue.serverTimestamp(),
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(friendUid)
        .collection('friend_requests')
        .doc(userUid)
        .delete();

    _friendsDataController.getFriendsData();
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

  static Future<void> deleteFriend(String userUid, String friendUid) async {
    // Delete the friend record from the user's friends collection
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('friends')
        .doc(friendUid)
        .delete();

    Map result = await ChatServices.isChatRoomExist(userUid, friendUid);

    if (result["isExist"] != false) {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(result["chatRoomId"])
          .update({});
    }

    // Delete the chat history between the user and the friend (only from user's device)

    _friendsDataController.getFriendsData();
  }
}
