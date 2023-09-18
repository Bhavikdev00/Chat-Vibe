import 'dart:io';

import 'package:chatvibe/Controllers/image_send_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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
      "msgType": "text",
      "read": false
    });
  }

  Future updateChat(
      {required String roomId,
      required String message,
      required String msgId}) async {
    await chatRoom.doc(roomId).collection("chats").doc(msgId).update({
      'msg': message,
    });
  }

  void setStatus(String status) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc("${box.read("uId")}")
        .update({"status": status, "lastActive": DateTime.now()});
  }

  static Future sendImage(
      {required String roomId,
      required File? image,
      required String myId}) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    ImageSendIndicator.isLoading();
    String imageUrl = "";
    DateTime date = DateTime.now();
    await storage.ref("Images/${date}.png").putFile(image!).then(
      (p0) async {
        imageUrl = await p0.ref.getDownloadURL();
        await chatRoom.doc(roomId).collection("chats").doc().set({
          "msg": imageUrl,
          "DateTime": date,
          "senderId": myId,
          "msgType": "image",
          "read": false
        });
        ImageSendIndicator.isLoading();

        Get.back();
      },
    );
  }
}
