import 'package:flutter/material.dart';

class SubmissionGraphPage extends StatelessWidget {
  final List<SubmissionData> sampleData = [
    SubmissionData(runtime: 10, percentPopulation: 5.0),
    SubmissionData(runtime: 20, percentPopulation: 15.0),
    SubmissionData(runtime: 30, percentPopulation: 60.0),
    SubmissionData(runtime: 40, percentPopulation: 25.0),
    SubmissionData(runtime: 50, percentPopulation: 15.0),
    SubmissionData(runtime: 60, percentPopulation: 7.0),
    SubmissionData(runtime: 70, percentPopulation: 3.0),
  ];

  SubmissionGraphPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SubmissionGraph(data: sampleData),
    );
  }
}

class SubmissionGraph extends StatefulWidget {
  final List<SubmissionData> data;

  const SubmissionGraph({super.key, required this.data});

  @override
  // ignore: library_private_types_in_public_api
  _SubmissionGraphState createState() => _SubmissionGraphState();
}

class _SubmissionGraphState extends State<SubmissionGraph>
    with TickerProviderStateMixin {
  late AnimationController _axesController;
  late AnimationController _pointsController;
  late AnimationController _linesController;
  late Animation<double> _axesAnimation;
  late Animation<double> _pointsAnimation;
  late Animation<double> _linesAnimation;

  @override
  void initState() {
    super.initState();

    _axesController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _pointsController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _linesController = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);

    _axesAnimation =
        CurvedAnimation(parent: _axesController, curve: Curves.easeOut);
    _pointsAnimation =
        CurvedAnimation(parent: _pointsController, curve: Curves.easeOutBack);
    _linesAnimation =
        CurvedAnimation(parent: _linesController, curve: Curves.easeInOut);

    _axesController.forward().then((_) =>
        _pointsController.forward().then((_) => _linesController.forward()));

    _axesAnimation.addListener(() => setState(() {}));
    _pointsAnimation.addListener(() => setState(() {}));
    _linesAnimation.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _axesController.dispose();
    _pointsController.dispose();
    _linesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(300, 200),
      painter: SubmissionGraphPainter(
        data: widget.data,
        axesProgress: _axesAnimation.value,
        pointsProgress: _pointsAnimation.value,
        linesProgress: _linesAnimation.value,
      ),
    );
  }
}

class SubmissionGraphPainter extends CustomPainter {
  final List<SubmissionData> data;
  final double axesProgress;
  final double pointsProgress;
  final double linesProgress;

  SubmissionGraphPainter({
    required this.data,
    required this.axesProgress,
    required this.pointsProgress,
    required this.linesProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final axisPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final linePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final pointPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4
      ..style = PaintingStyle.fill;

    // Draw axes
    canvas.drawLine(Offset(0, size.height),
        Offset(size.width * axesProgress, size.height), axisPaint);
    canvas.drawLine(Offset(0, size.height),
        Offset(0, size.height * (1 - axesProgress)), axisPaint);

    // Find max runtime
    final maxRuntime =
        data.map((d) => d.runtime).reduce((a, b) => a > b ? a : b);

    // Draw points and lines
    final path = Path();
    final pointsToDraw = (data.length * pointsProgress).floor();
    final linesToDraw = (data.length * linesProgress).floor();

    for (int i = 0; i < pointsToDraw; i++) {
      final x = (data[i].runtime / maxRuntime) * size.width;
      final y = size.height - (data[i].percentPopulation / 100) * size.height;

      if (i < linesToDraw) {
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      canvas.drawCircle(Offset(x, y), 3, pointPaint);
    }

    canvas.drawPath(path, linePaint);

    // Draw labels
    if (axesProgress == 1.0) {
      const textStyle = TextStyle(color: Colors.white, fontSize: 10);
      final textPainter = TextPainter(textDirection: TextDirection.ltr);

      // Draw y-axis labels (Percentage of Population)
      for (int i = 0; i <= 5; i++) {
        final percentage = (i * 20).toString();
        final label = '$percentage%';
        textPainter.text = TextSpan(text: label, style: textStyle);
        textPainter.layout();
        textPainter.paint(
            canvas, Offset(-30, size.height - (i / 5 * size.height) - 5));
      }
      for (int i = 0; i <= 5; i++) {
        final label = '${i * maxRuntime ~/ 5}ms';
        textPainter.text = TextSpan(text: label, style: textStyle);
        textPainter.layout();
        textPainter.paint(
            canvas, Offset((i / 5) * size.width - 10, size.height + 5));
      }
    }
  }

  @override
  bool shouldRepaint(covariant SubmissionGraphPainter oldDelegate) {
    return oldDelegate.axesProgress != axesProgress ||
        oldDelegate.pointsProgress != pointsProgress ||
        oldDelegate.linesProgress != linesProgress;
  }
}

class SubmissionData {
  final int runtime;
  final double percentPopulation;
  SubmissionData({required this.runtime, required this.percentPopulation});
}
