import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:competitivecodingarena/Welcome/recommender/recommender.dart';

class DSARoadmapScreen extends StatefulWidget {
  const DSARoadmapScreen({super.key});

  @override
  _DSARoadmapScreenState createState() => _DSARoadmapScreenState();
}

class _DSARoadmapScreenState extends State<DSARoadmapScreen>
    with SingleTickerProviderStateMixin {
  List<RoadmapStep> steps = [];
  Map<int, Offset> nodePositions = {};
  late AnimationController _animationController;
  bool haveRoadMap = false;
  List mapData = [];
  Future<void>? _dataFuture;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..forward();
    _dataFuture = _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if the screen was navigated to with a result
    final bool? shouldReload =
        ModalRoute.of(context)?.settings.arguments as bool?;
    if (shouldReload == true) {
      _dataFuture = _loadData();
    }
  }

  Future<void> _loadData() async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;
      if (data != null && data['roadmap'] != null) {
        setState(() {
          haveRoadMap = true;
          mapData = List<Map<String, dynamic>>.from(data['roadmap']);
          steps = _initializeSteps();
        });
      }
    } on FirebaseException catch (e) {
      print(e.code);
    }
  }

  List<RoadmapStep> _initializeSteps() {
    List<Map<String, dynamic>> roadmapWithProgress =
        List<Map<String, dynamic>>.from(mapData);

    List<Color> colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.cyan
    ];

    List<RoadmapStep> steps = [];

    for (int i = 0; i < roadmapWithProgress.length; i++) {
      List<int> children = [];
      if (i == 0) {
        children = [2, 3];
      } else if (i == 1) {
        children = [4, 5];
      } else if (i == 2) {
        children = [6, 7];
      } else if (i == 5) {
        children = [8, 9];
      } else if (i == 6) {
        children = [10];
      }

      steps.add(RoadmapStep(
        i + 1,
        roadmapWithProgress[i]['title'],
        colors[i % colors.length],
        children,
        roadmapWithProgress[i]['progress'].toDouble(),
      ));
    }

    return steps;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return haveRoadMap
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.85,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      nodePositions.clear();
                      _calculatePositions(1, 0, constraints.maxWidth * 0.1,
                          constraints.maxWidth * 0.9, constraints.maxHeight);
                      return Stack(
                        children: [
                          CustomPaint(
                            size: Size(
                                constraints.maxWidth, constraints.maxHeight),
                            painter:
                                HierarchicalTreePainter(steps, nodePositions),
                          ),
                          ...steps.map((step) {
                            final position = nodePositions[step.number]!;
                            return AnimatedPositioned(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              left: position.dx - 40,
                              top: position.dy - 40,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    step.currentColor =
                                        step.currentColor.withOpacity(0.7);
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Tapped on ${step.title}')),
                                  );
                                },
                                child: NodeWidget(step: step),
                              ),
                            );
                          }),
                        ],
                      );
                    },
                  ),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height * 0.85,
                  child: Center(
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.map_outlined,
                                size: 80, color: Colors.pink),
                            const SizedBox(height: 20),
                            const Text(
                              "Create Your Coding Road-Map",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Embark on your coding journey with a personalized LeetCode RoadMap",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[600]),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const PreferencesScreen(),
                                  ),
                                )
                                    .then((result) {
                                  if (result == true) {
                                    setState(() {
                                      _dataFuture = _loadData();
                                    });
                                  }
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pink,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text("Create Roadmap",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
        }
      },
    );
  }

  void _calculatePositions(int stepIndex, int level, double leftBound,
      double rightBound, double height) {
    final step = steps[stepIndex - 1];
    final verticalSpacing = height / (steps.length * 0.5);
    final y = verticalSpacing * (level + 1);

    final availableWidth = rightBound - leftBound;
    final childCount = step.children.length;
    final x = leftBound + availableWidth / 2;

    nodePositions[step.number] = Offset(x, y);

    if (childCount > 0) {
      final childWidth = availableWidth / childCount;
      for (int i = 0; i < childCount; i++) {
        final childLeftBound = leftBound + i * childWidth;
        final childRightBound = childLeftBound + childWidth;
        _calculatePositions(step.children[i], level + 1, childLeftBound,
            childRightBound, height);
      }
    }
  }
}

class NodeWidget extends StatelessWidget {
  final RoadmapStep step;

  const NodeWidget({required this.step, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [step.currentColor, step.currentColor.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: step.currentColor.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 4),
            Text(
              step.title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

class RoadmapStep {
  final int number;
  final String title;
  final Color originalColor;
  Color currentColor;
  final List<int> children;
  double progress;

  RoadmapStep(
      this.number, this.title, this.originalColor, this.children, this.progress)
      : currentColor = originalColor;
}

class HierarchicalTreePainter extends CustomPainter {
  final List<RoadmapStep> steps;
  final Map<int, Offset> nodePositions;

  HierarchicalTreePainter(this.steps, this.nodePositions);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    void drawBranch(Offset start, Offset end) {
      final controlPoint1 =
          Offset(start.dx, start.dy + (end.dy - start.dy) * 0.7);
      final controlPoint2 =
          Offset(end.dx, start.dy + (end.dy - start.dy) * 0.3);

      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..cubicTo(
          controlPoint1.dx,
          controlPoint1.dy,
          controlPoint2.dx,
          controlPoint2.dy,
          end.dx,
          end.dy,
        );
      canvas.drawPath(path, paint);
    }

    for (var step in steps) {
      for (var childNumber in step.children) {
        drawBranch(nodePositions[step.number]!, nodePositions[childNumber]!);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
