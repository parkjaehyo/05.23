import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<NaverMapController> _mapControllerCompleter = Completer();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: NaverMap(
          options: const NaverMapViewOptions(
            indoorEnable: true,
            locationButtonEnable: false,
            consumeSymbolTapEvents: true,
            initialCameraPosition: NCameraPosition(
              target: NLatLng(37.4535, 129.1633), // 캠퍼스 중심
              zoom: 15,
            ),
          ),
          onMapReady: (controller) async {
            _mapControllerCompleter.complete(controller);

            /// ✅ 5공학관 마커 (기존 유지)
            final marker5 = NMarker(
              id: 'building_5gong',
              position: const NLatLng(37.453164, 129.159266),
              caption: const NOverlayCaption(text: '5공학관'),
            );

            marker5.setOnTapListener((NMarker m) {
              showDialog(
                context: context,
                builder:
                    (BuildContext context) => AlertDialog(
                      title: const Text('5공학관'),
                      content: const Text('강원대학교 삼척캠퍼스 5공학관 1층'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('닫기'),
                        ),
                      ],
                    ),
              );
            });

            await controller.addOverlay(marker5);

            /// ✅ 추가 마커들 (건물명으로 표시)
            final List<Map<String, dynamic>> buildingMarkers = [
              {
                'id': 'building_green_energy',
                'position': const NLatLng(37.451887, 129.162402),
                'title': '그린에너지관',
                'desc': '그린에너지관 1층 정문 앞 우산 대여함',
              },
              {
                'id': 'building_gym',
                'position': const NLatLng(37.453089, 129.165432),
                'title': '체육관',
                'desc': '체육관 후문 쪽 우산 대여함',
              },
              {
                'id': 'building_library',
                'position': const NLatLng(37.454140, 129.162222),
                'title': '도서관',
                'desc': '도서관 옆 우산 대여함 위치',
              },
            ];

            for (var data in buildingMarkers) {
              final marker = NMarker(
                id: data['id'],
                position: data['position'],
                caption: NOverlayCaption(text: data['title']),
              );

              marker.setOnTapListener((NMarker m) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(data['title']),
                      content: Text(data['desc']),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('닫기'),
                        ),
                      ],
                    );
                  },
                );
              });

              await controller.addOverlay(marker);
            }
          },
        ),
      ),
    );
  }
}
