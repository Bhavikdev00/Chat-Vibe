import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatvibe/Controllers/Friends_data_controller.dart';
import 'package:chatvibe/Controllers/count_unread_message.dart';
import 'package:chatvibe/Controllers/profile_data_controller.dart';
import 'package:chatvibe/Firebase%20Services/chat_services.dart';
import 'package:chatvibe/Views/Chat%20Screen/chat_screen.dart';
import 'package:chatvibe/Views/Home%20Screen/Widget/sheemer_container.dart';
import 'package:chatvibe/Views/notification_screen.dart';
import 'package:chatvibe/Views/profile_screen.dart';
import 'package:chatvibe/Views/search_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../../Controllers/online_friends_data_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  ProfileDataController profileDataController =
      Get.put(ProfileDataController());
  FriendsDataController friendsDataController =
      Get.put(FriendsDataController());

  CollectionReference chatRoom =
      FirebaseFirestore.instance.collection("chatRoom");
  final box = GetStorage();
  final ChatServices _chatServices = ChatServices();
  CollectionReference? friends;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    friends = FirebaseFirestore.instance
        .collection("users")
        .doc(box.read("uId"))
        .collection("friends");

    friendsDataController.getFriendsData();
    profileDataController.getProfileData();
    _chatServices.setStatus("Online");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      _chatServices.setStatus("Online");
    } else {
      // offline
      _chatServices.setStatus("Offline");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(
          const Duration(seconds: 1),
          () {
            friendsDataController.getFriendsData();
            setState(() {});
          },
        );
      },
      child: Scaffold(
        backgroundColor: const Color(0xff1B202D),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 1.5.w),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        friendsDataController.getFriendsData();
                        setState(() {});
                      },
                      child: Text(
                        "Messages",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22.sp),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                        splashRadius: 0.5,
                        onPressed: () {
                          Get.to(() => const SearchScreen());
                        },
                        icon: Image.asset(
                          "asset/images/search.png",
                          color: Colors.white,
                          height: 3.5.h,
                        )),
                    SizedBox(
                      width: 1.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const ProfileScreen());
                      },
                      child: Container(
                          width: 7.w,
                          height: 5.h,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                    "asset/images/profile.jpg",
                                  ),
                                  fit: BoxFit.cover),
                              shape: BoxShape.circle,
                              color: Colors.green)),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Expanded(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: GetBuilder<FriendsDataController>(
                      builder: (controller) {
                        return controller.isloading
                            ? const Center(
                                child: ShemmerContainer(),
                              )
                            : controller.friendDataList.isEmpty
                                ? Lottie.asset("asset/lottie/chat-bot.json",
                                    height: 230)
                                : ListView.builder(
                                    itemCount: controller.friendDataList.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      final frd =
                                          controller.friendDataList[index];
                                      return ListTile(
                                        onTap: () async {
                                          Map result = await ChatServices
                                              .isChatRoomExist(
                                                  "${box.read("uId")}",
                                                  frd["uId"]);
                                          if (!result['isExist']) {
                                            await chatRoom
                                                .doc(
                                                    "${box.read("uId")}-${frd["uId"]}")
                                                .set({
                                              "firstUid": box.read("uId"),
                                              "secondUid": frd["uId"],
                                              "LastChat": DateTime.now(),
                                            });
                                          }

                                          Get.to(() => ChatScreen(
                                                frdUId: frd["uId"],
                                                frdUserName: frd["username"],
                                                roomId: result['isExist'] ==
                                                        true
                                                    ? result['chatRoomId']
                                                    : "${box.read("uId")}-${frd["uId"]}",
                                              ));

                                          // print(result);
                                        },
                                        leading: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(120),
                                          child: CachedNetworkImage(
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.fill,
                                              imageUrl: "${frd['profile']}",
                                              progressIndicatorBuilder:
                                                  (context, url,
                                                      downloadProgress) {
                                                return SizedBox(
                                                  child: Shimmer.fromColors(
                                                    baseColor: Colors.black38,
                                                    highlightColor:
                                                        Colors.white10,
                                                    child: Container(
                                                      height: 60,
                                                      width: 60,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                );
                                              },
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Image.asset(
                                                        "asset/images/profile.jpg",
                                                        fit: BoxFit.fill,
                                                      )),
                                        ),
                                        contentPadding: EdgeInsets.only(
                                            left: 2.w, top: 2.5.h),
                                        title: Text(
                                          "${frd['username']}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13.sp),
                                        ),
                                      );
                                    },
                                  );
                      },
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
