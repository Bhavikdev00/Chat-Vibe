import 'package:chatvibe/Controllers/count_friend_requests.dart';
import 'package:chatvibe/Firebase%20Services/chat_services.dart';
import 'package:chatvibe/Firebase%20Services/friend_request_services.dart';
import 'package:chatvibe/Views/Chat%20Screen/chat_screen.dart';
import 'package:chatvibe/Views/Home%20Screen/Widget/show_image_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';

import '../Controllers/Friends_data_controller.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  FriendServices friendServices = FriendServices();
  final box = GetStorage();

  CollectionReference users = FirebaseFirestore.instance.collection("users");
  CollectionReference chatRoom =
      FirebaseFirestore.instance.collection("chatRoom");
  bool isLoading = true;
  List<Map<String, dynamic>> usersList = [];
  List<Map<String, dynamic>> allUsersList = [];
  TextEditingController searchController = TextEditingController();
  FriendsDataController _friendsDataController = Get.find();
  CountFrdRequest _countFrdRequest = CountFrdRequest();

  Future getAllData() async {
    var user =
        await users.where("uId", isNotEqualTo: "${box.read("uId")}").get();
    allUsersList.clear();
    for (var element in user.docs) {
      Map<String, dynamic> data = element.data() as Map<String, dynamic>;
      allUsersList.add(data);
      setState(() {});
    }

    setState(() {
      isLoading = false;
    });
  }

  Future getSearchData(String search) async {
    usersList.clear();
    allUsersList.forEach((element) {
      if (element['username']
          .toString()
          .toLowerCase()
          .contains(search.toLowerCase())) {
        usersList.add(element);
        setState(() {});
      }
    });
    print(allUsersList);
  }

  bool checkFriend(String friendId) {
    bool b = false;
    for (var element in _friendsDataController.friendDataList) {
      if (element['uId'] == friendId) {
        b = true;
      }
    }
    return b;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllData();
    _countFrdRequest.CountFrdRequestData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1B202D),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Column(
            children: [
              SizedBox(
                height: 2.h,
              ),
              TextField(
                controller: searchController,
                onChanged: (value) {
                  getSearchData(value);
                },
                style: TextStyle(color: Colors.white, fontSize: 13.sp),
                decoration: InputDecoration(
                    fillColor: const Color(0xff262a34),
                    hintText: "Search",
                    hintStyle:
                        TextStyle(color: Colors.white54, fontSize: 13.sp),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2.h),
                        borderSide: const BorderSide(color: Color(0xff262a34))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2.h),
                        borderSide: const BorderSide(color: Color(0xff262a34))),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    )),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: searchController.text.isEmpty
                      ? allUsersList.length
                      : usersList.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data = searchController.text.isEmpty
                        ? allUsersList[index]
                        : usersList[index];
                    return GestureDetector(
                      onTap: () async {
                        if (checkFriend(data['uId'])) {
                          Map result = await ChatServices.isChatRoomExist(
                              "${box.read("uId")}", data["uId"]);
                          if (!result['isExist']) {
                            await chatRoom
                                .doc("${box.read("uId")}-${data["uId"]}")
                                .set({
                              "firstUid": box.read("uId"),
                              "secondUid": data["uId"],
                              "LastChat": DateTime.now(),
                            });
                          }

                          Get.to(() => ChatScreen(
                                frdUId: data["uId"],
                                frdUserName: data["username"],
                                roomId: result['isExist'] == true
                                    ? result['chatRoomId']
                                    : "${box.read("uId")}-${data["uId"]}",
                              ));
                        }
                      },
                      child: ListTile(
                          leading: GestureDetector(
                            onLongPress: () {
                              showImageDialog(imageUrl: "${data['profile']}");
                            },
                            child: CircleAvatar(
                                radius: 3.5.h,
                                backgroundColor:
                                    const Color(0xff333e54).withOpacity(0.7),
                                backgroundImage: data['profile'] != ""
                                    ? NetworkImage(data["profile"])
                                    : const AssetImage(
                                        "asset/images/profile.jpg",
                                      ) as ImageProvider),
                          ),
                          contentPadding:
                              EdgeInsets.only(left: 2.w, top: 2.5.h),
                          title: Text(
                            data['username'],
                            style:
                                TextStyle(color: Colors.white, fontSize: 13.sp),
                          ),
                          trailing: checkFriend(data['uId'])
                              ? SizedBox()
                              : InkResponse(
                                  onTap: () {
                                    friendServices.sendFriendRequest(
                                        box.read("uId"), data['uId']);
                                  },
                                  child: const Icon(
                                    Icons.person_add_alt_1,
                                    color: Colors.white,
                                  ),
                                )),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
