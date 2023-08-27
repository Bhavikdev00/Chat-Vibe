import 'package:chatvibe/Views/Authentication/signin_screen.dart';
import 'package:chatvibe/Views/CommonWidget/common_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sizer/sizer.dart';

import '../../Firebase Services/auth_services.dart';
import '../CommonWidget/common_textformfield.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool showPass = true;
  TextEditingController emailController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AuthServices authServices = AuthServices();

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
                    "Forgot Password?",
                    style: TextStyle(color: Colors.white, fontSize: 22.sp),
                  ),
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                Center(
                  child: Text(
                    "Enter your registered email below to receive\npassword reset instruction",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: const Color(0xff56575c), fontSize: 12.sp),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                SvgPicture.asset("asset/images/svg/forgotpass.svg",
                    height: 25.h),
                SizedBox(
                  height: 7.h,
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
                  height: 5.h,
                ),
                CommonButton(
                  text: "Submit",
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Validation successful, proceed with sign-in logic
                      String email = emailController.text.toString();
                      await authServices.resetPassword(email);
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
                      "Remember password? ",
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to Sign in Page
                        Get.to(() => const SignInScreen());
                      },
                      child: Text(
                        "Sign in",
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
