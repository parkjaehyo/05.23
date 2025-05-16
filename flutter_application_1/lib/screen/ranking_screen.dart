import 'package:flutter/material.dart';

class LeaderBoardItem {
  final String name;
  final int score;
  final String major;

  LeaderBoardItem({
    required this.name,
    required this.score,
    required this.major,
  });
}

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  List<LeaderBoardItem> items = [];

  @override
  void initState() {
    super.initState();
    generateDummyData();
  }

  @override
  Widget build(BuildContext context) {
    final top3 = items.take(3).toList();
    final rest = items.skip(3).toList();
    final majorRankings = _generateMajorRankings();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text("양심 랭킹")),
      body: Column(
        children: [
          // 🔝 Top 3 유저 고정
          Container(
            padding: const EdgeInsets.only(top: 30, bottom: 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFC107), Color(0xFFFFD54F)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildTopUser(top3.length > 1 ? top3[1] : null, rank: 2),
                buildTopUser(
                  top3.isNotEmpty ? top3[0] : null,
                  rank: 1,
                  isCenter: true,
                ),
                buildTopUser(top3.length > 2 ? top3[2] : null, rank: 3),
              ],
            ),
          ),

          // 📜 스크롤 가능한 하단 콘텐츠
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  ...rest.asMap().entries.map((entry) {
                    final rank = entry.key + 4;
                    return buildRankTile(entry.value, rank);
                  }),
                  const Divider(thickness: 1.5),
                  const SizedBox(height: 12),
                  const Text(
                    "📚 학과별 양심 랭킹 (평균 연체 기준)",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ...majorRankings.asMap().entries.map((entry) {
                    final rank = entry.key + 1;
                    final major = entry.value['major'];
                    final avg = entry.value['avg'];
                    final rankEmoji = ['🥇', '🥈', '🥉'];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              child: Text(
                                rank <= 3 ? rankEmoji[rank - 1] : '$rank',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                major,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              '-${avg.toStringAsFixed(1)}일',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔝 Top 3 사용자 카드
  Widget buildTopUser(
    LeaderBoardItem? user, {
    required int rank,
    bool isCenter = false,
  }) {
    if (user == null) return const SizedBox.shrink();
    final double size = isCenter ? 80 : 65;

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CircleAvatar(
              radius: size / 2,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: size / 2 - 4,
                backgroundColor: Colors.red.shade700,
                child: Text(
                  user.name.substring(0, 2),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$rank',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          user.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          user.major,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 2),
        Text(
          '-${user.score}일',
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
      ],
    );
  }

  /// 📋 일반 개인 랭킹 카드
  Widget buildRankTile(LeaderBoardItem user, int rank) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              radius: 16,
              child: Text(
                '$rank',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    user.major,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Text(
              '-${user.score}일',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  /// ⚙️ 더미 데이터
  void generateDummyData() {
    items = [
      LeaderBoardItem(name: '박재효', score: 10, major: 'AI소프트웨어학과'),
      LeaderBoardItem(name: '이상민', score: 9, major: 'AI소프트웨어학과'),
      LeaderBoardItem(name: '유저1', score: 7, major: '소프트웨어미디어산업경영공학과'),
      LeaderBoardItem(name: '유저2', score: 2, major: '소프트웨어미디어산업경영공학과'),
      LeaderBoardItem(name: '유저3', score: 6, major: '소프트웨어미디어산업경영공학과'),
      LeaderBoardItem(name: '유저3', score: 6, major: '소프트웨어미디어산업경영공학과'),
      LeaderBoardItem(name: '유저3', score: 6, major: '소프트웨어미디어산업경영공학과'),
    ];

    items.sort((a, b) => b.score.compareTo(a.score));
  }

  /// 📊 학과별 평균 점수
  List<Map<String, dynamic>> _generateMajorRankings() {
    final Map<String, List<int>> majorScores = {};
    for (var item in items) {
      majorScores.putIfAbsent(item.major, () => []);
      majorScores[item.major]!.add(item.score);
    }

    final List<Map<String, dynamic>> result =
        majorScores.entries.map((entry) {
          final avg = entry.value.reduce((a, b) => a + b) / entry.value.length;
          return {'major': entry.key, 'avg': avg};
        }).toList();

    result.sort((a, b) => b['avg'].compareTo(a['avg']));
    return result;
  }
}
