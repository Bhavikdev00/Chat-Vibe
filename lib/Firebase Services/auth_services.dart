import 'dart:developer';

import 'package:chatvibe/Views/Authentication/signin_screen.dart';
import 'package:chatvibe/Views/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

import '../Views/CommonWidget/error_message.dart';

class AuthServices {
  final box = GetStorage();
  Future signUpService({
    required String name,
    required String userName,
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      Get.dialog(const Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ));
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (credential.user != null) {
        await credential.user!.updateDisplayName(userName);
        await FirebaseFirestore.instance
            .collection("users")
            .doc(credential.user!.uid)
            .set({
          "username": userName,
          "email": email,
          "fullname": name,
          "profile": "",
          "uId": credential.user!.uid
        });
        box.write("uId", credential.user!.uid);
        log("------>>>> User Created");
      }
      Get.offAll(() => const HomeScreen());
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Somthing went Wrong !!";
      Get.back();
      if (e.code == 'weak-password') {
        errorMessage = "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        errorMessage = "The account already exists for that email.";
      } else if (e.code == 'user-not-found') {
        errorMessage = "No user found with that email.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Wrong password provided for this user.";
      }
      errorMessageShow(errorMessage: errorMessage);
    }
  }

  static Future<bool> isUsernameAvailable(String username) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    return result.docs.isEmpty;
  }

  Future<void> signInService(
      {required String usernameOrEmail, required String password}) async {
    try {
      UserCredential credential;
      Get.dialog(const Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ));
      if (usernameOrEmail.contains('@')) {
        // User provided an email
        credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: usernameOrEmail,
          password: password,
        );
        box.write("uId", credential.user!.uid);
        Get.offAll(() => const HomeScreen());
      } else {
        // User provided a username
        final String userEmail = await emailFromUsername(usernameOrEmail);
        if (userEmail != "") {
          credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email:
                userEmail, // You need to define a function to convert username to email
            password: password,
          );
          box.write("uId", credential.user!.uid);
          Get.offAll(() => const HomeScreen());
        } else {
          //provide msgfor check username}
          Get.back();
          errorMessageShow(errorMessage: "Please Check UserName");
        }
        // Handle successful login
      }
    } on FirebaseAuthException catch (e) {
      Get.back();
      String errorMessage = "An error occurred during login.";
      if (e.code == 'user-not-found') {
        errorMessage = "No user found with that email or username.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Wrong password provided for this user.";
      }
      errorMessageShow(errorMessage: errorMessage);
    }
  }

  Future<String> emailFromUsername(String username) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first['email'];
    }
    return ""; // Username not found
  }

  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email)
          .then((value) => Get.off(() => const SignInScreen()));
    } on FirebaseAuthException catch (e) {
      String errorMessage =
          "An error occurred while sending the password reset email.";
      if (e.code == 'invalid-email') {
        errorMessage = "Invalid email address.";
      } else if (e.code == 'user-not-found') {
        errorMessage = "No user found with that email address.";
      }

      errorMessageShow(errorMessage: errorMessage);
    }
  }

  static logOut() {
    final box = GetStorage();
    box.erase();
    Get.offAll(() => const SignInScreen());
  }
}
