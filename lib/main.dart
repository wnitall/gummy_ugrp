import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:tiktok_app_clone_flutter/core/services/app_routes.dart';
import 'package:tiktok_app_clone_flutter/src/controller/auth_controller.dart';
import 'package:tiktok_app_clone_flutter/src/view/auth/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp().then(
    (value) {
      Get.put(AuthController());
    },
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Gummy',
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      getPages: AppRoutes.appRoute(),
      home: const LoginView(),
    );
  }
}
