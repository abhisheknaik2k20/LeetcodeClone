import 'package:flutter/material.dart';
import 'package:leetcodeclone/Core_Project/Contest/banner.dart';
import 'package:leetcodeclone/Core_Project/Contest/featured.dart';
import 'package:leetcodeclone/Core_Project/Problemset/containers/ads_cal.dart';
import 'package:leetcodeclone/Core_Project/Problemset/containers/appbar.dart';
import 'package:leetcodeclone/Core_Project/Problemset/containers/problemset.dart';

class LeetCodeProblemsetHomescreen extends StatefulWidget {
  final Size size;
  const LeetCodeProblemsetHomescreen({required this.size, super.key});

  @override
  State<LeetCodeProblemsetHomescreen> createState() =>
      _LeetCodeProblemsetHomescreenState();
}

class _LeetCodeProblemsetHomescreenState
    extends State<LeetCodeProblemsetHomescreen> {
  String selectedItem = "Problems";

  List<Widget> buildHeader() {
    return [
      HomeAppBar(
        setItem: setItem,
      ),
      const SliverToBoxAdapter(
        child: SizedBox(
          height: 30,
        ),
      ),
    ];
  }

  List<Widget> buildProblemScreen() {
    return [
      SliverToBoxAdapter(child: AdsAndCalender(size: widget.size)),
      SliverToBoxAdapter(
          child: ProblemsetMenu(
        size: widget.size,
      )),
    ];
  }

  setItem(String item) {
    setState(() {
      selectedItem = item;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          ...buildHeader(),
          ...switch (selectedItem) {
            'Problems' => buildProblemScreen(),
            'Contest' => [
                ScreenBanner(size: widget.size),
                FeaturedContest(size: widget.size)
              ],
            _ => []
          },
        ],
      ),
    );
  }
}
