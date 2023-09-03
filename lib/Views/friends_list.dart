import 'package:chatvibe/Controllers/Friends_data_controller.dart';
import 'package:chatvibe/Controllers/profile_data_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class FriendsListScreen extends StatefulWidget {
  const FriendsListScreen({super.key});

  @override
  State<FriendsListScreen> createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends State<FriendsListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1B202D),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkResponse(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(Icons.arrow_back,
                      color: Colors.white, size: 35)),
              GetBuilder<FriendsDataController>(
                  builder: (controller) => controller.friendDataList.isEmpty
                      ? const SizedBox()
                      : Expanded(
                          child: ListView.builder(
                            itemCount: controller.friendDataList.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> data =
                                  controller.friendDataList[index];
                              print("Bhavik ====>>> $data");
                              return ListTile(
                                leading: CircleAvatar(radius: 3.5.h),
                                contentPadding:
                                    EdgeInsets.only(left: 2.w, top: 2.5.h),
                                title: Text(
                                  data['username'],
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13.sp),
                                ),
                                trailing: InkResponse(
                                  onTap: () {},
                                  child: const Icon(
                                    Icons.delete_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                        )),
            ],
          ),
        ),
      ),
    );
  }
}
