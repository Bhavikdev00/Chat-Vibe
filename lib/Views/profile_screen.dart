import 'dart:developer';

import 'package:chatvibe/Controllers/profile_data_controller.dart';
import 'package:chatvibe/Firebase%20Services/auth_services.dart';
import 'package:chatvibe/Views/CommonWidget/common_button.dart';
import 'package:chatvibe/Views/edit_profile_screen.dart';
import 'package:chatvibe/Views/friends_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../Controllers/count_friend_requests.dart';
import 'notification_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  CountFrdRequest _countFrdRequest = CountFrdRequest();

  @override
  void initState() {
    super.initState();
    _countFrdRequest.CountFrdRequestData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1B202D),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: SafeArea(
          child: GetBuilder<ProfileDataController>(
            builder: (controller) => controller.isLoading == true
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkResponse(
                              onTap: () {
                                Get.back();
                              },
                              child: const Icon(Icons.arrow_back,
                                  color: Colors.white, size: 35)),
                          GestureDetector(
                            onTap: () {
                              AuthServices.logOut();
                            },
                            child: const Icon(
                              Icons.logout,
                              color: Colors.white,
                              size: 30,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Text(
                        "My",
                        style:
                            TextStyle(color: Colors.white70, fontSize: 16.sp),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Text(
                        "Profile",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 100.w,
                            height: 64.h,
                            color: const Color(0xff292F3F),
                            child: Column(children: [
                              SizedBox(
                                height: 17.h,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2.w),
                                child: Container(
                                  width: double.infinity,
                                  height: 8.h,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Full Name",
                                          style: TextStyle(
                                              color: Colors.white54,
                                              fontSize: 10.sp),
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        GetBuilder<ProfileDataController>(
                                          builder: (controller) => Text(
                                            controller.profileData['fullname'],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13.sp),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2.w),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 9.h,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Email",
                                          style: TextStyle(
                                              color: Colors.white54,
                                              fontSize: 10.sp),
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        GetBuilder<ProfileDataController>(
                                          builder: (controller) => Text(
                                            controller.profileData['email'],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13.sp),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                          Positioned(
                            top: -7.h,
                            left: 5.w,
                            right: 5.w,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 90.w,
                                  height: 20.h,
                                  decoration: BoxDecoration(
                                      color: const Color(0xff7A8194),
                                      borderRadius: BorderRadius.circular(2.h)),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 8.5.h,
                                      ),
                                      GetBuilder<ProfileDataController>(
                                        builder: (controller) => Text(
                                          controller.profileData['username'],
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13.sp),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InkResponse(
                                            onTap: () {
                                              Get.to(() =>
                                                  const FriendsListScreen());
                                            },
                                            child: SizedBox(
                                              height: 6.h,
                                              width: 30.w,
                                              child: Column(
                                                children: [
                                                  Text("Friends",
                                                      style: TextStyle(
                                                          letterSpacing: 0.8,
                                                          color: Colors.white,
                                                          fontSize: 12.sp)),
                                                  SizedBox(
                                                    height: 0.7.h,
                                                  ),
                                                  Obx(
                                                    () {
                                                      return Text(
                                                          "${_countFrdRequest.countFriends}",
                                                          style: TextStyle(
                                                              letterSpacing:
                                                                  0.8,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12.sp));
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          InkResponse(
                                            onTap: () {
                                              Get.to(() =>
                                                  const FriendRequestsScreen());
                                            },
                                            child: SizedBox(
                                              height: 6.h,
                                              width: 30.w,
                                              child: Column(
                                                children: [
                                                  Text("Requests",
                                                      style: TextStyle(
                                                          letterSpacing: 0.8,
                                                          color: Colors.white,
                                                          fontSize: 12.sp)),
                                                  SizedBox(
                                                    height: 0.7.h,
                                                  ),
                                                  Obx(
                                                    () {
                                                      return Text(
                                                          "${_countFrdRequest.countRequests}",
                                                          style: TextStyle(
                                                              letterSpacing:
                                                                  0.8,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12.sp));
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  top: -7.h,
                                  child: Container(
                                      width: 30.w,
                                      height: 14.h,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: controller.profileData[
                                                          "profile"] !=
                                                      ""
                                                  ? NetworkImage(controller
                                                      .profileData["profile"])
                                                  : const AssetImage(
                                                      "asset/images/profile.jpg",
                                                    ) as ImageProvider,
                                              fit: BoxFit.cover),
                                          shape: BoxShape.circle,
                                          color: Colors.green)),
                                )
                              ],
                            ),
                          ),
                          //Button
                          Positioned(
                            bottom: 30,
                            left: 4.w,
                            right: 4.w,
                            child: CommonButton(
                              text: "Update Profile",
                              onPressed: () {
                                Get.to(() => const EditProfileScreen());
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
