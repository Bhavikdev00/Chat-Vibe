import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CommonTextFormField extends StatefulWidget {
  const CommonTextFormField(
      {super.key,
      this.hintText,
      required this.validator,
      this.suffixIcon,
      required this.obscureText,
      this.controller,
      this.focusNode});
  final String? hintText;
  final FocusNode? focusNode;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextEditingController? controller;
  @override
  State<CommonTextFormField> createState() => _CommonTextFormFieldState();
}

class _CommonTextFormFieldState extends State<CommonTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 7.5.h, // Replace this height with your desired height
      decoration: BoxDecoration(
        color: const Color(0xff262a34),
        borderRadius: BorderRadius.circular(1.5.h),
        border: Border.all(color: Colors.transparent),
      ),
      child: TextFormField(
        focusNode: widget.focusNode,
        controller: widget.controller,
        validator: widget.validator,
        obscureText: widget.obscureText,
        cursorColor: Colors.grey,
        cursorHeight: 2.5.h,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            border: InputBorder.none,
            suffixIcon: widget.suffixIcon),
      ),
    );
  }
}
