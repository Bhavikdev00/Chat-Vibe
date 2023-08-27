import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CommonButton extends StatefulWidget {
  const CommonButton({super.key, required this.text, required this.onPressed});
  final String text;
  final Function()? onPressed;
  @override
  State<CommonButton> createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: widget.onPressed,
      height: 8.h,
      minWidth: 90.w,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.h)),
      color: Colors.blueGrey,
      //const Color(0xff5468ff),
      child: Text(
        widget.text,
        style: TextStyle(color: Colors.white, fontSize: 12.sp),
      ),
    );
  }
}
