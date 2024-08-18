import 'package:flutter/material.dart';
import 'package:leetcodeclone/Core_Project/Contest/leaderboard.dart';
import 'package:leetcodeclone/Core_Project/Contest/prev_contest.dart';
import 'package:leetcodeclone/ImageScr/contestscreen.dart';

class FeaturedContest extends StatelessWidget {
  final Size size;
  const FeaturedContest({required this.size, super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: SizedBox(
          width: size.width * 0.5,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                const Text(
                  "Featured Content",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _buildFeaturedContests(),
                const SizedBox(height: 40),
                _buildPastContestsAndRanking(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedContests() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(3, (i) => _buildContestItem(i)),
    );
  }

  Widget _buildContestItem(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          width: size.width * 0.15,
          height: size.height * 0.17,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage(featured[index]['image']),
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        Text("Contest 29$index"),
        Row(
          children: [
            Icon(
              Icons.timer_outlined,
              size: 15,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(width: 5),
            const Text(
              "Ended",
              style: TextStyle(fontSize: 10, color: Colors.blue),
            ),
            const SizedBox(width: 5),
            Text(
              "May 1, 2024",
              style:
                  TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.6)),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildPastContestsAndRanking() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: _buildPastContests(),
        ),
        Expanded(
          flex: 2,
          child: _buildGlobalRanking(),
        ),
      ],
    );
  }

  Widget _buildPastContests() {
    return Container(
      padding: const EdgeInsets.all(5),
      height: size.height * 0.85,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Past Contests",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 5),
          PastContestsMenu(size: size),
        ],
      ),
    );
  }

  Widget _buildGlobalRanking() {
    return SizedBox(
      height: size.height * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.leaderboard,
                color: Colors.white.withOpacity(0.6),
              ),
              const SizedBox(width: 5),
              Text(
                "Global Ranking",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Categories(size: size),
        ],
      ),
    );
  }
}
