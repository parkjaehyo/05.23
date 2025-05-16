import 'package:flutter/material.dart'; // Flutter의 UI 위젯 import
import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;
// dart:html은 웹 전용이므로 조건부 import 사용
//import 'conditional_import_stub.dart'
//  if (dart.library.html) 'conditional_import_web.dart';

import 'package:flutter/material.dart';

import 'package:flutter_naver_map/flutter_naver_map.dart';
// 다른 화면 파일 import
import 'screen/ranking_screen.dart'; // 양심 랭킹 화면
import 'screen/buildSideDrawer.dart'; // 햄버거 메뉴(사이드 드로어)
import 'screen/FindScooterPage.dart'; // 주변 킥보드 찾기 화면
import 'home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'back_end/db_connection.dart';
import 'splash_screen.dart';
import 'screen/nfc_auth_screen.dart';
import 'map_screen.dart';
import 'screen/ranking_screen.dart';
import 'screen/overdue_time_screen.dart';
import 'screen/report_screen.dart';
import 'services/fcm_service.dart';

/*
Future<void> _initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterNaverMap.init(
    clientId: '80v0v15qjo',
    onAuthFailed: (e) => log("네이버맵 인증 실패: $e"),
  );
}*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await _initialize();
  await Firebase.initializeApp(); // Firebase 초기화
  print('✅ Firebase 초기화 완료');

  //local db 연결
  //try {
  //await DatabaseHelper.connect(); // DB 연결 (로그는 내부에서 출력)
  //} catch (_) {
  // 실패해도 앱은 계속 실행되게 유지
  //}

  try {
    await FCMService().init(); // FCM 초기화
    print('✅ FCM 초기화 완료');
  } catch (e) {
    print('❌ FCM 초기화 실패: $e');
  }

  final flutterNaverMap = FlutterNaverMap(); // ✅ 인스턴스 생성
  await flutterNaverMap.init(
    clientId: '80v0v15qjo',
    onAuthFailed: (e) {
      print("네이버맵 인증 실패: $e");
    },
  );

  runApp(const MyApp()); // 앱 실행
}

// 앱 전체 구조 정의 (MaterialApp 포함)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '양심 우산 대여',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const HomePage(), // 홈 화면으로 이동
    );
  }
}
