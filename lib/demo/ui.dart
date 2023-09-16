import 'package:chatvibe/demo/Recorder.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class UI extends StatefulWidget {
  const UI({super.key});

  @override
  State<UI> createState() => _UIState();
}

class _UIState extends State<UI> {
  bool isrecord = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: isrecord == true
                ? Container(
                    width: 90.w,
                    height: 70,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              RecordHelper.stopRecording();
                              setState(() {
                                isrecord = false;
                              });
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                        SizedBox(
                            width: 60.w,
                            height: 50,
                            child: Lottie.asset("asset/lottie/sound_waves.json",
                                repeat: true, height: 70, fit: BoxFit.fill)),
                        IconButton(
                            onPressed: () {
                              RecordHelper.stopRecording();
                              RecordHelper.uploadRecordingToFirebase("ASD");
                              setState(() {
                                isrecord = false;
                              });
                            },
                            icon: const Icon(
                              Icons.arrow_upward,
                              color: Colors.white,
                              size: 30,
                            ))
                      ],
                    ),
                  )
                : InkResponse(
                    onTap: () {
                      RecordHelper.startRecording();
                      setState(() {
                        isrecord = true;
                      });
                    },
                    child: Icon(
                      Icons.mic,
                      color: Colors.black,
                      size: 50,
                    ),
                  ),
          ),
          InkResponse(
            onTap: () {
              RecordHelper.playRecording("sac");
            },
            child: Container(
              color: Colors.blue,
              height: 100,
              width: 100,
              child: Icon(Icons.play_arrow),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
