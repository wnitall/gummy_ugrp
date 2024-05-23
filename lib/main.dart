import 'dart:async';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:tiktok_app_clone_flutter/core/services/app_routes.dart';
import 'package:tiktok_app_clone_flutter/src/controller/auth_controller.dart';
import 'package:tiktok_app_clone_flutter/src/view/auth/login_view.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

void main() async {
  await _initialize();
  KakaoSdk.init(
    nativeAppKey: '109954ae99f3fd6c1cfc4bb8aad2ca34',
    javaScriptAppKey: '354d318c19ad4cc101e516b2f5d228f4',
  );
  runApp(const MainApp());
}

Future<void> _initialize() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Firebase 초기화 및 GetX dependency 관리 시스템 AuthController 등록
  await Firebase.initializeApp().then(
    (value) {
      Get.put(AuthController());
    },
  );
  //Naver Map 초기화 및 오류 메시지
  await NaverMapSdk.instance.initialize(
      clientId: 'naver',
      onAuthFailed: (ex) => log("********* 네이버맵 인증오류 : $ex *********"));
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
