import 'package:flutter/material.dart';
import 'package:leetcodeclone/Core_Project/CodeScreen/dragcontain.dart';
import 'package:leetcodeclone/Core_Project/Problemset/examples/exampleprobs.dart';

class BlackScreen extends StatefulWidget {
  final Problem problem;
  final Size size;
  const BlackScreen({required this.problem, required this.size, super.key});

  @override
  State<BlackScreen> createState() => _BlackScreenState();
}

class _BlackScreenState extends State<BlackScreen> {
  List<Widget> containers = [];
  List<Map<String, dynamic>> availableContainers = [
    {'name': 'Description', 'icon': Icons.description, 'color': Colors.red},
    {'name': 'Code', 'icon': Icons.code, 'color': Colors.blue},
    {'name': 'Solutions', 'icon': Icons.lightbulb, 'color': Colors.yellow},
    {'name': 'TestCases', 'icon': Icons.check_box, 'color': Colors.green},
    {'name': 'Console', 'icon': Icons.check_box, 'color': Colors.indigo},
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: widget.size.height,
        width: widget.size.width,
        child: Stack(
          children: [
            ...containers,
            Positioned(
              left: 0,
              right: 0,
              child: SizedBox(
                height: 50,
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: availableContainers
                        .map((container) => TextButton.icon(
                              onPressed: () => _addContainer(
                                  widget.problem,
                                  container['name'],
                                  container['icon'],
                                  container['color']),
                              icon: Icon(container['icon'],
                                  color: container['color']),
                              label: Text(
                                container['name'],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addContainer(
      Problem problem, String name, IconData icon, MaterialColor color) {
    setState(() {
      containers.add(
        DraggableResizableContainer(
          problem: problem,
          color: color,
          icon: icon,
          key: Key('container_$name'),
          initialPosition: Offset(20.0 * (containers.length + 1), 70.0),
          initialSize: Size(widget.size.width * 0.3, widget.size.height * 0.3),
          minSize: const Size(100, 100),
          maxSize: Size(widget.size.width * 0.9, widget.size.height * 0.9),
          onRemove: _removeContainer,
          label: name,
          returnToButtonBar: _returnToButtonBar,
          bringToFront: _bringContainerToFront,
        ),
      );
      availableContainers.removeWhere((container) => container['name'] == name);
    });
  }

  void _removeContainer(Key key) {
    setState(() {
      containers.removeWhere((container) => container.key == key);
    });
  }

  void _returnToButtonBar(String name, IconData icon, MaterialColor color) {
    setState(() {
      containers
          .removeWhere((container) => container.key == Key('container_$name'));
      if (!availableContainers.any((container) => container['name'] == name)) {
        availableContainers.add({'name': name, 'icon': icon, 'color': color});
      }
    });
  }

  void _bringContainerToFront(Key key) {
    setState(() {
      int index = containers.indexWhere((container) => container.key == key);
      if (index != -1) {
        Widget container = containers.removeAt(index);
        containers.add(container);
      }
    });
  }
}
