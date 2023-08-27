import 'package:chatvibe/Firebase%20Services/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';

class ChatScreen extends StatefulWidget {
  final String roomId;
  final String frdUserName;
  const ChatScreen(
      {super.key, required this.roomId, required this.frdUserName});

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
      appBar: AppBar(title: Text(widget.frdUserName)),
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
                return ListView.builder(
                  itemCount: chatDocuments.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> chat =
                        chatDocuments[index].data() as Map<String, dynamic>;
                    bool isMe = false;
                    if (chat["senderId"] == box.read("uId")) {
                      isMe = true;
                    }
                    return Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          child: GestureDetector(
                            onLongPress: () {
                              //To do show popuo here under msg
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: isMe
                                      ? const Color(0xff7A8194)
                                      : const Color(0xff373E4E),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 1.5.h),
                                  child: Text(
                                    "${chat["msg"]}",
                                    style: const TextStyle(color: Colors.white),
                                  )),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            )),
            TextField(
              controller: _messageController,
              style: TextStyle(color: Colors.white, fontSize: 12.sp),
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () async {
                        await chatServices
                            .sendChat(
                                roomId: widget.roomId,
                                message: _messageController.text.trim())
                            .then((value) => printError(info: "Message Sent"));
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
