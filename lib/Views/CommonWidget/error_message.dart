import 'package:flutter/material.dart';
import 'package:get/get.dart';

void errorMessageShow({required String errorMessage}) {
  ScaffoldMessenger.of(Get.context!).showSnackBar(
    SnackBar(
      content: Text(
        errorMessage,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red,
    ),
  );
}
