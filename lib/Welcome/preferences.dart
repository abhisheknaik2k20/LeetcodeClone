import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LeetCode Preferences',
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      home: const PreferencesScreen(),
    );
  }
}

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  int _currentStep = 0;
  final int _totalSteps = 4;

  Map<String, dynamic> preferences = {
    'reason': '',
    'skillLevel': '',
    'topics': <String>[],
    'journey': <String>[],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                expandedHeight: 80,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  titlePadding: EdgeInsets.only(
                      left: MediaQuery.sizeOf(context).width * 0.05,
                      bottom: 16),
                  title: Row(
                    children: [
                      Image.asset(
                        "assets/images/logo.png",
                        width: 40,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'LeetCode',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      SizedBox(
                        height: MediaQuery.of(context).size.height - 250,
                        child: _buildCurrentStep(),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            textStyle: const TextStyle(fontSize: 18),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                          ),
                          onPressed: () {
                            if (_currentStep < _totalSteps - 1) {
                              setState(() {
                                _currentStep++;
                              });
                            } else {
                              print('Preferences completed: $preferences');
                            }
                          },
                          child: Text(_currentStep < _totalSteps - 1
                              ? 'Next'
                              : 'Start'),
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildProgressBar(),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 10,
            top: MediaQuery.of(context).size.height / 2 -
                28, // Center vertically
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  if (_currentStep > 0) {
                    setState(() {
                      _currentStep--;
                    });
                  }
                },
                icon: const Icon(Icons.arrow_back_ios),
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            right: 10,
            top: MediaQuery.of(context).size.height / 2 -
                28, // Center vertically
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  if (_currentStep < _totalSteps - 1) {
                    setState(() {
                      _currentStep++;
                    });
                  }
                },
                icon: const Icon(Icons.arrow_forward_ios),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return SizedBox(
      height: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: LinearProgressIndicator(
          value: (_currentStep + 1) / _totalSteps,
          backgroundColor: Colors.grey[800],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.pink),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildReasonStep();
      case 1:
        return _buildSkillLevelStep();
      case 2:
        return _buildTopicsStep();
      case 3:
        return _buildJourneyStep();
      default:
        return Container();
    }
  }

  Widget _buildReasonStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Hi LeetCoder, what brought you here?',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        _buildOptionButton(
            'Learn and enhance coding skills', Icons.code, 'learn'),
        const SizedBox(height: 15),
        _buildOptionButton('Prepare for interviews and get job offers',
            Icons.work, 'interview'),
      ],
    );
  }

  Widget _buildSkillLevelStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Which option best describes your coding skill?',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        Wrap(
          spacing: 15,
          runSpacing: 15,
          alignment: WrapAlignment.center,
          children: [
            _buildSkillLevelOption('Beginner', 'print("Hello LeetCoder")'),
            _buildSkillLevelOption('Intermediate', '// Binary Tree'),
            _buildSkillLevelOption('Advanced', '// Graph'),
            _buildSkillLevelOption('Expert', '// System Design'),
          ],
        ),
      ],
    );
  }

  Widget _buildTopicsStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Choose the topics you are interested most.',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: [
            _buildTopicChip('Dynamic Programming'),
            _buildTopicChip('Database'),
            _buildTopicChip('TypeScript'),
            _buildTopicChip('System Design'),
            _buildTopicChip('React'),
            _buildTopicChip('Machine Learning'),
            _buildTopicChip('Data Structure and Algorithms'),
            _buildTopicChip('Data Analysis'),
            _buildTopicChip('Spring Cloud'),
            _buildTopicChip('App Development'),
            _buildTopicChip('Unity Development'),
            _buildTopicChip('Software Testing'),
          ],
        ),
      ],
    );
  }

  Widget _buildJourneyStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Start your LeetCode Journey now!',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        _buildJourneyOption('Dynamic Programming', '10 Essential DP Patterns'),
        const SizedBox(height: 15),
        _buildJourneyOption(
            '30 Days of JavaScript', 'Learn JS Basics with 30 Qs'),
        const SizedBox(height: 15),
        _buildJourneyOption(
            'Programming Skills', 'Excel Implementation Skills in 50 Qs'),
      ],
    );
  }

  Widget _buildOptionButton(String text, IconData icon, String value) {
    bool isSelected = preferences['reason'] == value;
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(text),
      onPressed: () {
        setState(() {
          preferences['reason'] = value;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected ? Colors.pink : Colors.white.withOpacity(0.1),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        textStyle: const TextStyle(fontSize: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildSkillLevelOption(String level, String code) {
    bool isSelected = preferences['skillLevel'] == level;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          preferences['skillLevel'] = level;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected ? Colors.pink : Colors.white.withOpacity(0.1),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: SizedBox(
        width: 150,
        child: Column(
          children: [
            Text(code, style: TextStyle(fontSize: 12, color: Colors.grey[300])),
            const SizedBox(height: 5),
            Text(level, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicChip(String topic) {
    return FilterChip(
      label: Text(topic),
      backgroundColor: Colors.white.withOpacity(0.1),
      selectedColor: Colors.pink,
      checkmarkColor: Colors.white,
      selected: preferences['topics'].contains(topic),
      onSelected: (bool selected) {
        setState(() {
          if (selected) {
            preferences['topics'].add(topic);
          } else {
            preferences['topics'].remove(topic);
          }
        });
      },
    );
  }

  Widget _buildJourneyOption(String title, String subtitle) {
    bool isSelected = preferences['journey'].contains(title);
    return Container(
      width: 500,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey[300]),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 80),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isSelected ? Colors.pink : Colors.white.withOpacity(0.1),
            ),
            onPressed: () {
              setState(() {
                if (isSelected) {
                  preferences['journey'].remove(title);
                } else {
                  preferences['journey'].add(title);
                }
              });
            },
            child: Text(
              isSelected ? 'Joined' : 'Join',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
      ),
    );
  }
}
