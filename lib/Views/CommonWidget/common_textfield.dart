import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CommonTextField extends StatefulWidget {
  final TextEditingController controller;
  final String autofillHints;
  const CommonTextField(
      {super.key, required this.controller, required this.autofillHints});

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      autofillHints: [widget.autofillHints],
      style: TextStyle(color: Colors.white, fontSize: 13.sp),
      decoration: InputDecoration(
        fillColor: const Color(0xff262a34),
        filled: true,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2.h),
            borderSide: const BorderSide(color: Color(0xff262a34))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2.h),
            borderSide: const BorderSide(color: Color(0xff262a34))),
      ),
    );
  }
}
