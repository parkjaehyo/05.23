import 'package:flutter/material.dart';
// Flutter의 UI 구성 요소를 가져옴 (AppBar, Scaffold, Text 등)

class FindScooterPage extends StatelessWidget {
  // StatelessWidget은 상태가 없는 정적인 화면을 만들 때 사용
  const FindScooterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold는 화면의 기본 구조를 만들어주는 위젯 (앱바, 본문 등 포함)
      appBar: AppBar(title: const Text("주변 킥보드 찾기")),

      // 앱 상단의 제목 바 (AppBar) – 제목은 "주변 킥보드 찾기"
      body: const Center(child: Text("지도에서 킥보드 찾기 기능")),
      // 본문에 텍스트가 가운데 정렬로 표시됨
      // 추후에 여기다가 지도를 넣거나, 킥보드 위치를 표시하는 UI가 들어갈 예정
    );
  }
}
