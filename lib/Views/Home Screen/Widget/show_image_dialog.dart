import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showImageDialog({required String imageUrl}) {
  Get.dialog(
      barrierDismissible: true,
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 300),
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          shadowColor: Colors.transparent,
          child: Center(
            child: CircleAvatar(
              radius: 90,
              backgroundImage: imageUrl != ""
                  ? CachedNetworkImageProvider(imageUrl)
                  : AssetImage("asset/images/profile.jpg") as ImageProvider,
            ),
          ),
        ),
      ));
}
