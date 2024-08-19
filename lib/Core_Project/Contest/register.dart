import 'dart:async';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Duration duration = const Duration(minutes: 50);
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (duration.inSeconds > 0) {
          duration = duration - const Duration(seconds: 1);
        } else {
          timer?.cancel();
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
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 400, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildTimerCard(),
            const SizedBox(height: 32),
            _buildWelcomeSection(),
            const SizedBox(height: 32),
            _buildPrizeSection(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.pink[300]!, width: 2),
      ),
      child: Row(
        children: [
          Icon(Icons.code, color: Colors.pink[300], size: 40),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              "LeetCode Weekly Contest 411",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.pink[700]!, Colors.pink[500]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.timer, color: Colors.white, size: 36),
            const SizedBox(width: 16),
            Text(
              '${_formatDuration(duration)} remaining',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.pink[200]!, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to the 411th LeetCode Weekly Contest',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.pink[300],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'This contest is sponsored by LeetCode. Register now and complete the survey for a chance to interview with LeetCode!',
            style:
                TextStyle(fontSize: 16, height: 1.5, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildPrizeSection() {
    return _buildSection(
      title: '🏆 Prize Pool',
      content: _buildPrizeList(),
      icon: Icons.emoji_events,
    );
  }

  Widget _buildSection({
    required String title,
    required Widget content,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.pink[300]!, width: 2),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.pink[300], size: 32),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink[300],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  Widget _buildPrizeList() {
    final prizes = [
      '🥇 1st: 5000 coins',
      '🥈 2nd: 2500 coins',
      '🥉 3rd: 1000 coins',
      '4th - 50th: 300 coins',
      '51st - 100th: 100 coins',
      '101st - 200th: 50 coins',
      'Participation: 5 coins',
      'First Time Participant: 200 coins',
      'Participate Biweekly + Weekly: 35 coins',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: prizes.map((prize) => _buildListItem(prize)).toList(),
    );
  }

  Widget _buildListItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(Icons.star, color: Colors.pink[300], size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16, color: Colors.grey[400]),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    return '${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }
}
