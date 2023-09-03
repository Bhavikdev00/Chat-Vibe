import 'dart:io';

import 'package:chatvibe/Firebase%20Services/auth_services.dart';
import 'package:chatvibe/Firebase%20Services/update_profile_services.dart';
import 'package:chatvibe/Views/CommonWidget/common_button.dart';
import 'package:chatvibe/Views/CommonWidget/common_textformfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../Controllers/profile_data_controller.dart';
import 'CommonWidget/common_textfield.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  ProfileDataController profileDataController = Get.find();
  final box = GetStorage();
  FirebaseStorage storage = FirebaseStorage.instance;
  UpdateProfileServices updateProfileServices = UpdateProfileServices();
  TextEditingController userNameController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userNameController.text = profileDataController.profileData['username'];
    emailController.text = profileDataController.profileData['email'];
    fullNameController.text = profileDataController.profileData['fullname'];
  }

  @override
  void dispose() {
    super.dispose();
  }

  ImagePicker picker = ImagePicker();
  File? profileimage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1B202D),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkResponse(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 35)),
                SizedBox(
                  height: 2.h,
                ),
                Center(
                  child: InkResponse(
                    onTap: () async {
                      XFile? file =
                          await picker.pickImage(source: ImageSource.gallery);
                      profileimage = File(file!.path);
                      setState(() {});
                      print(file!.path);
                    },
                    child: Container(
                      width: 30.w,
                      height: 14.h,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: profileDataController.profileData["profile"] !=
                                  ""
                              ? NetworkImage(
                                  profileDataController.profileData["profile"])
                              : profileimage == null
                                  ? const AssetImage("asset/images/profile.jpg")
                                  : FileImage(profileimage!) as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 7.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 2.w),
                  child: const Text(
                    "UserName",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                CommonTextField(
                    controller: userNameController,
                    autofillHints: userNameController.text),
                SizedBox(
                  height: 3.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 2.w),
                  child: const Text(
                    "Full Name",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                CommonTextField(
                    controller: fullNameController,
                    autofillHints: fullNameController.text),
                SizedBox(
                  height: 3.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 2.w),
                  child: const Text(
                    "Email",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                CommonTextField(
                    controller: emailController,
                    autofillHints: emailController.text),
                SizedBox(
                  height: 20.h,
                ),
                Center(
                  child: CommonButton(
                    text: "Submit",
                    onPressed: () async {
                      String profileUrl = "";
                      if (profileimage != null) {
                        await storage
                            .ref("Profile/${box.read("uId")}.png")
                            .putFile(profileimage!)
                            .then(
                          (p0) async {
                            profileUrl = await p0.ref.getDownloadURL();
                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(box.read("uId"))
                                .update({"profile": profileUrl});
                          },
                        );
                      }

                      updateProfileServices.updateData(
                          email: emailController.text.trim(),
                          username: userNameController.text.trim(),
                          fullname: fullNameController.text.trim());
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
