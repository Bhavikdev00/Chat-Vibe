import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MsgContainer extends StatefulWidget {
  const MsgContainer({super.key, required this.isMe, required this.msg});
  final bool isMe;
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Container(
            decoration: BoxDecoration(
                color: widget.isMe
                    ? const Color(0xff7A8194)
                    : const Color(0xff373E4E),
                borderRadius: BorderRadius.circular(15)),
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                child: Text(
                  widget.msg,
                  style: const TextStyle(color: Colors.white),
                )),
          ),
        ),
      ],
    );
  }
}
