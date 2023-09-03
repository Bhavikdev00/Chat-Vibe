import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

class ChatServices {
  final box = GetStorage();
  static CollectionReference chatRoom =
      FirebaseFirestore.instance.collection("chatRoom");

  static Future isChatRoomExist(String id1, String id2) async {
    var room1 = await chatRoom.doc("$id1-$id2").get();
    var room2 = await chatRoom.doc("$id2-$id1").get();

    bool isExist = false;
    String currectRoomId = "";
    if (room1.exists) {
      currectRoomId = "$id1-$id2";
      isExist = true;
    }
    if (room2.exists) {
      currectRoomId = "$id2-$id1";
      isExist = true;
    }
    return {"isExist": isExist, "chatRoomId": currectRoomId};
  }

  Future sendChat({required String roomId, required String message}) async {
    await chatRoom.doc(roomId).collection("chats").doc().set({
      "msg": message,
      "DateTime": DateTime.now(),
      "senderId": box.read("uId"),
      "read": false
    });
  }

  void setStatus(String status) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc("${box.read("uId")}")
        .update({"status": status, "lastActive": DateTime.now()});
  }
}
