import 'dart:developer';

import 'package:chatvibe/Views/Authentication/signin_screen.dart';
import 'package:chatvibe/Views/CommonWidget/common_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../Firebase Services/auth_services.dart';
import '../CommonWidget/common_textformfield.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthServices authServices = AuthServices();
  bool showPass = true;

  FocusNode? focusNode;

  @override
  void initState() {
    focusNode = FocusNode();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
    fullNameController.dispose();
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff181a20),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 10.h,
                ),
                Center(
                  child: Text(
                    "Create new account",
                    style: TextStyle(color: Colors.white, fontSize: 22.sp),
                  ),
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                Center(
                  child: Text(
                    "Please fill in the form to continue",
                    style: TextStyle(
                        color: const Color(0xff56575c), fontSize: 12.sp),
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                CommonTextFormField(
                  controller: fullNameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Full Name';
                    }
                    return null; // Return null if validation passes
                  },
                  obscureText: false,
                  hintText: "Full Name",
                ),
                SizedBox(
                  height: 3.h,
                ),
                CommonTextFormField(
                  controller: userNameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your User Name';
                    } else if (!RegExp(r'^[a-zA-Z0-9_]*$').hasMatch(value)) {
                      return 'Username cannot contain special characters';
                    } else {
                      return null;
                    }
                  },
                  obscureText: false,
                  hintText: "User Name",
                ),
                SizedBox(
                  height: 3.h,
                ),
                CommonTextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Email';
                    }
                    if (!RegExp(
                            r'^[\w-]+(\.[\w-]+)*@([a-z\d-]+\.)*[a-z\d-]{2,}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  obscureText: false,
                  hintText: "Email",
                ),
                SizedBox(
                  height: 3.h,
                ),
                CommonTextFormField(
                  controller: passwordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters long';
                    }
                    return null;
                  },
                  hintText: "Password",
                  obscureText: showPass,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        showPass = !showPass;
                      });
                    },
                    child: Icon(
                      showPass
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(
                  height: 12.h,
                ),
                CommonButton(
                  text: "Sign Up",
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      bool available = await authServices
                          .isUsernameAvailable(userNameController.text);

                      if (available) {
                        // Validation successful, proceed with sign-up logic
                        String name = fullNameController.text.trim();
                        String userName = userNameController.text.trim();
                        String email = emailController.text.trim();
                        String password = passwordController.text.trim();
                        authServices.signUpService(
                            name: name,
                            userName: userName,
                            email: email,
                            password: password);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("UserName is Not Available"),
                          ),
                        );
                      }
                    }
                  },
                ),
                SizedBox(
                  height: 3.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an Account? ",
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500),
                    ),
                    GestureDetector(
                      onTap: () {
                        //navigate Login Page

                        Get.to(const SignInScreen(),
                            duration: const Duration(seconds: 1));
                      },
                      child: Text(
                        "Sign in",
                        style: TextStyle(
                            color: const Color(0xffA084E8),
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
