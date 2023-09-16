import 'package:audioplayers/audioplayers.dart';
import 'package:chatvibe/demo/Recorder.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class VoiceMessage extends StatefulWidget {
  const VoiceMessage({super.key, required this.isMe, required this.url});
  final bool isMe;
  final String url;
  @override
  State<VoiceMessage> createState() => _VoiceMessageState();
}

class _VoiceMessageState extends State<VoiceMessage> {
  AudioPlayer player = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isplaying = false;
  @override
  void initState() {
    player.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
      });
    });
    player.onPositionChanged.listen((event) {
      setState(() {
        position = event;
        // print(position);
      });
    });
    player.onPlayerComplete.listen((event) {
      setState(() {
        position = Duration.zero;
        isplaying = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2.w),
      child: Container(
          height: 6.h,
          width: 50.w,
          decoration: BoxDecoration(
            color:
                widget.isMe ? const Color(0xff7A8194) : const Color(0xff373E4E),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(children: [
            InkResponse(
              onTap: () {
                if (isplaying == false) {
                  player.play(
                    UrlSource(widget.url),
                  );
                  setState(() {
                    isplaying = true;
                  });
                } else {
                  player.pause();
                  setState(() {
                    isplaying = false;
                  });
                }

                // RecordHelper.playRecording(widget.url);
              },
              child: Icon(
                isplaying == false ? Icons.play_arrow : Icons.stop,
                color: isplaying == false ? Colors.greenAccent : Colors.red,
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 5,
                child: Slider(
                  max: duration.inSeconds.toDouble(),
                  value: position.inSeconds.toDouble(),
                  thumbColor: Colors.white38,
                  onChanged: (value) {},
                ),
              ),
            ),
            Text(
              "${duration.inSeconds.toDouble()}",
              style: TextStyle(color: Colors.white, fontSize: 10.sp),
            ),
            SizedBox(
              width: 2.w,
            )
          ])),
    );
  }
}
