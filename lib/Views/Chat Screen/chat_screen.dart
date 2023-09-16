import 'dart:io';

import 'package:chatvibe/Controllers/textfield_option_manage.dart';
import 'package:chatvibe/Firebase%20Services/chat_services.dart';
import 'package:chatvibe/Views/Chat%20Screen/Widget/msg_container.dart';
import 'package:chatvibe/Views/Chat%20Screen/image_screen.dart';
import 'package:chatvibe/demo/Recorder.dart';
import 'package:chatvibe/helper/date_formate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class ChatScreen extends StatefulWidget {
  final String roomId;
  final String frdUserName;
  final String frdUId;
  const ChatScreen(
      {super.key,
      required this.roomId,
      required this.frdUserName,
      required this.frdUId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final box = GetStorage();
  final picker = ImagePicker();
  File? image;
  final TextEditingController _messageController = TextEditingController();
  ChatServices chatServices = ChatServices();
  ScrollController _scrollController = ScrollController();
  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1B202D),
      appBar: AppBar(
          title: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(widget.frdUId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map data = snapshot.data!.data() as Map;
            print("${data['lastActive']}");
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.frdUserName),
                SizedBox(
                  height: 0.2.h,
                ),
                Text(
                  data['status'] == "Online"
                      ? "Online"
                      : DateFormatUtil.formatTimeAgo(data['lastActive']),
                  style: TextStyle(
                      fontSize: 10.sp, color: Colors.white, letterSpacing: 0.5),
                )
              ],
            );
          } else {
            return Text(widget.frdUserName);
          }
        },
      )),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("chatRoom")
                .doc(widget.roomId)
                .collection("chats")
                .orderBy("DateTime", descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                    child:
                        CircularProgressIndicator()); // Loading indicator or placeholder
              }

              List chatDocuments = snapshot.data!.docs;
              List<String> chatDocumentsId =
                  snapshot.data!.docs.map((e) => e.id).toList();
              return ListView.builder(
                controller: _scrollController,
                itemCount: chatDocuments.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> chat =
                      chatDocuments[index].data() as Map<String, dynamic>;
                  bool isMe = false;
                  if (chat["senderId"] == box.read("uId")) {
                    isMe = true;
                  }
                  return isMe
                      ? Dismissible(
                          key: UniqueKey(),
                          onDismissed: (direction) async {
                            FirebaseFirestore.instance
                                .collection("chatRoom")
                                .doc(widget.roomId)
                                .collection("chats")
                                .doc(chatDocumentsId[index])
                                .delete();
                          },
                          child: MsgContainer(
                              msgType: chat['msgType'],
                              isMe: isMe,
                              msg: chat["msg"].toString()),
                        )
                      : MsgContainer(
                          msgType: chat['msgType'],
                          isMe: isMe,
                          msg: chat["msg"].toString());
                },
              );
            },
          )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Obx(() {
              return RecordHelper.isRecording.value == true
                  ? Container(
                      height: 7.h,
                      decoration: BoxDecoration(
                          color: const Color(0xff3D4354),
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              onPressed: () {
                                RecordHelper.stopRecording();
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                          SizedBox(
                              width: 60.w,
                              height: 50,
                              child: Lottie.asset(
                                  "asset/lottie/sound_waves.json",
                                  repeat: true,
                                  height: 70,
                                  fit: BoxFit.fill)),
                          IconButton(
                              onPressed: () {
                                RecordHelper.stopRecording();
                                RecordHelper.uploadRecordingToFirebase(
                                    widget.roomId);
                              },
                              icon: const Icon(
                                Icons.arrow_upward,
                                color: Colors.white,
                                size: 30,
                              ))
                        ],
                      ),
                    )
                  : TextField(
                      onChanged: (value) {
                        if (value == "") {
                          TextFieldOptionManage.setTrue();
                        } else {
                          TextFieldOptionManage.setFrue();
                        }
                      },
                      controller: _messageController,
                      onSubmitted: (value) async {
                        if (_messageController.text != "") {
                          _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.bounceOut);

                          await chatServices.sendChat(
                              roomId: widget.roomId,
                              message: _messageController.text.trim());
                          _messageController.clear();
                          TextFieldOptionManage.setTrue();
                        }
                      },
                      style: TextStyle(color: Colors.white, fontSize: 12.sp),
                      decoration: InputDecoration(
                          suffixIcon: Obx(
                            () {
                              return TextFieldOptionManage.show.value == true
                                  ? SizedBox(
                                      width: 150,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            onPressed: () async {
                                              XFile? file =
                                                  await picker.pickImage(
                                                      source:
                                                          ImageSource.gallery);
                                              image = File(file!.path);
                                              if (image != null) {
                                                Get.to(() => ImageScreen(
                                                      image: image,
                                                      roomId: widget.roomId,
                                                    ));
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.photo_camera_back_outlined,
                                              color: Color(0xff9398A7),
                                              size: 30,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              RecordHelper.startRecording();
                                            },
                                            child: const Icon(
                                              Icons.mic,
                                              size: 30,
                                              color: Color(0xff9398A7),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 7,
                                          )
                                        ],
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () async {
                                        if (_messageController.text != "") {
                                          _scrollController.animateTo(
                                              _scrollController
                                                  .position.maxScrollExtent,
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.bounceOut);

                                          await chatServices.sendChat(
                                              roomId: widget.roomId,
                                              message: _messageController.text
                                                  .trim());
                                          _messageController.clear();
                                          TextFieldOptionManage.setTrue();
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: Text(
                                          "Send",
                                          style: TextStyle(
                                              color: Colors.purpleAccent,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 11.sp),
                                        ),
                                      ));
                            },
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(
                              top: 0.6.h,
                              bottom: 0.6.h,
                              left: 1.w,
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                XFile? file = await picker.pickImage(
                                    source: ImageSource.camera);
                                image = File(file!.path);
                                if (image != null) {
                                  Get.to(() => ImageScreen(
                                        image: image,
                                        roomId: widget.roomId,
                                      ));
                                }
                              },
                              child: const CircleAvatar(
                                radius: 5,
                                backgroundColor: Color(0xff7a8194),
                                child: Center(
                                    child: Icon(
                                  Icons.camera_alt_outlined,
                                  color: Color(0xff1c222e),
                                )),
                              ),
                            ),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2.5.h),
                              borderSide:
                                  const BorderSide(color: Colors.transparent)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2.5.h),
                              borderSide:
                                  const BorderSide(color: Colors.transparent)),
                          filled: true,
                          fillColor: const Color(0xff3D4354)),
                    );
            }),
          ),
          SizedBox(
            height: 3.h,
          ),
        ],
      ),
    );
  }
}
