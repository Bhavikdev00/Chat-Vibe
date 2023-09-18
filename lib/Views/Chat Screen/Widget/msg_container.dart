import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatvibe/Views/Chat%20Screen/Widget/voidce_message.dart';
import 'package:chatvibe/demo/Recorder.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class MsgContainer extends StatefulWidget {
  const MsgContainer(
      {super.key,
      required this.isMe,
      required this.msg,
      required this.msgType});
  final bool isMe;
  final String msgType;
  final String msg;

  @override
  State<MsgContainer> createState() => _MsgContainerState();
}

class _MsgContainerState extends State<MsgContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        widget.msgType == "text"
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Container(
                  decoration: BoxDecoration(
                      color: widget.isMe
                          ? const Color(0xff7A8194)
                          : const Color(0xff373E4E),
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 3.w, vertical: 1.5.h),
                      child: Text(
                        widget.msg,
                        style: const TextStyle(color: Colors.white),
                      )),
                ),
              )
            : widget.msgType == "image"
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl: widget.msg,
                        height: 160,
                        width: 120,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) {
                          return SizedBox(
                            height: 160,
                            width: 120,
                            child: Shimmer.fromColors(
                              baseColor: Colors.black38,
                              highlightColor: Colors.white10,
                              child: Container(
                                height: 160,
                                width: 120,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white),
                              ),
                            ),
                          );
                        },
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  )
                : widget.msgType == "mp3"
                    ? VoiceMessage(isMe: widget.isMe, url: "${widget.msg}")
                    : SizedBox(),
      ],
    );
  }
}
