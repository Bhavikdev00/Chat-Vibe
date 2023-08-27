import 'package:chatvibe/Firebase%20Services/chat_services.dart';
import 'package:chatvibe/Views/chat_screen.dart';
import 'package:chatvibe/Views/notification_screen.dart';
import 'package:chatvibe/Views/profile_screen.dart';
import 'package:chatvibe/Views/search_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CollectionReference chatRoom =
      FirebaseFirestore.instance.collection("chatRoom");
  final box = GetStorage();
  ChatServices _chatServices = ChatServices();
  CollectionReference? friends;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    friends = FirebaseFirestore.instance
        .collection("users")
        .doc(box.read("uId"))
        .collection("friends");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1B202D),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.5.w),
              child: Row(
                children: [
                  Text(
                    "Messages",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.sp),
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
                                fit: BoxFit.fitHeight),
                            shape: BoxShape.circle,
                            color: Colors.green)),
                  ),
                  // InkResponse(
                  //   onTap: () {
                  //     // Open Menu
                  //   },
                  //   child: PopupMenuButton<String>(
                  //     color: const Color(0xff444966),
                  //     splashRadius: 0,
                  //     elevation: 0,
                  //     onSelected: (value) {
                  //       // Handle menu item selection
                  //       if (value == 'settings') {
                  //         // Handle Settings action
                  //       } else if (value == 'profiles') {
                  //         // Handle Profiles action
                  //       } else if (value == 'notifications') {
                  //         // Handle Notifications action
                  //         Get.to(() => const FriendRequestsScreen());
                  //       }
                  //     },
                  //     itemBuilder: (BuildContext context) =>
                  //         <PopupMenuEntry<String>>[
                  //       PopupMenuItem<String>(
                  //         value: 'settings',
                  //         child: ListTile(
                  //           title: Text(
                  //             'Settings',
                  //             style: TextStyle(
                  //                 color: Colors.white, fontSize: 12.sp),
                  //           ),
                  //           leading:
                  //               const Icon(Icons.settings, color: Colors.white),
                  //         ),
                  //       ),
                  //       PopupMenuItem<String>(
                  //         value: 'profiles',
                  //         child: ListTile(
                  //           title: Text(
                  //             'Profiles',
                  //             style: TextStyle(
                  //                 color: Colors.white, fontSize: 12.sp),
                  //           ),
                  //           leading:
                  //               const Icon(Icons.person, color: Colors.white),
                  //         ),
                  //       ),
                  //       PopupMenuItem<String>(
                  //         value: 'notifications',
                  //         child: ListTile(
                  //           title: Text(
                  //             'Notifications',
                  //             style: TextStyle(
                  //                 color: Colors.white, fontSize: 12.sp),
                  //           ),
                  //           leading: const Icon(Icons.notifications,
                  //               color: Colors.white),
                  //         ),
                  //       ),
                  //       // You can add more menu items here
                  //     ],
                  //     child: Icon(
                  //       Icons.more_vert,
                  //       size: 3.5.h,
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
            SizedBox(
              height: 10.h,
              width: double.infinity,
              child: ListView.builder(
                itemCount: 10,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: CircleAvatar(
                      radius: 9.5.w,
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xff292F3F),
                  borderRadius: BorderRadiusDirectional.vertical(
                    top: Radius.circular(10.w),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: FutureBuilder(
                    future: friends!.get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        final friendsList = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: friendsList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final frd = friendsList[index];

                            return ListTile(
                              onTap: () async {
                                Map result =
                                    await _chatServices.isChatRoomExist(
                                        "${box.read("uId")}", frd["friendUid"]);
                                if (!result['isExist']) {
                                  await chatRoom
                                      .doc(
                                          "${box.read("uId")}-${frd["friendUid"]}")
                                      .set({
                                    "firstUid": box.read("uId"),
                                    "secondUid": frd["friendUid"],
                                  });
                                }
                                print(result);

                                Get.to(() => ChatScreen(
                                      frdUserName: frd["username"],
                                      roomId: result['isExist'] == true
                                          ? result['chatRoomId']
                                          : "${box.read("uId")}-${frd["friendUid"]}",
                                    ));

                                // print(result);
                              },
                              leading: CircleAvatar(radius: 3.5.h),
                              contentPadding:
                                  EdgeInsets.only(left: 2.w, top: 2.5.h),
                              title: Text(
                                "${frd['username']}",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13.sp),
                              ),
                              subtitle: Text(
                                "Hy",
                                style: TextStyle(
                                    color: Colors.white54, fontSize: 11.sp),
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      // if (!snapshot.hasData) {
                      //   return const Center(
                      //     child: Text("No Data Found"),
                      //   );
                      // }

                      // if (friendsList.isEmpty) {
                      //   return const Center(
                      //     child: Text(
                      //       'You have no friends yet.',
                      //       style: TextStyle(color: Colors.white),
                      //     ),
                      //   );
                      // }
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
