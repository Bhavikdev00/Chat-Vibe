// Import necessary packages
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// Define a class to manage user profile data
class ProfileDataController extends GetxController {
  final box = GetStorage();
  Map<String, dynamic> profileData = {};
  bool isLoading = false;

  // A function to retrieve user profile data from Firestore
  Future getProfileData() async {
    // Set isLoading to true to indicate data loading
    isLoading = true;
    update();

    // Retrieve user profile data from Firestore based on the user's ID
    var data = await FirebaseFirestore.instance
        .collection("users")
        .doc(box.read("uId"))
        .get();

    // Store the retrieved profile data in the profileData map
    profileData = data.data() as Map<String, dynamic>;

    // Set isLoading to false to indicate data loading is complete
    isLoading = false;
    update();
  }
}
