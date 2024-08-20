import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:leetcodeclone/Core_Project/Contest/contestclass.dart';
import 'package:leetcodeclone/Core_Project/Contest/leaderboard.dart';
import 'package:leetcodeclone/Core_Project/Contest/prev_contest.dart';
import 'package:leetcodeclone/Core_Project/Contest/register.dart';
import 'package:leetcodeclone/ImageScr/contestscreen.dart';

class FeaturedContest extends StatefulWidget {
  final Size size;
  const FeaturedContest({required this.size, super.key});

  @override
  State<FeaturedContest> createState() => _FeaturedContestState();
}

class _FeaturedContestState extends State<FeaturedContest> {
  List<Contest> contests = [];

  Future<List<Contest>> fetchContestsFromFirestore() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final QuerySnapshot snapshot =
        await firestore.collection('contests').orderBy('Contest_id').get();
    return snapshot.docs.map((doc) => Contest.fromFirestore(doc)).toList();
  }

  void generateList() async {
    try {
      List<Contest> fetchedContests = await fetchContestsFromFirestore();
      setState(() {
        contests = fetchedContests;
      });
    } catch (e) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    generateList();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: SizedBox(
          width: widget.size.width * 0.5,
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
                _buildFeaturedContests(context),
                const SizedBox(height: 40),
                _buildPastContestsAndRanking(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedContests(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(3, (i) => _buildContestItem(context, i)),
    );
  }

  Widget _buildContestItem(BuildContext context, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RegisterScreen(
                      contest: contests[index],
                    )));
          },
          child: Container(
            clipBehavior: Clip.antiAlias,
            width: widget.size.width * 0.15,
            height: widget.size.height * 0.17,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(featured[index]['image']),
                fit: BoxFit.fitHeight,
              ),
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
              "Online",
              style: TextStyle(fontSize: 10, color: Colors.green),
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
      height: widget.size.height * 0.85,
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
          PastContestsMenu(
            size: widget.size,
          ),
        ],
      ),
    );
  }

  Widget _buildGlobalRanking() {
    return SizedBox(
      height: widget.size.height * 0.8,
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
          Categories(size: widget.size),
        ],
      ),
    );
  }
}
