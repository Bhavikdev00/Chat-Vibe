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
      required this.msgType,
      required this.isLike});
  final bool isMe;
  final String msgType;
  final String msg;
  final bool isLike;

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
                padding: EdgeInsets.only(
                    right: widget.isMe ? 3.w : 30.w,
                    left: widget.isMe ? 30.w : 15.w,
                    bottom: 15),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
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
                    widget.isLike
                        ? const Positioned(
                            bottom: -8,
                            left: 7,
                            child: Icon(Icons.favorite,
                                color: Colors.red, size: 18),
                          )
                        : const SizedBox(),
                  ],
                ),
              )
            : widget.msgType == "image"
                ? Padding(
                    padding: EdgeInsets.only(bottom: 15, right: 3.w, left: 3.w),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ClipRRect(
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
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                        widget.isLike
                            ? Positioned(
                                bottom: -8,
                                left: 7,
                                child: Icon(Icons.favorite,
                                    color: Colors.red, size: 20),
                              )
                            : SizedBox(),
                      ],
                    ),
                  )
                : widget.msgType == "mp3"
                    ? VoiceMessage(isMe: widget.isMe, url: "${widget.msg}")
                    : SizedBox(),
      ],
    );
  }
}
