import 'package:chatvibe/Firebase%20Services/chat_services.dart';
import 'package:chatvibe/Views/Chat%20Screen/Widget/msg_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
  final TextEditingController _messageController = TextEditingController();
  ChatServices chatServices = ChatServices();

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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.frdUserName),
                SizedBox(
                  height: 0.2.h,
                ),
                Text(
                  data['status'],
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: Column(
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
                                isMe: isMe, msg: chat["msg"].toString()),
                          )
                        : MsgContainer(isMe: isMe, msg: chat["msg"].toString());
                  },
                );
              },
            )),
            TextField(
              controller: _messageController,
              onSubmitted: (value) {
                chatServices.sendChat(
                    roomId: widget.roomId,
                    message: _messageController.text.trim());
                _messageController.clear();
              },
              style: TextStyle(color: Colors.white, fontSize: 12.sp),
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () async {
                        await chatServices.sendChat(
                            roomId: widget.roomId,
                            message: _messageController.text.trim());
                        _messageController.clear();
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Color(0xff9398A7),
                      )),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.5.h),
                      borderSide: const BorderSide(color: Colors.transparent)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.5.h),
                      borderSide: const BorderSide(color: Colors.transparent)),
                  filled: true,
                  fillColor: const Color(0xff3D4354)),
            ),
            SizedBox(
              height: 3.h,
            ),
          ],
        ),
      ),
    );
  }
}
