import 'package:flutter/material.dart';
import 'screen/buildSideDrawer.dart';
import 'screen/ranking_screen.dart';
import 'screen/FindScooterPage.dart';
import 'screen/nfc_auth_screen.dart';
import 'screen/report_screen.dart';
import '/map_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _imageController = PageController();

  final List<String> imageUrls = [
    'https://wwwk.kangwon.ac.kr/site/campusmap/images/contents/samcheok/init_map_img.png',
    'https://cdn.kado.net/news/photo/200710/337099_81678_1642.jpg',
    'https://dormitory.kangwon.ac.kr/bbs/view_image.php?bo_table=4_1&fn=169153634_aHSwLcRb_c06654f43a80f4d7d3e529c04e4e8a4cf8836147.jpg',
  ];
  Widget buildPointStatusCard() {
    int currentday = 1;
    int maxday = 3;
    int couponCount = 1;
    double progress = currentday / maxday;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          // 본문 내용
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "박재효님의",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "남은 대여 시간 🚀",
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "$currentday / $maxday 일",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 🔼 오른쪽 위 쿠폰 배지
          Positioned(
            top: 8,
            right: 12,
            child: Row(
              children: [
                const Text(
                  'coupon',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.card_giftcard, size: 18, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  '$couponCount',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildSideDrawer(context),
      appBar: AppBar(
        title: const Text('양심 우산'),
        centerTitle: true,
        backgroundColor: Colors.amber, // ✅ 노란색 AppBar
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ✅ 사진 슬라이더
            SizedBox(
              height: 180,
              child: PageView.builder(
                controller: _imageController,
                itemCount: imageUrls.length,
                itemBuilder: (_, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(imageUrls[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            SmoothPageIndicator(
              controller: _imageController,
              count: imageUrls.length,
              effect: WormEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: Colors.amber,
              ),
            ),

            const SizedBox(height: 16),
            buildPointStatusCard(),

            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  buildCard(
                    context: context,
                    title: "대여소 찾기",
                    icon: Icons.map,
                    page: const MapScreen(),
                  ),
                  buildCard(
                    context: context,
                    title: "대여/반납",
                    icon: Icons.qr_code_scanner,
                    page: const NfcAuthScreen(),
                  ),
                  buildCard(
                    context: context,
                    title: "이용내역 확인",
                    icon: Icons.receipt_long,
                  ),
                  buildCard(
                    context: context,
                    title: "포인트 / 쿠폰",
                    icon: Icons.card_giftcard,
                  ),
                  buildCard(
                    context: context,
                    title: "양심 랭킹",
                    icon: Icons.emoji_events,
                    page: const RankingScreen(),
                  ),
                  buildCard(
                    context: context,
                    title: "신고하기",
                    icon: Icons.support_agent,
                    page: const ReportScreen(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    Widget? page,
  }) {
    return GestureDetector(
      onTap: () {
        if (page != null) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        }
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.green[800]),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
