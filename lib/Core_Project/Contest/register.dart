import 'dart:async';
import 'package:flutter/material.dart';

class ContestScreen extends StatefulWidget {
  @override
  _ContestScreenState createState() => _ContestScreenState();
}

class _ContestScreenState extends State<ContestScreen> {
  Duration duration =
      Duration(minutes: 50); // Set your initial timer duration here
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (duration.inSeconds > 0) {
          duration = duration - Duration(seconds: 1);
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formatDuration(Duration d) {
      String minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
      String seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
      return '$minutes minutes $seconds seconds';
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Weekly Contest 101"),
            Container(
              padding: EdgeInsets.all(8.0),
              color: Colors.green[100],
              child: Text(
                'The contest has started. (${formatDuration(duration)} left)',
                style: TextStyle(color: Colors.green),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to the 411th LeetCode Weekly Contest',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'This LeetCode contest is sponsored by LeetCode.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Register for the contest in advance and fill out the survey to be selected for an interview with LeetCode!',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '🏆 Prize',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildPrizeList(),
            SizedBox(height: 20),
            Text(
              '⭐ Bonus Prizes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildBonusPrizeList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPrizeList() {
    final prizes = [
      '1st: 5000 coins',
      '2nd: 2500 coins',
      '3rd: 1000 coins',
      '4th - 50th: 300 coins',
      '51st - 100th: 100 coins',
      '101st - 200th: 50 coins',
      'Participation: 5 coins',
      'First Time Participant: 200 coins',
      'Participate Biweekly + Weekly: 35 coins',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: prizes
          .map((prize) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(prize),
              ))
          .toList(),
    );
  }

  Widget _buildBonusPrizeList() {
    final bonusPrizes = [
      '1st ~ 3rd: LeetCode Backpack',
      '4th ~ 10th: LeetCode Water Bottle',
      '11th ~ 16th: LeetCode Big O Notebook',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: bonusPrizes
          .map((bonus) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(bonus),
              ))
          .toList(),
    );
  }
}
