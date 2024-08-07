import 'package:cloud_firestore/cloud_firestore.dart';

class Problem {
  final String id;
  final String title;
  final String difficulty;
  final List<Map<String, dynamic>> content;
  final List<Map<String, dynamic>> testcases;
  final String status;
  final double acceptanceRate;
  final String frequency;

  Problem({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.content,
    required this.testcases,
    required this.status,
    required this.acceptanceRate,
    required this.frequency,
  });
  factory Problem.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Problem(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      difficulty: data['difficulty'] ?? '',
      content: (data['content'] as List<dynamic>?)
              ?.map((item) => item as Map<String, dynamic>)
              .toList() ??
          [],
      testcases: (data['testcases'] as List<dynamic>?)
              ?.map((item) => item as Map<String, dynamic>)
              .toList() ??
          [],
      status: data['status'] ?? '',
      acceptanceRate: (data['acceptanceRate'] as num?)?.toDouble() ?? 0.0,
      frequency: data['frequency'] ?? '',
    );
  }
}

//Keep this as Templet
List<Problem> problems = [
  Problem(
    id: '1',
    title: "Two Sum",
    status: "Solved",
    acceptanceRate: 47.5,
    difficulty: "Easy",
    frequency: "High",
    content: [
      {'text': 'Two Sum\n\n', 'fontSize': 24, 'isBold': true},
      {'text': 'Easy\n\n', 'color': 'green', 'isBold': true},
      {
        'text':
            'Given an array of integers nums and an integer target, return indices of the two numbers such that they add up to target.\n\n'
      },
      {
        'text':
            'You may assume that each input would have exactly one solution, and you may not use the same element twice.\n\n'
      },
      {'text': 'You can return the answer in any order.\n\n'},
      {'text': 'Constraints:\n', 'isBold': true},
      {'text': '• 2 <= nums.length <= 10^4\n'},
      {'text': '• -10^9 <= nums[i] <= 10^9\n'},
      {'text': '• -10^9 <= target <= 10^9\n'},
      {'text': '• Only one valid answer exists.\n'},
    ],
    testcases: [
      {
        'title': 'Test Case 1',
        'input': 'nums = [2,7,11,15], target = 9',
        'output': '[0,1]',
        'explain': 'Because nums[0] + nums[1] == 9, we return [0, 1].'
      },
      {
        'title': 'Test Case 2',
        'input': 'nums = [3,2,4], target = 6',
        'output': '[1,2]',
        'explain': 'Because nums[1] + nums[2] == 6, we return [1, 2].'
      },
      {
        'title': 'Test Case 3',
        'input': 'nums = [3,3], target = 6',
        'output': '[0,1]',
        'explain': 'Because nums[0] + nums[1] == 6, we return [0, 1].'
      },
    ],
  ),
];
