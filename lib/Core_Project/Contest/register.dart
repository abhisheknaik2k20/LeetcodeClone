import 'dart:async';
import 'package:flutter/material.dart';
import 'package:leetcodeclone/Core_Project/CodeScreen/blackscreen.dart';
import 'package:leetcodeclone/Core_Project/Contest/contestclass.dart';
import 'package:leetcodeclone/Core_Project/Problemset/examples/exampleprobs.dart';

class RegisterScreen extends StatefulWidget {
  final Contest contest;
  final Problem problem;
  const RegisterScreen(
      {required this.problem, required this.contest, super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late Duration duration;
  Timer? timer;

  final _teamNameController = TextEditingController();
  String _registrationType = 'single';

  @override
  void initState() {
    super.initState();
    calculateDuration();
    startTimer();
  }

  void calculateDuration() {
    DateTime currentTime = DateTime.now();
    DateTime endTime = widget.contest.end.toDate();

    duration = endTime.isAfter(currentTime)
        ? endTime.difference(currentTime)
        : Duration.zero;

    if (duration == Duration.zero) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contest has already ended')),
      );
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (duration.inSeconds > 0) {
          duration = duration - const Duration(seconds: 1);
        } else {
          timer?.cancel();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Time is up!')),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _teamNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildTimerCard(),
              const SizedBox(height: 20),
              _buildPrizeSection(),
              const SizedBox(height: 20),
              _buildRegistrationSection(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.pink, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.code, color: Colors.pink, size: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "LeetCode Weekly ${widget.contest.Contest_id}",
              style: const TextStyle(
                fontSize: 24,
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
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.green[700]!, Colors.green[500]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.timer, color: Colors.white, size: 32),
            const SizedBox(width: 12),
            Text(
              '${_formatDurationWithDays(duration)} remaining',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDurationWithDays(Duration d) {
    final int days = d.inDays;
    final int hours = d.inHours.remainder(24);
    final int minutes = d.inMinutes.remainder(60);
    final int seconds = d.inSeconds.remainder(60);

    return '${days}d ${hours}h ${minutes}m ${seconds}s';
  }

  Widget _buildPrizeSection() {
    return _buildSection(
      title: '🏆 Prize Pool',
      content: _buildPrizeList(),
      icon: Icons.monetization_on,
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.pink, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.pink, size: 28),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }

  Widget _buildPrizeList() {
    final prizes = [
      '🥇 1st: 5000 points',
      '🥈 2nd: 2500 points',
      '🥉 3rd: 1000 points',
      '4th - 50th: 300 points',
      '51st - 100th: 100 points',
      '101st - 200th: 50 points',
      'Participation: 5 points',
      'First Time Participant: 200 points',
      'Participate Biweekly + Weekly: 35 points',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: prizes.map((prize) => _buildListItem(prize)).toList(),
    );
  }

  Widget _buildListItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          const Icon(Icons.star, color: Colors.pink, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.grey[400]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationSection() {
    return _buildSection(
      title: '📝 Register Now',
      content: _buildRegistrationForm(),
      icon: Icons.person_add,
    );
  }

  Widget _buildRegistrationForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListTile(
                title:
                    const Text('Single', style: TextStyle(color: Colors.white)),
                leading: Radio<String>(
                  value: 'single',
                  groupValue: _registrationType,
                  onChanged: (value) {
                    setState(() {
                      _registrationType = value!;
                    });
                  },
                  activeColor: Colors.pink[300],
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                title:
                    const Text('Team', style: TextStyle(color: Colors.white)),
                leading: Radio<String>(
                  value: 'team',
                  groupValue: _registrationType,
                  onChanged: (value) {
                    setState(() {
                      _registrationType = value!;
                    });
                  },
                  activeColor: Colors.pink[300],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_registrationType == 'team') ...[
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _showJoinTeamDialog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink[300],
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              textStyle: const TextStyle(fontSize: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Join Existing Team'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _showCreateTeamDialog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink[300],
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              textStyle: const TextStyle(fontSize: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Create New Team'),
          ),
        ] else ...[
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _registerAsSinglePlayer();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink[300],
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              textStyle: const TextStyle(fontSize: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Join as Single Player'),
          ),
        ],
      ],
    );
  }

  void _showJoinTeamDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Row(
          children: [
            Icon(Icons.group_add, color: Colors.pink[300]),
            const SizedBox(width: 8),
            Text(
              'Join Team',
              style: TextStyle(color: Colors.pink[300]),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter The Team ID",
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _teamNameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Enter the team ID to join",
                hintStyle: TextStyle(color: Colors.grey[500]),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.pink[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink[300]!),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: Colors.grey[400]),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (_teamNameController.text.isNotEmpty) {
                sendToBlackScreen(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink[300],
            ),
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }

  void _showCreateTeamDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Row(
          children: [
            Icon(Icons.create, color: Colors.pink[300]),
            const SizedBox(width: 8),
            Text(
              'Create New Team',
              style: TextStyle(color: Colors.pink[300]),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Create a Unique Team ID",
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _teamNameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Enter the team name",
                hintStyle: TextStyle(color: Colors.grey[500]),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.pink[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink[300]!),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: Colors.grey[400]),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_teamNameController.text.isNotEmpty) {
                sendToBlackScreen(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink[300],
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void sendToBlackScreen(BuildContext context) {
    Navigator.pop(context);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => BlackScreen(
            teamid: _teamNameController.text,
            isOnline: true,
            problem: widget.problem,
            size: MediaQuery.sizeOf(context))));
  }

  void _registerAsSinglePlayer() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registered as Single Player Successfully')),
    );
  }

  String _formatDuration(Duration d) {
    return '${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }
}
