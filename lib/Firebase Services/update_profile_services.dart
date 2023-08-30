import 'package:chatvibe/Controllers/profile_data_controller.dart';
import 'package:chatvibe/Views/CommonWidget/error_message.dart';
import 'package:chatvibe/Views/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';

import 'auth_services.dart';

class UpdateProfileServices {
  final box = GetStorage();
  ProfileDataController profileDataController = Get.find();

  Future updateData(
      {required String email,
      required String username,
      required String fullname}) async {
    TextEditingController passwordController = TextEditingController();
    try {
      if (profileDataController.profileData['email'] != email) {
        Get.dialog(
          AlertDialog(
            title: Text("Please Enter Password",
                style: TextStyle(color: Colors.black, fontSize: 12.sp)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Password"),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(); // Close the dialog
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  String password = passwordController.text.trim();
                  String? email = FirebaseAuth.instance.currentUser!.email;
                  await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: email!, password: password)
                      .then(
                    (value) async {
                      if (profileDataController.profileData['username'] !=
                          username) {
                        bool isavailable =
                            await AuthServices.isUsernameAvailable(username);

                        if (isavailable == true) {
                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(box.read("uId"))
                              .update(
                                  {"username": username, "fullname": fullname});
                        } else {
                          errorMessageShow(
                              errorMessage: 'Username not available');
                        }
                      } else {
                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(box.read("uId"))
                            .update({"fullname": fullname});
                      }
                      Get.offAll(() => const HomeScreen());
                    },
                  );
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        );

        await FirebaseAuth.instance.currentUser!.updateEmail(email);
      } else {
        if (profileDataController.profileData['username'] != username) {
          bool isavailable = await AuthServices.isUsernameAvailable(username);

          if (isavailable == true) {
            await FirebaseFirestore.instance
                .collection("users")
                .doc(box.read("uId"))
                .update({"username": username, "fullname": fullname});
            Get.offAll(() => const HomeScreen());
          } else {
            errorMessageShow(errorMessage: 'Username not available');
          }
        } else {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(box.read("uId"))
              .update({"fullname": fullname});
          Get.offAll(() => const HomeScreen());
        }
      }
    } on FirebaseAuthException catch (e) {
      print("Error :- $e");
    }
  }
}
