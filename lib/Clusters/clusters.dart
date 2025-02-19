import 'package:flutter/material.dart';
import 'dart:math' show pi, cos, sin;

//  final userData = {
//       'user_id': userId,
//       'total_problems_solved': total,
//       'acceptance_rate': accrate,
//       'contest_rating': con_rate,
//       'easy_solved': easy,
//       'medium_solved': medium,
//       'hard_solved': hard,
//       'total_submissions': submissions,
//       'daily_streak': randomInt(0, 100),
//       'active_days_ratio': randomDouble(0.3, 0.9),
//       'is_premium': random.nextBool(),
//       'unique_topics_solved': randomInt(10, 40),
//       'created_at': FieldValue.serverTimestamp(),
//       'last_updated': FieldValue.serverTimestamp(),
//     };

// Add UserInfo class to represent user data
class UserInfo {
  final String userId;
  final String name;
  final Map<String, double> performance;
  final String avatarUrl;

  UserInfo({
    required this.userId,
    required this.name,
    required this.performance,
    required this.avatarUrl,
  });
}

class ClusterInfo {
  final String clusterId;
  final int userCount;
  final Map<String, double> metrics;
  final List<UserInfo> users;

  ClusterInfo({
    required this.clusterId,
    required this.userCount,
    required this.metrics,
    required this.users, // Add users parameter
  });
}

class ClusterDisplayScreen extends StatelessWidget {
  // Update sample data to include mock users
  final List<ClusterInfo> clusters = [
    ClusterInfo(
      clusterId: "Beginner Programmers",
      userCount: 3,
      metrics: {
        'Success Rate': 0.65,
        'Average Time': 0.8,
        'Easy Problems': 0.80,
        'Medium Problems': 0.15,
        'Hard Problems': 0.05,
      },
      users: [
        UserInfo(
          userId: "B1",
          name: "Abhishek Naik",
          performance: {'Success Rate': 0.667, 'Problems Solved': 2},
          avatarUrl: "https://i.pravatar.cc/150?u=alex",
        ),
        UserInfo(
          userId: "B2",
          name: "Ritojnan Mukherjee",
          performance: {'Success Rate': 0.667, 'Problems Solved': 2},
          avatarUrl: "https://i.pravatar. Vs c/150?u=emma",
        ),
        UserInfo(
          userId: "B3",
          name: "Pranav Patil",
          performance: {'Success Rate': 0.78, 'Problems Solved': 3},
          avatarUrl: "https://i.pravatar.cc/150?u=emma",
        ),
        // Add more users as needed
      ],
    ),
    ClusterInfo(
      clusterId: "Intermediate Coders",
      userCount: 5,
      metrics: {
        'Success Rate': 0.75,
        'Average Time': 0.6,
        'Easy Problems': 0.40,
        'Medium Problems': 0.50,
        'Hard Problems': 0.10,
      },
      users: [
        UserInfo(
          userId: "I1",
          name: "Michael Chen",
          performance: {'Success Rate': 0.78, 'Problems Solved': 45},
          avatarUrl: "https://i.pravatar.cc/150?u=michael",
        ),
        UserInfo(
          userId: "I2",
          name: "Sarah Johnson",
          performance: {'Success Rate': 0.72, 'Problems Solved': 38},
          avatarUrl: "https://i.pravatar.cc/150?u=sarah",
        ),
        UserInfo(
          userId: "I3",
          name: "James Rodriguez",
          performance: {'Success Rate': 0.76, 'Problems Solved': 42},
          avatarUrl: "https://i.pravatar.cc/150?u=james",
        ),
        UserInfo(
          userId: "I4",
          name: "Nina Patel",
          performance: {'Success Rate': 0.71, 'Problems Solved': 35},
          avatarUrl: "https://i.pravatar.cc/150?u=nina",
        ),
        UserInfo(
          userId: "I5",
          name: "Thomas Anderson",
          performance: {'Success Rate': 0.77, 'Problems Solved': 50},
          avatarUrl: "https://i.pravatar.cc/150?u=thomas",
        ),
      ],
    ),
    ClusterInfo(
      clusterId: "Expert Developers",
      userCount: 5,
      metrics: {
        'Success Rate': 0.90,
        'Average Time': 0.4,
        'Easy Problems': 0.20,
        'Medium Problems': 0.50,
        'Hard Problems': 0.30,
      },
      users: [
        UserInfo(
          userId: "E1",
          name: "David Lee",
          performance: {'Success Rate': 0.92, 'Problems Solved': 120},
          avatarUrl: "https://i.pravatar.cc/150?u=david",
        ),
        UserInfo(
          userId: "E2",
          name: "Lisa Wang",
          performance: {'Success Rate': 0.88, 'Problems Solved': 98},
          avatarUrl: "https://i.pravatar.cc/150?u=lisa",
        ),
        UserInfo(
          userId: "E3",
          name: "Marcus Schmidt",
          performance: {'Success Rate': 0.91, 'Problems Solved': 145},
          avatarUrl: "https://i.pravatar.cc/150?u=marcus",
        ),
        UserInfo(
          userId: "E4",
          name: "Sophia Martinez",
          performance: {'Success Rate': 0.89, 'Problems Solved': 112},
          avatarUrl: "https://i.pravatar.cc/150?u=sophia",
        ),
        UserInfo(
          userId: "E5",
          name: "Ryan Kim",
          performance: {'Success Rate': 0.93, 'Problems Solved': 135},
          avatarUrl: "https://i.pravatar.cc/150?u=ryan",
        ),
      ],
    ),
  ];

  ClusterDisplayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          SizedBox(
            height: 300,
            child: ClusterVisualization(clusters: clusters),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: clusters.length,
              itemBuilder: (context, index) {
                return ClusterCard(
                  cluster: clusters[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UserListScreen(cluster: clusters[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// New UserListScreen widget
class UserListScreen extends StatelessWidget {
  final ClusterInfo cluster;

  const UserListScreen({super.key, required this.cluster});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${cluster.clusterId} Users'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: cluster.users.length,
        itemBuilder: (context, index) {
          final user = cluster.users[index];
          return UserCard(user: user);
        },
      ),
    );
  }
}

// New ClusterVisualization Widget
class ClusterVisualization extends StatelessWidget {
  final List<ClusterInfo> clusters;

  const ClusterVisualization({super.key, required this.clusters});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ClusterPainter(clusters: clusters),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Cluster Distribution',
            ),
            const SizedBox(height: 8),
            Text(
              '${clusters.fold(0, (sum, cluster) => sum + cluster.userCount)} Total Users',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

// New UserCard widget
class UserCard extends StatelessWidget {
  final UserInfo user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: ListTile(
        leading: const CircleAvatar(
          radius: 25,
        ),
        title: Text(
          user.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: user.performance.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Text(
                    '${entry.key}: ',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    entry.key.contains('Rate')
                        ? '${(entry.value * 100).toStringAsFixed(1)}%'
                        : entry.value.toStringAsFixed(0),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // TODO: Implement detailed user view if needed
        },
      ),
    );
  }
}

// Modify ClusterCard to accept onTap callback
class ClusterCard extends StatelessWidget {
  final ClusterInfo cluster;
  final VoidCallback onTap;

  const ClusterCard({
    super.key,
    required this.cluster,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      cluster.clusterId,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${cluster.userCount} users',
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...cluster.metrics.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 150,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.grey.shade200,
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: entry.value.clamp(0.0, 1.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${(entry.value * 100).toStringAsFixed(1)}%',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

// Keep existing ClusterVisualization and ClusterPainter classes as they are
// Custom Painter for cluster visualization
class ClusterPainter extends CustomPainter {
  final List<ClusterInfo> clusters;

  ClusterPainter({required this.clusters});

  final List<Color> clusterColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius =
        size.width < size.height ? size.width / 2.5 : size.height / 2.5;

    // Calculate total users for percentage calculations
    final totalUsers =
        clusters.fold(0, (sum, cluster) => sum + cluster.userCount);

    // Draw connections between clusters
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.grey.withOpacity(0.3);

    // Draw cluster bubbles
    //double startAngle = 0;
    for (int i = 0; i < clusters.length; i++) {
      final cluster = clusters[i];
      final angle = 2 * pi * (i / clusters.length);

      // Calculate bubble position
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      final bubbleCenter = Offset(x, y);

      // Calculate bubble size based on user count
      final bubbleRadius = 50 * (cluster.userCount / totalUsers) + 20;

      // Draw connecting lines
      canvas.drawLine(center, bubbleCenter, paint);

      // Draw bubble
      final bubblePaint = Paint()
        ..style = PaintingStyle.fill
        ..color = clusterColors[i % clusterColors.length].withOpacity(0.7);

      canvas.drawCircle(bubbleCenter, bubbleRadius, bubblePaint);

      // Draw border
      final borderPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..color = clusterColors[i % clusterColors.length];

      canvas.drawCircle(bubbleCenter, bubbleRadius, borderPaint);

      // Draw cluster name and user count
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${cluster.clusterId}\n${cluster.userCount} users',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout(maxWidth: bubbleRadius * 2);
      textPainter.paint(
        canvas,
        Offset(
          bubbleCenter.dx - textPainter.width / 2,
          bubbleCenter.dy - textPainter.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
