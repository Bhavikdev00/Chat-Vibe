import 'package:chatvibe/Views/Authentication/signin_screen.dart';
import 'package:chatvibe/Views/Authentication/signup_screen.dart';
import 'package:chatvibe/Views/Chat%20Screen/chat_screen.dart';
import 'package:chatvibe/Views/Home%20Screen/home_screen.dart';

import 'package:chatvibe/Views/profile_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';

import 'Views/Chat Screen/image_screen.dart';
import 'Views/Home Screen/Widget/sheemer_container.dart';
import 'demo/ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => GetMaterialApp(
        home:
            box.read("uId") != null ? const HomeScreen() : const SignInScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
