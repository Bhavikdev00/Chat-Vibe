import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:record/record.dart';

class RecordHelper {
  static String myId = FirebaseAuth.instance.currentUser!.uid;
  static Record audioRecord = Record();
  static AudioPlayer player = AudioPlayer();
  static String? path;
  static RxBool isRecording = false.obs;
  static Future<void> startRecording() async {
    if (await audioRecord.hasPermission()) {
      await audioRecord.start();
      isRecording.value = true;
    }
  }

  static Future<void> stopRecording() async {
    if (await audioRecord.hasPermission()) {
      path = await audioRecord.stop();
      print("$path");
      isRecording.value = false;
    }
  }

  static Future<void> playRecording(String url) async {
    print(player);
    await player.play(UrlSource(url));
  }

  static Future<void> uploadRecordingToFirebase(String roomId) async {
    if (path != null) {
      try {
        DateTime date = DateTime.now();
        Reference audioRef =
            FirebaseStorage.instance.ref().child('audio/$date.mp3');
        UploadTask uploadTask = audioRef.putFile(File(path!));

        // Wait for the upload to complete
        await uploadTask.whenComplete(() {
          print('Audio uploaded to Firebase Storage');
        });

        // Get the download URL of the uploaded audio
        String downloadUrl = await audioRef.getDownloadURL();

        print('Download URL: $downloadUrl');
        FirebaseFirestore.instance
            .collection("chatRoom")
            .doc(roomId)
            .collection("chats")
            .doc()
            .set({
          "msg": downloadUrl,
          "DateTime": date,
          "like": [],
          "senderId": myId,
          "msgType": "mp3",
          "read": false
        });
      } catch (error) {
        print('Error uploading audio: $error');
      }
    }
  }
}
