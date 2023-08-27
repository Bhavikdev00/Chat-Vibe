import 'package:chatvibe/Firebase%20Services/update_profile_services.dart';
import 'package:chatvibe/Views/CommonWidget/common_button.dart';
import 'package:chatvibe/Views/CommonWidget/common_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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
                  child: Container(
                      width: 30.w,
                      height: 14.h,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                "asset/images/profile.jpg",
                              ),
                              fit: BoxFit.fitHeight),
                          shape: BoxShape.circle,
                          color: Colors.green)),
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
                    onPressed: () {
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
