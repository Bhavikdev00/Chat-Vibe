import 'dart:io';

import 'package:chatvibe/Firebase%20Services/chat_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../../Controllers/image_send_indicator.dart';

class ImageScreen extends StatefulWidget {
  final File? image;
  final String roomId;
  const ImageScreen({super.key, required this.image, required this.roomId});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await showDiscardPopupMenu(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xff1B202D),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 80.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          image: DecorationImage(
                              image: FileImage(widget.image!),
                              fit: BoxFit.fill),
                          borderRadius: BorderRadius.circular(3.h)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.h,
                ),
                Obx(
                  () {
                    return ImageSendIndicator.bool.value == false
                        ? GestureDetector(
                            onTap: () {
                              ChatServices.sendImage(
                                  roomId: widget.roomId,
                                  image: widget.image,
                                  myId: box.read("uId"));
                            },
                            child: Container(
                              height: 5.h,
                              width: 20.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text("Send",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 11.sp)),
                              ),
                            ),
                          )
                        : Container(
                            height: 5.h,
                            width: 20.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Center(
                              child: SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(
                                    color: Colors.grey,
                                  )),
                            ),
                          );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future showDiscardPopupMenu(BuildContext context) async {
    Get.dialog(Dialog(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.transparent)),
      child: Container(
          width: 300,
          height: 255,
          decoration: BoxDecoration(
              color: Colors.black87, borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 4.h),
              Text(
                "Discard photo?",
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
              SizedBox(height: 1.5.h),
              Text(
                "If you o back now, you will lose\nyour photo.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 11.sp,
                ),
              ),
              SizedBox(height: 2.h),
              const Divider(
                color: Colors.white10,
              ),
              SizedBox(height: 1.h),
              GestureDetector(
                onTap: () {
                  Get.back();
                  Get.back();
                },
                child: Text(
                  "Discard",
                  style: TextStyle(color: Colors.red, fontSize: 12.sp),
                ),
              ),
              SizedBox(height: 1.h),
              const Divider(
                color: Colors.white10,
              ),
              SizedBox(height: 1.h),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                ),
              )
            ],
          )),
    ));
  }
}
