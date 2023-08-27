import 'package:chatvibe/Firebase%20Services/auth_services.dart';
import 'package:chatvibe/Views/Authentication/forgot_password_screen.dart';
import 'package:chatvibe/Views/Authentication/signup_screen.dart';
import 'package:chatvibe/Views/CommonWidget/common_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get_core/src/get_main.dart';

import '../CommonWidget/common_textformfield.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool showPass = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthServices authServices = AuthServices();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
                  height: 15.h,
                ),
                Center(
                  child: Text(
                    "Welcome Back!",
                    style: TextStyle(color: Colors.white, fontSize: 22.sp),
                  ),
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                Center(
                  child: Text(
                    "Please sign in to your account",
                    style: TextStyle(
                        color: const Color(0xff56575c), fontSize: 12.sp),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                CommonTextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Username or Email';
                    }
                    return null;
                  },
                  obscureText: false,
                  hintText: "Username or Email",
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
                  height: 1.5.h,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      // Forgot Password Code
                      Get.to(() => const ForgotPasswordScreen());
                    },
                    child: Text(
                      "Forgot password ?",
                      style: TextStyle(
                          color: const Color(0xff56575c), fontSize: 12.sp),
                    ),
                  ),
                ),
                SizedBox(
                  height: 12.h,
                ),
                CommonButton(
                  text: "Sign In",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Validation successful, proceed with sign-in logic
                      final String usernameOrEmail =
                          emailController.text.trim();
                      final String password = passwordController.text.trim();
                      authServices.signInService(
                          usernameOrEmail: usernameOrEmail, password: password);
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
                        // Navigate to Sign up Page
                        Get.to(const SignupScreen(),
                            duration: const Duration(seconds: 1));
                      },
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                            color: const Color(0xffA084E8),
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500),
                      ),
                    )
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
